# Class: nginx::params
#
#
class nginx::params {
  # TODO: refactor this var to a common module and make other module use it
	$os_suffix = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => 'debian',
		/(?i)(RedHat|CentOS)/ => 'redhat',
	}
	
	$etcdir = '/etc/nginx'
	
	$configdir = $nginx_configdir ? {
	 ''      => "${etcdir}/conf.d",
	 default => $nginx_configdir,
	}
	
	$configfile = $nginx_configfile ? {
	 ''      => "${etcdir}/nginx.conf",
	 default => $nginx_configfile,
	}
	
	$includedir = $nginx_includedir ? {
	 ''      => "${etcdir}/includes",
	 default => $nginx_includedir,
	}
	
	$ssldir = $nginx_ssldir ? {
	 ''      => "${etcdir}/ssl",
	 default => $nginx_ssldir,
	}
	
	$available_sitedir = $nginx_available_sitedir ? {
	 ''      => "${etcdir}/sites-available",
	 default => $nginx_available_sitedir,
	}
	
	$enabled_sitedir = $nginx_enabled_sitedir ? {
	 ''      => "${etcdir}/sites-enabled",
	 default => $nginx_enabled_sitedir,
	}

	$user = $nginx_user ? {
	  ''      => 'www-data',
	  default => $nginx_user,
	}

	$group = $nginx_group ? {
	  ''      => 'www-data',
	  default => $nginx_group,
	}
	
	$worker_processes = $nginx_worker_processes ? {
	  ''      => '1',
	  default => $nginx_worker_processes,
	}
	
	$worker_connections = $nginx_worker_connections ? {
	  ''      => '1024',
	  default => $nginx_worker_connections,
	}
	
	$worker_rlimit_nofile = $nginx_worker_rlimit_nofile ? {
	  ''      => '10000',
	  default => $nginx_worker_rlimit_nofile,
	}
}
