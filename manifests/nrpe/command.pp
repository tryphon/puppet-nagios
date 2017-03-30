define nagios::nrpe::command($definition) {
  file { "/etc/nagios/nrpe.d/command_$name.cfg":
    content => "command[$name]=$definition\n",
    notify  => Service['nagios-nrpe-server']
  }
}
