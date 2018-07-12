package Formatter;

use strict;
use warnings;

sub new{
  my $object = @_;
  my $this = bless {
    openHtml => "<html>\n",
    openHead => "\t<head>\n",
    openStyle => "\t\t<style>\n",
    openBody => "\t<body>\n",
    openHeader => "\t\t<h3>",
    openParagraph => "\t\t<p>",
    openTable => "\t\t<table>\n",
    openTableHeader => "\t\t\t\t<th>",
    openTableRow => "\t\t\t<tr>\n",
    openTableCell => "\t\t\t\t<td>",
    openUnorderedList => "\t<ul>\n",
    openListEntry => "\t\t<li>",
    closeHtml => "</html>\n",
    closeHead => "\t</head>\n",
    closeStyle => "\t\t</style>\n",
    closeBody => "\t</body>\n",
    closeHeader => "</h3>\n",
    closeParagraph => "</p>\n",
    closeTable => "\t\t</table>\n",
    closeTableHeader => "</th>\n",
    closeTableRow => "\t\t\t</tr>\n",
    closeTableCell => "</td>\n",
    closeUnorderedList => "\t</ul>\n",
    closeListEntry => "</li>\n"
  }, $object;

  return $this;
}

1;
