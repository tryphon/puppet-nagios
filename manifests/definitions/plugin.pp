class nagios {

  define plugin($source = ["puppet:///files/nagios/plugins/$name", "puppet:///modules/nagios/plugins/$name"]) {
    file { "/usr/local/lib/nagios/plugins/$name":
      source => $source,
      mode => 755
    }
  }

}
