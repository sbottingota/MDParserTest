# program parses line by line for tokens at the start/end of lines

BEGIN { 
    codeblock=0 # 0 for out of code block, 1 for three backtick code block, 2 for four backtick code block
}

{ lineparsed=0 }

!lineparsed && /^#{1,6}/ { print "<h" length($1) ">" substr($0, length($1) + 2) "</h" length($1) ">"; lineparsed=1 }
!lineparsed && /^-{3,}$|^\*{3,}$|^_{3,}$/ { print "<hr/>"; lineparsed=1 }

!lineparsed && codeblock == 0 && /`{3,4}.*/ { print "<pre><code>"; codeblock = $0 ~ /````.*/ ? 2 : 1; lineparsed=1 }
!lineparsed && codeblock == 1 && /```/ { print "</code></pre>"; codeblock=0; lineparsed=1 }
!lineparsed && codeblock == 2 && /````/ { print "</code></pre>"; codeblock=0; lineparsed=1 }

!lineparsed && /^.*  / { print $0 "<br/>"; lineparsed=1 }

!lineparsed { print $0 }

