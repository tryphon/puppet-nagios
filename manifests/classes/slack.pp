class nagios::slack {
  nagios::plugin { 'slack': }
  include perl::lib::www
  include perl::lib::crypt-ssleay
}
