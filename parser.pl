#!/usr/bin/env perl

use strict;
use warnings;

{
    my $codeblock = 0; # 0: out of block, 1: in block of three backticks, 2: in block of four backticks
    my $ulistdepth = 0;

    my sub balanceulist {
        my $requireddepth = $_[0];

        my $line = "";

        while ($requireddepth > $ulistdepth) {
            $line = "<ul>\n" . $line;
            ++$ulistdepth;
        }
        while ($requireddepth < $ulistdepth) {
            $line = "</ul>\n" . $line;
            --$ulistdepth;
        }

        return $line;
    }

    sub parseline {
        my $line = $_[0];

        # codeblocks
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
            # unordered lists
            if ($line =~ s{^((?: {4})*)[-*] (.*)$}{<li>$2</li>}) {
                my $newlistdepth = (length($1) / 4) + 1;

                $line = balanceulist($newlistdepth) . $line;

            } else {
                $line = balanceulist(0) . $line;
            }

            $line =~ s{^(#{1,6}) (.*)$}{'<h' . length($1) . ">$2</h" . length($1) . '>'}e; # headers
            $line =~ s{^(\*\*\*+)|(---+)|(___+)\s*$}{<hr />\n}; # horizontal rules
            $line =~ s{  $}{<br />}; # line breaks

            # emphasis
            $line =~ s{(\*\*\*|___)(.*?)\1}{<strong><em>$2</em></strong>}g;
            $line =~ s{(\*\*|___)(.*?)\1}{<strong>$2</strong>}g;
            $line =~ s{([*_])(.*?)\1}{<em>$2</em>}g;
        }

        return $line; # return modified line
    }

    sub endparse {
        my $line = balanceulist 0;
        return $line;
    }
}

my @lines;

if (@ARGV > 0) {
    for my $filename (@ARGV) {
        open( my $fh, '<', $filename ) || die 'Can\'t open $filename: $!';
        @lines = <$fh>;
        close($fh);

    }
} else {
    @lines = <>;
} 

print "<html>\n<head></head>\n<body>\n";
foreach (@lines) {
    $_ = parseline $_;
}
$lines[@lines] = endparse();
print "@lines";
print "</body>\n</html>\n";

