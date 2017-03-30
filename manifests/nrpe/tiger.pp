class nagios::nrpe::tiger($tiger_enabled = false) {
  if $tiger_enabled {
    tiger::ignore { 'nagios_nrpe': }
  }
}
