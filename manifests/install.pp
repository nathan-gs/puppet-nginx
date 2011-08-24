# Class: nginx::install
#
#
class nginx::install {
  package { 'nginx':
    ensure => installed,
  }
}
