package Designer;

use strict;
use warnings;

sub new{
    my $object = @_;
    my $this = bless {
    backgroundColor => "azure;\n",
    fontFamily => "sans-serif;\n",
    fontWeight => "normal;\n",
    borderWidth => "1px;\n",
    borderStyle => "solid;\n",
    borderCollapse => "collapse;\n",
    margin => "1.25em;\n",
    padding => "0.25em;\n",
    tableLayout=> "auto;\n",
    width => "15em;\n",
    openBlock => "{\n",
    closeBlock => "\t\t}\n",
    indentSelector => "\t\t",
    indentBlock => "\t\t\t"
  }, $object;

  return $this;
}

1;
