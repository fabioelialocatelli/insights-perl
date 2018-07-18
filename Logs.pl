=pod
=head1 Fabio Elia Locatelli
=head2 fabioelialocatelli@yandex.com
=head3 +64 21 0816 1038
=encoding utf8
=cut

use strict;
use warnings;
use Reporter;

my $reporter = Reporter->new({
  reportingPeriod => pop(@ARGV),
  reportingTag =>pop(@ARGV)
});

$reporter->mergeLogs();
$reporter->generateReport();
