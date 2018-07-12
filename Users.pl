use strict;
use warnings;
use DynaReporter;

my $dynaReporter = DynaReporter->new({
  reportingPeriod => pop(@ARGV)
});

$dynaReporter->mergeLogs();
$dynaReporter->parseMarkup();
$dynaReporter->clearMarkup();
