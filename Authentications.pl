use strict;
use warnings;
use DynaReporter;

use List::MoreUtils 'true';
use List::MoreUtils 'uniq';

my $dynaReporter = DynaReporter->new({
  reportingPeriod => pop(@ARGV)
});

$dynaReporter->mergeLogs();
$dynaReporter->generateReport();
$dynaReporter->generateList();
$dynaReporter->countAuthentications();
