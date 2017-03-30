define nagios::server::config_directory($source_path = '') {
  file { "/etc/nagios3/$name":
    recurse => true,
    purge   => true,
    source  => [ $source_path, 'puppet:///modules/nagios/empty' ],
    require => Package[nagios],
    notify  => Service[nagios]
  }
}
