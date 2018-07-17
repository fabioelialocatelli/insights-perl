package Filter;

use strict;
use warnings;

use List::MoreUtils 'true';
use List::MoreUtils 'uniq';

use Designer;
use Formatter;

sub new {
    my ($object, $attributes) = @_;
    my $filePrefix = $attributes->{reportingPeriod};

    my $this = bless {
        fileUsers => $filePrefix . "-" . "Users.csv",
        fileCombined => $filePrefix . "-" . "Combined.html",
        fileReport => $filePrefix . "-" . "Report.html",
        filePresentation => $filePrefix . "-" . "Presentation.html",
        reportingPeriod => $attributes->{reportingPeriod}
    }, $object;

    return $this;
}

sub mergeLogs {

    my $combinedWriter;
    my $logReader;

    my @logFiles = glob('*.log *.txt');
    my $foundLogs = scalar(@logFiles);

    if($foundLogs != 0){
      my $this = shift();
      my $fileCombined = $this->{fileCombined};
      my $reportingPeriod = $this->{reportingPeriod};

      my $documentFormatter = Formatter->new();

      if(-f $fileCombined){
          open ($combinedWriter, '>:encoding(UTF-8)', $fileCombined)
          or die "Could not open $fileCombined for writing...";

      } elsif(! -f $fileCombined) {
          open ($combinedWriter, '>>:encoding(UTF-8)', $fileCombined)
          or die "Could not open $fileCombined for appending...";
      }

      print $combinedWriter $documentFormatter->{openHtml};
      print $combinedWriter $documentFormatter->{openBody};

      foreach (@logFiles) {

          open ($logReader, '<:encoding(UTF-8)', $_)
          or die "Could not open $_ for reading...";

          while (my $logEntry = <$logReader>) {
              if (grep{/$reportingPeriod/} $logEntry){
                  print $combinedWriter $logEntry;
              }
          }

          close $logReader;
      }

      print $combinedWriter $documentFormatter->{closeBody};
      print $combinedWriter $documentFormatter->{closeHtml};

      close $combinedWriter;

    } elsif($foundLogs == 0) {

        print "There are no logs. Aborting...";
        clearMarkup();
        exit;
    }
}

sub generateReport {

    my $reportWriter;
    my $combinedReader;

    my $formattedLogEntry;
    my $successfulTags;
    my $unsuccessfulTags;
    my $successfulAuths;
    my $unsuccessfulAuths;

    my $this = shift();
    my $fileReport = $this->{fileReport};
    my $fileCombined = $this->{fileCombined};

    my $documentDesigner = Designer->new();
    my $documentFormatter = Formatter->new();

    open($reportWriter, '>:encoding(UTF-8)', $fileReport)
    or die "Could not open $fileReport for writing...";

    open($combinedReader, '<:encoding(UTF-8)', $fileCombined)
    or die "Could not open $fileCombined for reading...";

    print $reportWriter $documentFormatter->{openHtml};
    print $reportWriter $documentFormatter->{openHead};
    print $reportWriter $documentFormatter->{openStyle};

    print $reportWriter $documentDesigner->{indentSelector} . "body" . $documentDesigner->{openBlock};
    print $reportWriter $documentDesigner->{indentBlock}. "background-color: " . $documentDesigner->{backgroundColor};
    print $reportWriter $documentDesigner->{indentBlock}. "font-family: " . $documentDesigner->{fontFamily};
    print $reportWriter $documentDesigner->{closeBlock};

    print $reportWriter $documentFormatter->{closeStyle};
    print $reportWriter $documentFormatter->{closeHead};
    print $reportWriter $documentFormatter->{openBody};

    while (my $logEntry = <$combinedReader>) {

        chomp($logEntry);

        if ($logEntry =~ /logged in successfully/ && $logEntry !~ /admin/) {
            $formattedLogEntry = $documentFormatter->{openParagraph} . $logEntry . $documentFormatter->{closeParagraph};
            $successfulTags .= $formattedLogEntry;
            $successfulAuths++;
        }

        if ($logEntry =~ /Failed to login/ && $logEntry !~ /admin/) {
            $formattedLogEntry = $documentFormatter->{openParagraph} . $logEntry . $documentFormatter->{closeParagraph};
            $unsuccessfulTags .= $formattedLogEntry;
            $unsuccessfulAuths++;
        }
    }

    if(defined($successfulTags) && defined($successfulAuths)){
        print $reportWriter $successfulTags;
        print $reportWriter $documentFormatter->{openHeader} . "Successful Authentications: " . $successfulAuths . $documentFormatter->{closeHeader};
    }

    if(defined($unsuccessfulTags) && defined($unsuccessfulAuths)){
        print $reportWriter $unsuccessfulTags;
        print $reportWriter $documentFormatter->{openHeader} . "Unsuccessful Authentications: " . $unsuccessfulAuths . $documentFormatter->{closeHeader};
    }

    print $reportWriter $documentFormatter->{closeBody};
    print $reportWriter $documentFormatter->{closeHtml};

    close $reportWriter;
    close $combinedReader;
}

sub generateList {

    my $reportReader;
    my $presentationWriter;

    my @userAuthentications;
    my @userAuthenticationsUnique;

    my $this = shift();
    my $fileReport = $this->{fileReport};
    my $fileCombined = $this->{fileCombined};
    my $filePresentation = $this->{filePresentation};
    my $reportingPeriod = $this->{reportingPeriod};

    my $documentDesigner = Designer->new();
    my $documentFormatter = Formatter->new();

    open($reportReader, '<:encoding(UTF-8)', $fileReport)
    or die "Could not open $fileReport for reading...";

    open($presentationWriter, '>:encoding(UTF-8)', $filePresentation)
    or die "Could not open $filePresentation for writing...";

    print $presentationWriter $documentFormatter->{openHtml};
    print $presentationWriter $documentFormatter->{openHead};
    print $presentationWriter $documentFormatter->{openStyle};

    print $presentationWriter $documentDesigner->{indentSelector} . "body" . $documentDesigner->{openBlock};
    print $presentationWriter $documentDesigner->{indentBlock}. "background-color: " . $documentDesigner->{backgroundColor};
    print $presentationWriter $documentDesigner->{indentBlock}. "font-family: " . $documentDesigner->{fontFamily};
    print $presentationWriter $documentDesigner->{closeBlock};

    print $presentationWriter $documentDesigner->{indentSelector} . "td, " . "th" . $documentDesigner->{openBlock};
    print $presentationWriter $documentDesigner->{indentBlock}. "text-align: " . $documentDesigner->{textAlign};
    print $presentationWriter $documentDesigner->{indentBlock}. "padding: " . $documentDesigner->{padding};
    print $presentationWriter $documentDesigner->{closeBlock};

    print $presentationWriter $documentDesigner->{indentSelector} . "table" . $documentDesigner->{openBlock};
    print $presentationWriter $documentDesigner->{indentBlock}. "table-layout: " . $documentDesigner->{tableLayout};
    print $presentationWriter $documentDesigner->{indentBlock}. "width: " . $documentDesigner->{tableWidth};
    print $presentationWriter $documentDesigner->{indentBlock}. "margin: " . $documentDesigner->{margin};
    print $presentationWriter $documentDesigner->{closeBlock};

    print $presentationWriter $documentDesigner->{indentSelector} . "td, " . "th, " . "table" . $documentDesigner->{openBlock};
    print $presentationWriter $documentDesigner->{indentBlock}. "border-style: " . $documentDesigner->{borderStyle};
    print $presentationWriter $documentDesigner->{indentBlock}. "border-width: " . $documentDesigner->{borderWidth};
    print $presentationWriter $documentDesigner->{indentBlock}. "border-collapse: " . $documentDesigner->{borderCollapse};
    print $presentationWriter $documentDesigner->{closeBlock};    

    print $presentationWriter $documentFormatter->{closeStyle};
    print $presentationWriter $documentFormatter->{closeHead};
    print $presentationWriter $documentFormatter->{openBody};

    print $presentationWriter $documentFormatter->{openHeader};
    print $presentationWriter "Authentications During " . $reportingPeriod;
    print $presentationWriter $documentFormatter->{closeHeader};

    print $presentationWriter $documentFormatter->{openUnorderedList};

    while (my $reportEntry = <$reportReader>) {

        if(grep {/INFO/} $reportEntry){

            my $indexOffset = 1;
            my $indexLeft = index($reportEntry, "'") + $indexOffset;
            my $indexRight = rindex($reportEntry, "'") + $indexOffset;
            my $stringLength = $indexRight - $indexLeft - $indexOffset;
            my $listEntry = substr($reportEntry, $indexLeft, $stringLength);

            if(grep {/@/} $listEntry){

                my @truncatedIdentifier = split('@', $listEntry);
                my $domain = pop(@truncatedIdentifier);
                my $user = pop(@truncatedIdentifier);
                my $recomposedEntry = join('@', $user, $domain);

                push(@userAuthentications, $recomposedEntry);
            }
        }
    }

    @userAuthenticationsUnique = uniq(@userAuthentications);

    foreach(@userAuthenticationsUnique){
        print $presentationWriter $documentFormatter->{openListEntry} . $_ . $documentFormatter->{closeListEntry};
    }

    print $presentationWriter $documentFormatter->{closeUnorderedList};

    close $presentationWriter;
    close $reportReader;
}

sub countAuthentications {

    my $presentationReader;
    my $presentationWriter;
    my $reportReader;

    my @userIdentifiers;

    my $this = shift();
    my $fileReport = $this->{fileReport};
    my $filePresentation = $this->{filePresentation};

    my $documentFormatter = Formatter->new();

    open($presentationReader, '<:encoding(UTF-8)', $filePresentation)
    or die "Unable to open $filePresentation for reading...";

    open($presentationWriter, '>>:encoding(UTF-8)', $filePresentation)
    or die "Unable to open $filePresentation for appending...";

    open($reportReader, '<:encoding(UTF-8)', $fileReport)
    or die "Unable to open $fileReport for reading...";

    while (my $listEntry = <$presentationReader>) {

        if (grep {/<li>/} $listEntry){

            my $indexOffset = 1;
            my $indexLeft = index($listEntry, ">") + $indexOffset;
            my $indexRight = rindex($listEntry, "<") + $indexOffset;
            my $stringLength = $indexRight - $indexLeft - $indexOffset;
            my $userIdentifier = substr($listEntry, $indexLeft, $stringLength);

            push(@userIdentifiers, $userIdentifier);
        }
    }

    while(my @reportContent = <$reportReader>){

        my @successfulConnections = grep {/logged in successfully/} @reportContent;
        my @unsuccessfulConnections = grep {/Failed to login/} @reportContent;

        print $presentationWriter $documentFormatter->{openHeader} . "Authentication Breakdown" . $documentFormatter->{closeHeader};

        print $presentationWriter $documentFormatter->{openTable};
        print $presentationWriter $documentFormatter->{openTableRow};
        print $presentationWriter $documentFormatter->{openTableHeader} . "User Email" . $documentFormatter->{closeTableHeader};
        print $presentationWriter $documentFormatter->{openTableHeader} . "Successful Attempts" . $documentFormatter->{closeTableHeader};
        print $presentationWriter $documentFormatter->{closeTableRow};

        foreach(@userIdentifiers){
            my $userIdentifier;
            my $userIdentifierOccurrences;

            $userIdentifier = $_;
            $userIdentifierOccurrences =  true {/$userIdentifier/} @successfulConnections;

            print $presentationWriter $documentFormatter->{openTableRow};
            print $presentationWriter $documentFormatter->{openTableCell} . $_ . $documentFormatter->{closeTableCell};
            print $presentationWriter $documentFormatter->{openTableCell} . $userIdentifierOccurrences . $documentFormatter->{closeTableCell};
            print $presentationWriter $documentFormatter->{closeTableRow};
        }

        print $presentationWriter $documentFormatter->{closeTable};

        print $presentationWriter $documentFormatter->{openTable};
        print $presentationWriter $documentFormatter->{openTableRow};
        print $presentationWriter $documentFormatter->{openTableHeader} . "User Email" . $documentFormatter->{closeTableHeader};
        print $presentationWriter $documentFormatter->{openTableHeader} . "Unsuccessful Attempts" . $documentFormatter->{closeTableHeader};
        print $presentationWriter $documentFormatter->{closeTableRow};

        foreach(@userIdentifiers){
            my $userIdentifier;
            my $userIdentifierOccurrences;

            $userIdentifier = $_;
            $userIdentifierOccurrences =  true {/$userIdentifier/} @unsuccessfulConnections;

            print $presentationWriter $documentFormatter->{openTableRow};
            print $presentationWriter $documentFormatter->{openTableCell} . $_ . $documentFormatter->{closeTableCell};
            print $presentationWriter $documentFormatter->{openTableCell} . $userIdentifierOccurrences . $documentFormatter->{closeTableCell};
            print $presentationWriter $documentFormatter->{closeTableRow};
        }

        print $presentationWriter $documentFormatter->{closeTable};
        print $presentationWriter $documentFormatter->{closeBody};
        print $presentationWriter $documentFormatter->{closeHtml};
    }

    close $presentationWriter;
    close $presentationReader;
    close $reportReader;
}

sub parseMarkup {

    my $markupReader;
    my $markupWriter;
    my $logReader;

    my @userEntries;
    my @alphabeticallySortedRecords;
    my @filesLog = glob('*.log *.txt');
    my @filesMarkup = glob('*.xml *.xhtml');

    my $this = shift();
    my $fileRecords = $this->{fileUsers};
    my $fileLogs = $this->{fileCombined};

    my $foundMarkups = scalar(@filesMarkup);

    if($foundMarkups != 0){

        foreach (@filesMarkup) {

            open ($markupReader, '<:encoding(UTF-8)', $_)
            or die "Could not open $_ for reading...";

            while (my $markupEntry = <$markupReader>) {
                if (grep{/user mail/} $markupEntry){

                    if($markupEntry !~ /admin/){

                        my $userName = filter($markupEntry, "fullname", "userid", "\"");
                        my $userMail = filter($markupEntry, "mail", "useldap", "\"");
                        my $userMailCaseLower = lc($userMail);

                        open ($logReader, '<:encoding(UTF-8)', $fileLogs)
                        or die "Could not open $fileLogs for writing...";

                        my @logEntries;
                        while(my $logEntry = <$logReader>){
                            push(@logEntries, $logEntry);
                        }

                        if(length($userMailCaseLower) != 0){
                            my @userIdentifiers = grep{/$userMailCaseLower/} @logEntries;
                            my @authenticationSuccessful = grep{/logged in successfully/} @userIdentifiers;
                            my @authenticationUnsuccessful = grep{/Failed to login/} @userIdentifiers;

                            my $countSuccessful = scalar(@authenticationSuccessful);
                            my $countUnsuccessful = scalar(@authenticationUnsuccessful);

                            unless($countSuccessful == 0){
                                $countUnsuccessful =~ tr/0/-/;
                                push (@userEntries, $userName . "," . $userMailCaseLower . "," . $countSuccessful . "," . $countUnsuccessful . "\n");
                            }                           
                        }
                    }
                }
            }

            @alphabeticallySortedRecords = sort(@userEntries);
            close $markupReader;
        }

        open ($markupWriter, '>:encoding(UTF-8)', $fileRecords)
        or die "Could not open $fileRecords for writing...";

        foreach (@alphabeticallySortedRecords){
            print $markupWriter $_;
        }

        close $markupWriter;

  } elsif($foundMarkups == 0) {

        print "Users file required. Aborting...";        
        clearSheet();
        clearMarkup();
        exit;
    }
}

sub filter {

    my $stringInput = $_[0];
    my $filterBeginning = $_[1];
    my $filterEnding = $_[2];
    my $filterSeparator = $_[3];

    my $indexOffset = 1;

    my $indexLeft;
    my $indexRight;
    my $stringLength;
    my $stringUnrefined;
    my $stringRefined;

    $indexLeft = index($stringInput, $filterBeginning) + $indexOffset;
    $indexRight = index($stringInput, $filterEnding) + $indexOffset;
    $stringLength = $indexRight - $indexLeft - $indexOffset;
    $stringUnrefined = substr($stringInput, $indexLeft, $stringLength);

    $indexLeft = index($stringUnrefined, $filterSeparator) + $indexOffset;
    $indexRight = rindex($stringUnrefined, $filterSeparator) + $indexOffset;
    $stringLength = $indexRight - $indexLeft - $indexOffset;
    $stringRefined = substr($stringUnrefined, $indexLeft, $stringLength);

    return $stringRefined;
}

sub clearMarkup {

    my @markupFiles = glob('*.html');
    my $foundReports = scalar(@markupFiles);

    if($foundReports != 0){
        unlink(@markupFiles);
    }
}

sub clearSheet {
    my @commaFiles = glob('*.csv');
    my $foundSheets = scalar(@commaFiles);

    if($foundSheets != 0){
        unlink(@commaFiles);
    }
}

1;
