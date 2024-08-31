#!/usr/bin/env perl

use strict;
use warnings;

{
    my $codeblock = 0; # 0: out of block, 1: in block of three backticks, 2: in block of four backticks
    my $listdepth = 0;

    sub parseline {
        my $line = $_[0];

        if ($line =~ m/^````/) {
            if ($codeblock == 0) {
                $codeblock = 2;
                $line = "<pre><code>\n";
            } elsif ($codeblock == 2) {
                $codeblock = 0;
                $line = "</code></pre>\n";
            }
        } elsif ($line =~ m/^```/) {
            if ($codeblock == 0) {
                $codeblock = 1;
                $line = "<pre><code>\n";

            } elsif ($codeblock == 1) {
                $codeblock = 0;
                $line = "</code></pre>\n";
            }
        }

        if (!$codeblock) {
            if ($line =~ s{^((?: {4})*)[-*] (.*)$}{<li>$2</li>}) {
                my $newlistdepth = (length($1) / 4) + 1;

                while ($newlistdepth > $listdepth) {
                    $line = "<ul>\n" . $line;
                    ++$listdepth;
                }
                while ($newlistdepth < $listdepth) {
                    $line = "</ul>\n" . $line;
                    --$listdepth;
                }
            } else {
                while ($listdepth > 0) {
                    $line = "</ul>\n" .  $line;
                    --$listdepth;
                }
            }

            $line =~ s{^(#{1,6}) (.*)$}{'<h' . length($1) . ">$2</h" . length($1) . '>'}e; # headers
            $line =~ s{^(\*\*\*+)|(---+)|(___+)\s*$}{<hr />\n}; # horizontal rules
            $line =~ s{  $}{<br />}; # line breaks

            $line =~ s{(\*\*\*|___)(.*?)\1}{<strong><em>$2</em></strong>}g;
            $line =~ s{(\*\*|___)(.*?)\1}{<strong>$2</strong>}g;
            $line =~ s{([*_])(.*?)\1}{<em>$2</em>}g;
        }

        return $line; # return modified line
    }
}

print "<html>\n<head></head>\n<body>\n";

if (@ARGV > 0) {
    for my $filename (@ARGV) {
        open( my $fh, '<', $filename ) || die 'Can\'t open $filename: $!';
        my @lines = <$fh>;
        close($fh);

        foreach (@lines) {
            $_ = parseline($_);
        }
        print "@lines";
    }
} else {
    my @lines;

    my $i = 0;
    while (<>) {
        $lines[$i] = parseline($_);
        ++$i;
    }
    print "@lines";
} 

print "</body>\n</html>\n";

