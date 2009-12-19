module NagiosConfig =
  autoload xfm

  let eol = del /[ \t]*\n/ "\n"

  let key_value = [ key /[a-z0-9_]+/ . del /[ \t]*=[ \t]*/ "=" . store /[^ \t\n]+([ \t]+[^ \t\n]+)*/ . eol ]
  let comment_or_empty = [ del /(#.*|[ \t]*)\n/ "\n" ]

  let lns = ( key_value | comment_or_empty )*

  let filter = (incl "/etc/nagios3/cgi.cfg") . (incl "/etc/nagios3/nagios.cfg")
  let xfm = transform lns filter
