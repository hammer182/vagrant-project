# execute 'apt-get update'
exec { 'updates':                    	# exec resource named 'apt-update'
  command => '/usr/bin/apt-get update'  # command this resource will run
}

# install php7.2 and php7.2-mysql packages
package { ['php7.2', 'php7.2-mysql']:
  require => Exec['updates'],        # require 'apt-update' before installing
  ensure => installed,
}

exec { 'run-php7':                    	
  require => Package['php7.2'],
  command => '/usr/bin/php -S 0.0.0.0:8888 -t /src &'  
}