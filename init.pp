# == Class: createall
#
# Full description of class createall here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'createall':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2020 Your name here, unless otherwise noted.
#
class createall {

package { 'vim-enhanced': ensure => 'installed' }
package { 'curl': ensure => 'installed' }
package { 'git':   ensure => 'installed' }

user { 'monitor': 
ensure => 'present',
home => '/home/monitor', 
shell => '/bin/bash'
}

file { '/home/monitor':
ensure => directory,
owner => monitor,
group => monitor,
}

file { '/home/monitor/scripts':
ensure => directory,
owner => monitor,
group => monitor,
mode => 'a+x',
recurse => true,

}

exec{'retrieve_memory_check.sh':
command => "/usr/bin/wget -q https://raw.githubusercontent.com/ravindersinghgill32/code/master/memory_check.sh -O /home/monitor/scripts/memory_check.sh",
creates => "/home/monitor/scripts/memory_check.sh",
}

file { '/home/monitor/src':
ensure => directory,
owner => monitor,
group => monitor,
}

file { '/home/monitor/src/my_memory_check': 
ensure => 'link',
target => '/home/monitor/scripts/memory_check.sh',
}

cron { 'memory_check':
command => '/home/monitor/src/my_memory_check ',
ensure => present,
user    => 'monitor',
minute  => 10,
}

exec{'set_timezone':
command => "/usr/bin/timedatectl set-timezone Asia/Manila",
user => "root",
}

exec{'set_hostname':
command => "/usr/bin/hostnamectl set-hostname bpx.server.local",
user => "root",
}
}




