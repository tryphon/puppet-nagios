class nagios::puppet::client {
  file { '/usr/local/lib/nagios/plugins/utils.sh':
    ensure => link,
    target => '/usr/lib/nagios/plugins/utils.sh',
  }

  nagios::plugin { 'check_file_not_exists': }
  nagios::nrpe::command { 'check_puppet_lock':
    definition => '/usr/local/lib/nagios/plugins/check_file_not_exists /var/lib/puppet/state/puppetdlock'
  }
  nagios::nrpe::command { 'check_process_count_strict':
    definition => '/usr/lib/nagios/plugins/check_procs -C '$ARG1$' -c $ARG2$:$ARG2$'
  }
  nagios::nrpe::command { 'check_process_count':
    definition => '/usr/lib/nagios/plugins/check_procs -C '$ARG1$' -c $ARG2$ -w $ARG3$'
  }
}
