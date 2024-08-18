#!/usr/bin/env bash

echo '<html>'
echo '<head></head>'
echo '<body>'

# in the case where $1 is undefined (i.e. no args were passed into script), awk will read from stdin
awk -f ./lines.awk $1 | awk -f ./chars.awk

echo '</body>'
echo '</html>'
