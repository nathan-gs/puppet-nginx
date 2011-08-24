# Define: nginx::config::snippet
#
# Define a nginx config snippet. Places all config snippets into
# /etc/nginx/conf.d, where they will be automatically loaded by http module
#
#
# Parameters :
# * ensure: typically set to "present" or "absent". Defaults to "present"
# * content: set the content of the config snipppet. Defaults to 'template("nginx/${name}.conf.erb")'
# * order: specifies the load order for this config snippet. Defaults to "500"
#
define nginx::config::snippet ($ensure  = 'present',
                               $content = false,
                               $source  = false,
                               $order   = '500') {
  include nginx

  if ($content == false and $source == false) {
   fail 'You have to specify content or source'
  }

  if $content and $source {
   fail "You can't specify both a content and source for snippet ${name} in module 'nginx'"
  } else {
   if $content {
     file { "${nginx::params::configdir}/${order}-${name}.conf":
       ensure  => $ensure,
       content => $content,
       owner   => 'root',
       group   => 'root',
       mode    => '0644',
       notify  => Exec['reload-nginx'],
       require => File[$nginx::params::configdir],
     }
   } elsif $source {
     file { "${nginx::params::configdir}/${order}-${name}.conf":
       ensure  => $ensure,
       source  => $source,
       owner   => 'root',
       group   => 'root',
       mode    => '0644',
       notify  => Exec['reload-nginx'],
       require => File[$nginx::params::configdir],
     }
   }
  }
}