class nagios::puppet::client {
  file { '/usr/local/lib/nagios/plugins/utils.sh':
    ensure => link,
    target => '/usr/lib/nagios/plugins/utils.sh',
  }

  include nagios::plugins

  file { "/usr/local/lib/nagios/plugins/check_file_not_exists":
    source  => 'puppet:///modules/nagios/plugins/check_file_not_exists',
    mode    => '0755',
    require => File['/usr/local/lib/nagios/plugins'],
  }
 
  #nagios::plugin { 'check_file_not_exists': }
  nagios::nrpe::command { 'check_puppet_lock':
    definition => '/usr/local/lib/nagios/plugins/check_file_not_exists /var/lib/puppet/state/puppetdlock'
  }
}
