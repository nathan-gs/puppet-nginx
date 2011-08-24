# Class: nginx
#
# Install nginx.
#
# Parameters:
#	* $nginx_user. Defaults to 'www-data'. 
#	* $nginx_worker_processes. Defaults to '1'.
#	* $nginx_worker_connections. Defaults to '1024'.
#
# Create config directories :
#	* /etc/nginx/conf.d for http config snippet
#	* /etc/nginx/includes for sites includes
#
# Provide 3 definitions : 
#	* nginx::config (http config snippet)
#	* nginx::site (http site)
#	* nginx::site::include (site includes)
#
# Templates:
# 	- nginx.conf.erb => /etc/nginx/nginx.conf
#

class nginx {
  require nginx::params
  
  include nginx::install, nginx::config, nginx::service
  
  Class['nginx::params'] -> Class['nginx::install'] -> Class['nginx::config'] -> Class['nginx::service']
}
