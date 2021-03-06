# Define: nginx::site::proxy
#
define nginx::site::proxy ($proxy_pass,
                          $ensure              = 'present',
                          $listen              = '80',
                          $server_name         = '',
                          $access_log          = '',
						  $error_log		   = '',
						  $error_log_level	   = 'info',
                          $ssl_certificate     = '',
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

  $real_error_log = $error_log ? {
		''      => "/var/log/nginx/${name}_error.log",
    default => $error_log,
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
		content	=> template('nginx/site/proxy.erb'),
	}
}
