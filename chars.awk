# program parses individual lines for tokens in those lines
{ 
    line = $0

    # loop until all changes have been applied
    do {
        linechanged = 0

        # bold italic
        if (line ~ /_{3}.*_{3}/) {
            sub(/_{3}/, "<strong><em>", line)
            sub(/_{3}/, "</em></strong>", line)
            linechanged = 1
        } else if (line ~ /\*{3}.*\*{3}/) {
            sub(/\*{3}/, "<strong><em>", line)
            sub(/\*{3}/, "</em></strong>", line)
            linechanged = 1
        }
        
        # bold
        if (line ~ /__.*__/) {
            sub(/__/, "<strong>", line)
            sub(/__/, "</strong>", line)
            linechanged = 1
        } else if (line ~ /\*\*.*\*\*/) {
            sub(/\*\*/, "<strong>", line)
            sub(/\*\*/, "</strong>", line)
            linechanged = 1
        }

        # italic
        if (line ~ /_.*_/) {
            sub(/_/, "<em>", line)
            sub(/_/, "</em>", line)
            linechanged = 1
        } else if (line ~ /\*.*\*/) {
            sub(/\*/, "<em>", line)
            sub(/\*/, "</em>", line)
            linechanged = 1
        }
    } while (linechanged)

    print line
}
