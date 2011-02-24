#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  MakeTestMetadata.pl
#
#        USAGE:  ./MakeTestMetadata.pl  
#
#  DESCRIPTION:  Create test metadata to test PhenoRipper's reading
#  metadata from file functionality
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  YOUR NAME (), 
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  02/21/2011 04:40:02 PM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use File::Find;

my $dir='./TestImages/Test1/';
find(\&Wanted,$dir);

sub Wanted
{
   /\-1.png$/ or return;
   my $fn=$_;
   my $dn=$File::Find::dir;
   my @tokens=split "-",$fn;
   my $channel;
   for($channel=1;$channel<=3;$channel++)
   {
       print $File::Find::dir,"/";
       print $tokens[0],"-",$channel,".png";
       if($channel<3)
       {
        print ";";
       }
   }   
   @tokens=split /\//,$dn;
   print ",",$tokens[-1],"\n";
}
