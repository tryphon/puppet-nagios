class nagios {

  define plugin() {
    file { "/usr/local/lib/nagios/plugins/$name":
      source => ["puppet:///files/nagios/plugins/$name", "puppet:///nagios/plugins/$name"],
      mode => 755
    }
  }

}
