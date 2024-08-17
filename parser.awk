BEGIN { print "<html>\n<head></head>\n<body>" }
{ parsed = 0 }

!parsed && /^#{1,6}/ { print "<h" length($1) ">" substr($0, length($1) + 2) "</h" length($1) ">"; parsed = 1 }
!parsed { print $0 }

END { print "</body>\n</html>" }

