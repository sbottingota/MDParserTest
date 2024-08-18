#!/usr/bin/env bash

echo '<html>'
echo '<head></head>'
echo '<body>'

# in the case where $1 is undefined (i.e. no args were passed into script), awk will read from stdin
awk -f ./chars.awk $1 | awk -f ./lines.awk

echo '</body>'
echo '</html>'
