define nagios::plugin(
  $content = '',
  $source  = "puppet:///modules/nagios/plugins/$name"
  ) {
  include nagios::plugins

  if $content == '' {
    file { "/usr/local/lib/nagios/plugins/$name":
      source  => $source,
      mode    => '0755',
      require => File['/usr/local/lib/nagios/plugins'],
    }
  } else {
    file { "/usr/local/lib/nagios/plugins/$name":
      content => $content,
      mode    => '0755',
      require => File['/usr/local/lib/nagios/plugins'],
    }
  }
}
