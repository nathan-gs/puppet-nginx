# Class: nginx::install
#
#
class nginx::install {
  include apt::ppa::nginx

  package { 'nginx-full':
    ensure  => latest,
    require => Class['apt::ppa::nginx'],
  }
}
