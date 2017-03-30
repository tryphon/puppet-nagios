class nagios::puppet::client {
  file { '/usr/local/lib/nagios/plugins/utils.sh':
    ensure => link,
    target => '/usr/lib/nagios/plugins/utils.sh',
  }

  nagios::plugin { 'check_file_not_exists': }
  nagios::nrpe::command { 'check_puppet_lock':
    definition => '/usr/local/lib/nagios/plugins/check_file_not_exists /var/lib/puppet/state/puppetdlock'
  }
}
