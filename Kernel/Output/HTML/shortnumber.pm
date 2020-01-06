#!/usr/bin/env perl5

package Kernel::Output::HTML::shortnumber;

use strict;
use warnings;

use DateTime::Format::Strptime qw(strptime);

# Encode to format B only.

my $LETTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
my $BASEDATE = DateTime->new(year => 2012, month => 2, day => 7);

our sub encode_B {

    my ($tn) = @_;

    if ($tn =~ m/\d{16}/) {

        my $dt = strptime("%Y%m%d", substr($tn, 0, 8));
        my $days = $BASEDATE->delta_days($dt)->delta_days();

        my $inst = substr($tn, 8, 2) + 0;
        my $numc = substr($tn, 10) + 0;

        my $short = ($days << 17) + (($inst - 10) << 15) + $numc;

        my @parts = (
            ($short & 0x3f000000) >> 24,
            ($short & 0x00fc0000) >> 18,
            ($short & 0x0003f000) >> 12,
            ($short & 0x00000fc0) >> 6,
            ($short & 0x0000003f)
        );

        my $chars = join("", map({ substr $LETTERS, $_, 1 } @parts));
        return "B#$chars";

    }

    return "";

}

1;
