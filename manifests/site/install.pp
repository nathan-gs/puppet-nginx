# Define: nginx::site::install
#
# Install nginx vhost
# This definition is private, not intended to be called directly
#
define nginx::site::install ($content = false,
                             $source  = false) {
  if ($content == false and $source == false) {
    fail 'You have to specify content or source'
  }
  
  if $content and $source {
    fail "You can't specify both a content and source for site ${name} in module 'nginx'"
  } else {
    if $content {
      file { "${nginx::params::available_sitedir}/${name}":
        ensure  => present,
        content => $content,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        notify  => Exec['reload-nginx'],
        require => File[$nginx::params::available_sitedir],
      }
    } elsif $source {
      file { "${nginx::params::available_sitedir}/${name}":
        ensure  => present,
        source  => $source,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        notify  => Exec['reload-nginx'],
        require => File[$nginx::params::available_sitedir],
      }
    }
  }

  # now, enable it.
	exec { "ln -s ${nginx::params::available_sitedir}/${name} ${nginx::params::enabled_sitedir}/${name}":
    unless  => "/bin/sh -c '[ -L ${nginx::params::enabled_sitedir}/${name} ] && [ ${nginx::params::enabled_sitedir}/${name} -ef ${nginx::params::available_sitedir}/${name} ]'",
		notify  => Exec['reload-nginx'],
		require => [ File["${nginx::params::available_sitedir}/${name}"], File[$nginx::params::enabled_sitedir] ],
	}
}
