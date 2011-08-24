# Define: nginx::site::passenger
#
# Create a passenger site config from template using parameters.
#
# Parameters :
# 	* ensure: typically set to "present" or "absent". Defaults to "present"
# 	* root: document root (Required)
#	* server_name : server_name directive (could be an array)
#	* listen : address/port the server listen to. Defaults to 80. Auto enable ssl if 443
#	* access_log : custom acces logs. Defaults to /var/log/nginx/$name_access.log
#	* include : custom include for the site (could be an array). Include files must exists 
#	   to avoid nginx reload errors. Use with nginx::site_include  
#	* ssl_certificate : ssl_certificate path. If empty auto-generating ssl cert
#	* ssl_certificate_key : ssl_certificate_key path. If empty auto-generating ssl cert key
#   See http://wiki.nginx.org for details.
#
# Templates :
#	* nginx/passenger_site.erb
#
# Sample Usage :
#         nginx::passenger::site {"default":
#                 root            => "/var/www/nginx-default",
#                 server_name     => ["localhost", "$hostname", "$fqdn"],
#          }
#
#         nginx::passenger::site {"default-ssl":
#                 listen          => "443",
#                 root            => "/var/www/nginx-default",
#                 server_name     => "$fqdn",
#          }
define nginx::site::passenger ($ensure = 'present',
                               $index = 'index.php',
                               $root, $include = '',
                               $listen = '80',
                               $server_name = '',
                               $access_log = '',
                               $ssl_certificate = '',
                               $ssl_certificate_key = '',
                               $ssl_session_timeout = '5m') { 
	$real_server_name = $server_name ? { 
		''      => $name,
    default => $server_name,
  }

	$real_access_log = $access_log ? { 
		''      => "/var/log/nginx/${name}_access.log",
    default => $access_log,
  }

	#Autogenerating ssl certs
	if $listen == '443' and $ensure == 'present' and ($ssl_certificate == '' or $ssl_certificate_key == '') {
		exec { "generate-${name}-certs":
			command => "/usr/bin/openssl req -new -inform PEM -x509 -nodes -days 999 -subj '/C=ZZ/ST=AutoSign/O=AutoSign/localityName=AutoSign/commonName=${real_server_name}/organizationalUnitName=AutoSign/emailAddress=AutoSign/' -newkey rsa:2048 -out ${nginx::params::ssldir}/${name}.pem -keyout ${nginx::params::ssldir}/${name}.key",
			unless	=> "/usr/bin/test -f ${nginx::params::ssldir}/${name}.pem",
			notify	=> Exec['reload-nginx'],
			require	=> File[$nginx::params::ssldir],
		}
	}

	$real_ssl_certificate = $ssl_certificate ? { 
		''      => "${nginx::params::ssldir}/${name}.pem",
    default => $ssl_certificate,
  }
  
	$real_ssl_certificate_key = $ssl_certificate_key ? { 
		''      => "${nginx::params::ssldir}/${name}.key",
    default => $ssl_certificate_key,
  }

	nginx::site { $name:
		ensure	=> $ensure,
		content	=> template("nginx/site/passenger.erb"),
	}
}
