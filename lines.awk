# program parses line by line for tokens at the start/end of lines

{ lineparsed=0 }

!lineparsed && /^#{1,6}/ { print "<h" length($1) ">" substr($0, length($1) + 2) "</h" length($1) ">"; lineparsed=1 }
!lineparsed && /^-{3,}$|^\*{3,}$|^_{3,}$/ { print "<hr/>"; lineparsed=1 }
!lineparsed && /^.*  / { print $0 "<br/>"; lineparsed=1 }

!lineparsed { print $0 }

