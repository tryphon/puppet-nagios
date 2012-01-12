class nagios::server {
  include apache2
  include apache2::auth::pam
  include apache2::php5

  package { nagios3: 
    alias => nagios
  }

  service { nagios3:
    ensure => running,
    alias => nagios,
    require => Package[nagios]
  }

  file { "/etc/nagios3/apache2.conf":
    source => "puppet:///nagios/apache2.conf",
    require => [Package[nagios], Package[libapache2-mod-fcgid], Package[libapache2-mod-auth-pam]],
    notify => Service[apache2]
  }

  file { "/etc/nagios3/conf.d/defaults.cfg":
    source => ["puppet:///files/nagios/conf.d/defaults.cfg", "puppet:///nagios/conf.d/defaults.cfg"],
    require => Package[nagios],
    notify => Service[nagios]
  }

  file { "/etc/cron.daily/nagios3":
    source => "puppet:///nagios/nagios3.cron",
    mode => 755,
    require => Package[nagios]
  }

  define config_directory() {
    file { "/etc/nagios3/$name":
      recurse => true,
      purge => true,
      source => [ "puppet:///files/nagios/$name", "puppet:///nagios/empty" ],
      require => Package[nagios],
      notify => Service[nagios]
    }
  }

  config_directory { [ "conf.d", services, hosts ]: }

  file { [ "/etc/nagios3/conf.d/contacts_nagios2.cfg",
           "/etc/nagios3/conf.d/hostgroups_nagios2.cfg",
           "/etc/nagios3/conf.d/localhost_nagios2.cfg",
           "/etc/nagios3/conf.d/generic-host_nagios2.cfg",
           "/etc/nagios3/conf.d/services_nagios2.cfg",
           "/etc/nagios3/conf.d/host-gateway_nagios3.cfg",
           "/etc/nagios3/conf.d/generic-service_nagios2.cfg",
           "/etc/nagios3/conf.d/extinfo_nagios2.cfg",
           "/etc/nagios3/conf.d/timeperiods_nagios2.cfg" ]:
    ensure => absent,
    require => Package[nagios],
    notify => Service[nagios]
  }

  file { "/etc/nagios3/cgi.cfg":
    source => "puppet:///nagios/cgi.cfg",
    notify => Service[nagios]
  }
  file { "/etc/nagios3/nagios.cfg":
    source => "puppet:///nagios/nagios.cfg",
    require => [File["/etc/nagios3/services"], File["/etc/nagios3/hosts"]],
    notify => Service[nagios]
  }

  file { ["/usr/local/lib/nagios", "/usr/local/lib/nagios/plugins"]:
    ensure => directory
  }

  package { nagios-nrpe-plugin: }

  file { "/etc/nagios3/services/apt-service.cfg":
    source => "puppet:///nagios/services/apt-service.cfg",
    notify => Service[nagios]
  }
  file { "/etc/nagios3/services/mail-satellite-service.cfg":
    source => "puppet:///nagios/services/mail-satellite-service.cfg",
    notify => Service[nagios]
  }

}
