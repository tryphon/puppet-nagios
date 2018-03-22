class nagios::check_backup {
    package{ 'python3': }
    nagios::plugin { 'check_backup': }
}
