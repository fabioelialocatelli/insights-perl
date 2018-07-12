use strict;
use warnings;
use Reporter;

my $reporter = Reporter->new({
  reportingPeriod => pop(@ARGV),
  reportingTag =>pop(@ARGV)
});

$reporter->mergeLogs();
$reporter->generateReport();
