#!/usr/bin/env perl

use strict;
use warnings;

{
    my $codeblock = 0; # 0: out of block, 1: in block of three backticks, 2: in block of four backticks

    sub parseline {

        my $line = $_[0];

        if ($line =~ m/^```/) {
            if ($codeblock == 0) {
                $codeblock = 1;
                $line = "<pre><code>\n";

            } elsif ($codeblock == 1) {
                $codeblock = 0;
                $line = "</code></pre>\n";
            }
        } elsif ($line =~ m/^````/) {
            if ($codeblock == 0) {
                $codeblock = 2;
                $line = "<pre><code>\n";
            } elsif ($codeblock == 2) {
                $codeblock = 0;
                $line = "</code></pre>\n";
            }
        }

        if (!$codeblock) {
            $line =~ s{^(#{1,6}) (.*)$}{'<h' . length($1) . ">$2</h" . length($1) . '>'}e; # headers
            $line =~ s{^(\*\*\*+)|(---+)|(___+)\s*$}{<hr />\n}; # horizontal rules
            $line =~ s{  $}{<br />}; # line breaks

            $line =~ s{(\*\*\*|___)(.*?)\1}{<strong><em>$2</em></strong>}g;
            $line =~ s{(\*\*|___)(.*?)\1}{<strong>$2</strong>}g;
            $line =~ s{([*_])(.*?)\1}{<em>$2</em>}g;
        }

        $line; # return modified line
    }
}

if (@ARGV > 0) {
    print "<html>\n<head></head>\n<body>\n";

    for my $filename (@ARGV) {
        open( my $fh, '<', $filename ) || die 'Can\'t open $filename: $!';
        my @lines = <$fh>;
        close($fh);

        foreach (@lines) {
            $_ = parseline($_);
        }
        print "@lines";
    }
    print "</body>\n</html>\n";
} 

