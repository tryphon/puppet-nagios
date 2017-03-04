class nagios::nmap {
  package { 'nmap': }

  nagios::plugin { 'check_nmap_ports':
    require => Package['nmap']
  }
}
