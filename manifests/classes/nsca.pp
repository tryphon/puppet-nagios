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

  # Customize munin configuration to send warning via nsca
  concatenated_file_source { "munin.conf.contactnagios":
    dir    => "/etc/munin/conf.d",
    source => "puppet:///nagios/munin.conf.contactnagios"
  }

  augeas { "external commands in /etc/nagios3/nagios.cfg":
    context => "/files/etc/nagios3/nagios.cfg/",
    changes => [
        "set check_external_commands 1"
    ],
    require => [Puppet::Augeas::Lens[nagiosconfig], File["/var/lib/nagios3/rw"]],
    load_path => "/usr/local/share/augeas/lenses/",
    notify => Service[nagios]
  }

  file { "/etc/nsca.cfg":
    source => "puppet:///nagios/nsca.cfg",
    notify => Service[nsca]
  }

  file { "/usr/bin/munin-cron":
    source => "puppet:///nagios/munin-cron",
    mode => 755
  }

}
