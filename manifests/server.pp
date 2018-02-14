class nagios::server {
  include apache2
  include apache2::php5

  package { 'nagios3':
    alias => nagios
  }

  service { nagios3:
    ensure => running,
    alias => nagios,
    require => Package[nagios]
  }

  apache2::confd_file { 'nagios3':
    source => "puppet:///modules/nagios/apache2.conf",
    require => Package['nagios', 'libapache2-mod-fcgid']
  }

  file { "/etc/nagios3/conf.d/defaults.cfg":
    source => 'puppet:///modules/nagios/conf.d/defaults.cfg',
    require => Package[nagios],
    notify => Service[nagios]
  }
  file { "/etc/nagios3/conf.d/contacts.cfg":
    source => 'puppet:///modules/nagios/conf.d/contacts.cfg',
    require => Package[nagios],
    notify => Service[nagios]
  }

  file { "/etc/cron.daily/nagios3":
    source => "puppet:///modules/nagios/nagios3.cron",
    mode => '0755',
    require => Package[nagios]
  }


  nagios::server::config_directory {
    'conf.d':   source_path => 'puppet:///modules/nagios/conf.d';
#    'services': source_path => 'puppet:///modules/nagios/services';
#    'hosts':    source_path => 'puppet:///modules/nagios/hosts';
  }

  file { [ "/etc/nagios3/conf.d/contacts_nagios2.cfg",
           "/etc/nagios3/conf.d/hostgroups_nagios2.cfg",
           "/etc/nagios3/conf.d/localhost_nagios2.cfg",
           "/etc/nagios3/conf.d/generic-host_nagios2.cfg",
           "/etc/nagios3/conf.d/services_nagios2.cfg",
           "/etc/nagios3/conf.d/host-gateway_nagios3.cfg",
           "/etc/nagios3/conf.d/generic-service_nagios2.cfg",
           "/etc/nagios3/conf.d/extinfo_nagios2.cfg",
           "/etc/nagios3/conf.d/timeperiods_nagios2.cfg" ]:
    ensure  => absent,
    require => Package[nagios],
    notify  => Service[nagios]
  }

  file { '/etc/nagios3/cgi.cfg':
    source => 'puppet:///modules/nagios/cgi.cfg',
    notify => Service[nagios]
  }
  file { '/etc/nagios3/nagios.cfg':
    source  => 'puppet:///modules/nagios/nagios.cfg',
    notify  => Service[nagios]
  }

  include nagios::plugins

  package { ['nagios-nrpe-plugin', 'dnsutils']: }

  file { "/etc/nagios3/services/apt-service.cfg":
    source => "puppet:///modules/nagios/services/apt-service.cfg",
    notify => Service[nagios]
  }
  file { "/etc/nagios3/services/mail-satellite-service.cfg":
    source => "puppet:///modules/nagios/services/mail-satellite-service.cfg",
    notify => Service[nagios]
  }
  file { "/etc/nagios3/services/http.cfg":
    source => "puppet:///modules/nagios/services/http.cfg",
    notify => Service[nagios]
  }
  file { "/etc/nagios3/services/puppet.cfg":
    source => "puppet:///modules/nagios/services/puppet.cfg",
    notify => Service[nagios]
  }

  nagios::plugin { 'check_http_redirect': }
  include perl::lib::www
}
