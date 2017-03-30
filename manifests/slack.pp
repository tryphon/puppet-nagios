class nagios::slack(
  $channel = '#supervision',
  $domain  = 'changeme.slack.com',
  $token   = 'notavalidtoken') {
  nagios::plugin { 'slack': }
  file { '/etc/nagios3/conf.d/slack.cfg':
    content => template('nagios/slack.cfg.erb'),
    require => File['/etc/nagios3/conf.d'],
  }
  include perl::lib::www
  include perl::lib::crypt_ssleay
}
