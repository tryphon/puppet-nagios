class nagios::smsfreemobile {
  nagios::plugin { 'send-notification.sh': }
}
