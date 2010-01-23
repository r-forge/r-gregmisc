#!/usr/bin/perl

BEGIN  {
use File::Basename;
unshift(@INC, dirname $0);
}

use strict;
use Spreadsheet::ParseExcel;

# declare some varibles local
my($row, $col, $sheet, $cell, $usage, $basename, $sheetnumber, $filename);

##
## Usage information
##
$usage = <<EOF;

sheetCount.pl <excel file>

Output is the number of sheets in the excel file.

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

my $oExcel = new Spreadsheet::ParseExcel;

open(FH, "<$fileName") or die "Unable to open file '$fileName'.\n";
close(FH);

my $oBook = $oExcel->Parse($fileName);

print $oBook->{SheetCount} , "\n";

