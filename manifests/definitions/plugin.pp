class nagios {

  define plugin() {
    include nagios::plugins
    file { "/usr/local/lib/nagios/plugins/$name":
      source => ["puppet:///files/nagios/plugins/$name", "puppet:///nagios/plugins/$name"],
      mode => 755
    }
  }

}
