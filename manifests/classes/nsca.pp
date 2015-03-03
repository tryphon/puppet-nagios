class nagios::nsca::server {

  package { nsca: }

  service { nsca:
    ensure => running,
    require => [ Package[nsca], File["/var/run/nagios"] ]
  }

  file { "/var/run/nagios":
    ensure => directory
  }

  file {
    "/var/lib/nagios3/rw":
    owner => nagios,
    group => www-data,
    mode => 2710;

    "/var/lib/nagios3":
    owner => nagios,
    group => nagios,
    mode => 751
  }

  file { "/etc/nagios3/services/munin-plugins.cfg":
    source => "puppet:///nagios/services/munin-plugins.cfg";

    "/etc/nagios3/services/passive-service.cfg":
    source => "puppet:///nagios/services/passive-service.cfg"
  }

  file { '/etc/munin/munin-conf.d/nagios.conf':
    source => 'puppet:///nagios/munin.conf.contactnagios',
    require => Package['munin']
  }

  file { "/etc/nsca.cfg":
    source => "puppet:///nagios/nsca.cfg",
    notify => Service[nsca]
  }

  file { "/usr/bin/munin-cron":
    source => "puppet:///nagios/munin-cron",
    mode => 755
  }

  include nagios::nsca::tiger
}

class nagios::nsca::tiger {
  if $tiger_enabled {
    tiger::ignore { nagios_nsca: }
  }
}
