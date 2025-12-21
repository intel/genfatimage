#!/usr/bin/perl
# SPDX-License-Identifier: BSD-2-Clause
# Copyright 2025 Intel Corporation - All Rights Reserved

#
# Script to convert a Perl script to a DOS/Windows batch file, including
# collecting options from the #! script line. This script is designed
# to work with versions of ExtUtils::PL2Bat both that support and
# do not support #! option harvesting.
#

use strict;
use integer;
use warnings;
use ExtUtils::PL2Bat;

sub pl2bat_opts($@) {
    my($out, $in, @perlargs) = @_;

    push(@perlargs, '-x', '-S');
    my %opts = (in => $in,
		update => 1,
		ntargs => join(' ', @perlargs, '%0 %*'),
		otherargs => join(' ', @perlargs, '"%0" %1 %2 %3 %4 %5 %6 %7 %8 %9'),
		args => '');
    $opts{out} = $out if (defined($out));

    pl2bat(%opts);
}

my($input, $output) = @ARGV;
$input = 'genfatimage' unless (defined($input));

my @perlopts;
open(my $in, '<', $input) or die "$input: $!\n";
while (defined(my $l = <$in>)) {
    if ($l =~ /^#!.*perl.*?\s+(\S.*?)\s*$/) {
	@perlopts = split(/\s+/, $1);
	last;
    }
}
close($in);
pl2bat_opts($output, $input, @perlopts);
