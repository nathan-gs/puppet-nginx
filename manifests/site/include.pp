# Define: nginx::site::include
#
# Define a site config include in /etc/nginx/includes
#
# Parameters :
# * ensure: typically set to "present" or "absent". Defaults to "present"
# * content: include definition (should be a template).
#
define nginx::site::include ($ensure  = 'present',
                             $content = '' ) {
	file { "${nginx_includes}/${name}.inc":
    ensure  => $ensure,
		content => $content,
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		notify  => Exec["reload-nginx"],
		require => File[$nginx::params::includedir],
	}    
}
