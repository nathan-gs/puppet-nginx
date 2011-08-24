# Define: nginx::site
#
# Install a nginx site in /etc/nginx/sites-available (and symlink in /etc/nginx/sites-enabled). 
#
#
# Parameters :
# * ensure: typically set to "present" or "absent". Defaults to "present"
# * content: site definition (should be a template).
#
define nginx::site ($ensure  = 'present',
                    $content = false,
                    $source  = false) {
  include nginx

	case $ensure {
		'present' : {
      nginx::site::install { $name:
        content => $content,
        source  => $source,
      }
    }
		'absent' : {
			exec { "rm -f ${nginx::params::enabled_sitedir}/${name}":
				onlyif  => "/bin/sh -c '[ -L ${nginx::params::enabled_sitedir}/${name} ] && [ ${nginx::params::enabled_sitedir}/${name} -ef ${nginx::params::available_sitedir}/${name} ]'",
				notify  => Exec['reload-nginx'],
				require => [ File[$nginx::params::available_sitedir], File[$nginx::params::enabled_sitedir] ],
			}
		}
		default: { err ( "Unknown ensure value: '${ensure}'" ) }
	}
}
