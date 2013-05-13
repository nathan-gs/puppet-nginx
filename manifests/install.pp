# Class: nginx::install
#
#
class nginx::install {

	require nginx::params

  package { 'nginx':
    ensure  => installed,
  }
  
  file { "/var/www" :
	ensure	=> directory,
	owner	=> root,
	group	=> "${nginx::params::group}",
	mode	=> 0750
  }
}
