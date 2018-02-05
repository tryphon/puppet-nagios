class nagios::nrpe::process {
  nagios::nrpe::command { 'check_process_count_strict':
    definition => '/usr/lib/nagios/plugins/check_procs -C '$ARG1$' -c $ARG2$:$ARG2$'
  }

  nagios::nrpe::command { 'check_process_count':
    definition => '/usr/lib/nagios/plugins/check_procs -C '$ARG1$' -c $ARG2$ -w $ARG3$'
  }
}
