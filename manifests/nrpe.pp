class nagios::nrpe($nagios_server = '127.0.1.1') {

  package { 'nagios-nrpe-server': }

  service { 'nagios-nrpe-server':
    ensure  => running,
    require => [File["/etc/nagios/nrpe.d"],Package['nagios-nrpe-server']],
    pattern => "/usr/sbin/nrpe"
  }

  file { "/etc/nagios/nrpe_local.cfg":
    content => template("nagios/nrpe_local.cfg"),
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server']
  }

  file { "/etc/nagios/nrpe.d/":
    ensure  => directory,
    require => Package['nagios-nrpe-server']
  }


  file { "/etc/nagios/nrpe.d/defaults.cfg":
    source => "puppet:///modules/nagios/nrpe_defaults.cfg",
    notify => Service['nagios-nrpe-server']
  }

  package { 'nagios-plugins': }

  include nagios::nrpe::tiger
}
