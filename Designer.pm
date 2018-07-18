=pod
=head1 Fabio Elia Locatelli
=head2 fabioelialocatelli@yandex.com
=head3 +64 21 0816 1038
=encoding utf8
=cut

package Designer;

use strict;
use warnings;

sub new{
    my $object = @_;
    my $this = bless {
    backgroundColor => "azure;\n",
    fontFamily => "sans-serif;\n",
    fontWeight => "normal;\n",
    textAlign => "center;\n",
    borderWidth => "1px;\n",
    borderStyle => "solid;\n",
    borderCollapse => "collapse;\n",
    margin => "1.25em;\n",
    padding => "0.25em;\n",
    tableLayout => "auto;\n",
    tableWidth => "35%;\n",
    width => "15em;\n",
    openBlock => "{\n",
    closeBlock => "\t\t}\n",
    indentSelector => "\t\t",
    indentBlock => "\t\t\t"
  }, $object;

  return $this;
}

1;
