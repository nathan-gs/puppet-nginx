# Define: nginx::site::fcgi
#
# Create a fcgi site config from template using parameters.
# You can use my php5-fpm class to manage fastcgi servers.
#
# Parameters :
# 	* ensure: typically set to "present" or "absent". Defaults to "present"
# 	* root: document root (Required)
#	* fastcgi_pass : port or socket on which the FastCGI-server is listening (Required)
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
#	* nginx/fcgi/site.erb
#
# Sample Usage :
#   nginx::site::fcgi { 'default':
#     root         => '/var/www/nginx-default',
#     fastcgi_pass => '127.0.0.1:9000',
#     server_name  => [ 'localhost', $hostname, $fqdn ],
#   }
#
#   nginx::site::fcgi {"default-ssl":
#     listen       => '443',
#     root         => '/var/www/nginx-default',
#     fastcgi_pass => '127.0.0.1:9000',
#     server_name  => $fqdn,
#   }
define nginx::site::fcgi ($root,
                          $fastcgi_pass,
                          $ensure              = 'present',
                          $index               = 'index.php',
                          $include             = '',
                          $listen              = '80',
                          $server_name         = '',
                          $access_log          = '',
                          $ssl_certificate     = '',
                          $ssl_certificate_key = '',
                          $ssl_session_timeout = '5m') {
  include nginx::fcgi

  $real_server_name = $server_name ? { 
    ''      => $name,
    default => $server_name,
  }

	$real_access_log = $access_log ? { 
		''      => "/var/log/nginx/${name}_access.log",
    default => $access_log,
  }

	#Autogenerating ssl certs
	if $listen == '443' and $ensure == 'present' and ( $ssl_certificate == '' or $ssl_certificate_key == '') {
		exec { "generate-${name}-certs":
			command => "/usr/bin/openssl req -new -inform PEM -x509 -nodes -days 999 -subj '/C=ZZ/ST=AutoSign/O=AutoSign/localityName=AutoSign/commonName=${real_server_name}/organizationalUnitName=AutoSign/emailAddress=AutoSign/' -newkey rsa:2048 -out /etc/nginx/ssl/${name}.pem -keyout /etc/nginx/ssl/${name}.key",
			unless	=> "/usr/bin/test -f /etc/nginx/ssl/${name}.pem",
			require	=> File[$nginx::params::ssldir],
			notify	=> Exec['reload-nginx'],
    }
	}

	$real_ssl_certificate = $ssl_certificate ? { 
		''      => "/etc/nginx/ssl/${name}.pem",
    default => $ssl_certificate,
  }
  
	$real_ssl_certificate_key = $ssl_certificate_key ? { 
		''      => "/etc/nginx/ssl/${name}.key",
    default => $ssl_certificate_key,
  }

	nginx::site { $name:
		ensure	=> $ensure,
		content	=> template('nginx/site/fcgi.erb'),
	}	
}
