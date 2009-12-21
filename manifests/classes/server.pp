class nagios::server {
  include apache2
  include apache2::auth::pam

  package { nagios3: 
    alias => nagios
  }

  service{nagios3:
    ensure => running,
    alias => nagios,
    require => Package[nagios]
  }

  file { "/etc/nagios3/apache2.conf":
    source => "puppet:///nagios/apache2.conf",
    require => Package[nagios],
    notify => Service[apache2]
  }

  file { "/etc/nagios3/conf.d/defaults.cfg":
    source => ["puppet:///files/nagios/conf.d/defaults.cfg", "puppet:///nagios/conf.d/defaults.cfg"],
    require => Package[nagios],
    notify => Service[nagios]
  }

  define config_directory() {
    file { "/etc/nagios3/$name":
      recurse => true,
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

  puppet::augeas::lens { nagiosconfig:
    source => "puppet:///nagios/nagiosconfig.aug"
  }

  augeas { "/etc/nagios3/cgi.cfg":
    context => "/files/etc/nagios3/cgi.cfg/",
    changes => [
        "set authorized_for_system_information *",
        "set authorized_for_system_information *",
        "set authorized_for_configuration_information *",
        "set authorized_for_system_commands *",
        "set authorized_for_all_services *",
        "set authorized_for_all_hosts *",
        "set authorized_for_all_service_commands *",
        "set authorized_for_all_host_commands *",
    ],
    require => Puppet::Augeas::Lens[nagiosconfig],
    load_path => "/usr/local/share/augeas/lenses/",
    notify => Service[nagios]
  }

  augeas { "/etc/nagios3/nagios.cfg":
    context => "/files/etc/nagios3/nagios.cfg/",
    changes => [
        # TODO insert correctly nagios cfg_directories
        "set cfg_dir[3] /etc/nagios3/services",
        "set cfg_dir[4] /etc/nagios3/hosts"
    ],
    require => [Puppet::Augeas::Lens[nagiosconfig], File["/etc/nagios3/services"], File["/etc/nagios3/hosts"]],
    load_path => "/usr/local/share/augeas/lenses/",
    notify => Service[nagios]
  }

  file { ["/usr/local/lib/nagios", "/usr/local/lib/nagios/plugins"]:
    ensure => directory
  }

  package { nagios-nrpe-plugin: }

  file { "/etc/nagios3/services/apt-service.cfg":
    source => "puppet:///nagios/services/apt-service.cfg"
  }

}
