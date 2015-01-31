class nagios::plugins {
  file { ['/usr/local/lib/nagios', '/usr/local/lib/nagios/plugins']:
    ensure => directory
  }
}
