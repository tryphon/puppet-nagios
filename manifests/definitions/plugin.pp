class nagios {

  define plugin($source = ["puppet:///files/nagios/plugins/$name", "puppet:///modules/nagios/plugins/$name"]) {
    include nagios::plugins

    file { "/usr/local/lib/nagios/plugins/$name":
      source  => $source,
      mode    => 755,
      require => File['/usr/local/lib/nagios/plugins'],
    }
  }

}
