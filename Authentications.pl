use strict;
use warnings;
use Filter;

my $filter = Filter->new({
  reportingPeriod => pop(@ARGV)
});

$filter->mergeLogs();
$filter->generateReport();
$filter->generateList();
$filter->countAuthentications();
