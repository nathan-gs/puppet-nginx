# Class: nginx::config
#
#
class nginx::config {
  file { $nginx::params::configfile:
    ensure 	=> present,
    content => template('nginx/nginx.conf.erb'),
    owner 	=> 'root',
    group 	=> 'root',
    mode 	  => '0644',
    notify 	=> Exec['reload-nginx'],
    require => Class['nginx::install'],
  }

  file { $nginx::params::configdir:
    ensure  => directory,
    owner   => 'root', 
    group   => 'root',
    mode    => '0755',
    require => Class['nginx::install'],
  }

  file { $nginx::params::includedir:
    ensure  => directory,
    owner   => 'root', 
    group   => 'root',
    mode    => '0755',
    require => Class['nginx::install'],
  }

  file { $nginx::params::ssldir:
    ensure  => directory,
    owner   => 'root', 
    group   => 'root',
    mode    => '0755',
    require => Class['nginx::install'],
  }
  
  file { $nginx::params::available_sitedir:
    ensure  => directory,
    owner   => 'root', 
    group   => 'root',
    mode    => '0755',
    require => Class['nginx::install'],
  }
  
  file { $nginx::params::enabled_sitedir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Class['nginx::install'],
  }

  # Nuke default files
  file { '/etc/nginx/fastcgi_params':
    ensure  => absent,
    require => Class['nginx::install'],
  }

  exec { 'reload-nginx':
    command     => '/etc/init.d/nginx reload',
    refreshonly => true,
  }
}
