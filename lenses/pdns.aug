module Pdns =
  autoload xfm

  let equals = del /=/ "="
  let eol = Util.eol
  let store_to_eol = store /([^ \t\n].*[^ \t\n]|[^ \t\n]|$)/
  let space = del /[ \t]+/ " "
  let sep_com_space = del /[, \t]+/ " "
  let entry (kw:regexp) = [ key kw . equals . store_to_eol . eol ]
  let generic_entry_key = /[A-Za-z0-9\._-]+(\[[0-9]+\])?/ - /allow-axfr-ips/
  let ip = /[0-9\.\/]+/
  let comment = Util.comment
  let empty = Util.empty

  let generic_entry = entry generic_entry_key
  let allow_axfr_ips_entry = Build.key_value_line_comment "allow-axfr-ips" equals (Build.opt_list [label "var" . store ip] sep_com_space) eol

  let lns = (comment|empty|allow_axfr_ips_entry|generic_entry)*

  let filter      = Util.stdexcl
                   . incl "/etc/powerdns/pdns.conf"
                   . incl "/etc/powerdns/conf.d/*"
                   . incl "/etc/pdns/pdns.conf"
                   . incl "/etc/pdns/conf.d/*"

  let xfm         = transform lns filter
