class nagios::logstash {
  include nagios::nrpe

  nagios::nrpe::command { 'check_logstash_process':
    # we can't use the command name since it's a java daemon.
    # We use the process user instead, which is specific to logstash
    definition => '/usr/lib/nagios/plugins/check_procs -c 1:2 -u logstash'
  }
}
