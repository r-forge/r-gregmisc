#!/usr/bin/perl

BEGIN  {
use File::Basename;
# Add current path to perl library search path
use lib dirname($0);
}

use strict;
use Spreadsheet::ParseExcel;
use Spreadsheet::XLSX;
use File::Spec::Functions;

# declare some varibles local
my($row, $col, $sheet, $cell, $usage,
   $filename, $volume, $directories, $whoami,
   $basename, $sheetnumber, $filename,
   $text);


##
## Figure out whether I'm called as sheetCount.pl or sheetNames.pl
##
($volume,$directories,$whoami) = File::Spec->splitpath( $0 );

if($whoami eq "sheetCount.pl")
  {
    $text="number";
  }
elsif ($whoami eq "sheetNames.pl")
  {
    $text="names";
  }
else
  {
    die("This script is named '$whoami', but must be named either 'sheetCount.pl' or 'sheetNames.pl' to function properly.\n");
  }

##
## Usage information
##
$usage = <<EOF;

sheetCount.pl <excel file>

Output is the $text of sheets in the excel file.

EOF

##
## parse arguments
##

if(!defined($ARGV[0]))
  {
    print $usage;
    exit 1;
  }

my $fileName=$ARGV[0];

##
## open spreadsheet
##

open(FH, "<$fileName") or die "Unable to open file '$fileName'.\n";
close(FH);

my $oBook;

## First try as a Excel 2007+ 'xml' file
eval
  {
    local $SIG{__WARN__} = sub {};
    $oBook = Spreadsheet::XLSX -> new ($ARGV[0]);
  };
## Then Excel 97-2004 Format
if($@)
  {
    $oBook = new Spreadsheet::ParseExcel->Parse($ARGV[0]) or \
      die "Error parsing file '$ARGV[0]'.\n";
  }


if($whoami eq "sheetCount.pl")
  {
    print $oBook->{SheetCount} , "\n";
  }
elsif ($whoami eq "sheetNames.pl")
  {
    ## Get list all worksheets in the file
    my @sheetlist =  (@{$oBook->{Worksheet}});

    foreach my $sheet (@sheetlist)
      {
	print "\"$sheet->{Name}\" ";
      }

    print "\n";
  }
else
  {
    die("This script is named '$whoami', but must be named either 'sheetCount.pl' or 'sheetNames.pl' to function properly.\n");
  }


