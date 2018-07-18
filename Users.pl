=pod
=head1 Fabio Elia Locatelli
=head2 fabioelialocatelli@yandex.com
=head3 +64 21 0816 1038
=encoding utf8
=cut

use strict;
use warnings;
use Filter;

my $filter = Filter->new({
  reportingPeriod => pop(@ARGV)
});

$filter->mergeLogs();
$filter->parseMarkup();
$filter->clearMarkup();
