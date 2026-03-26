# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************

#!/usr/bin/perl -w
# convert a tle list to an afnes player list.
# 

if (@ARGV < 2)  # 7 arguments corresponds to ARGV=8
{
   die("Not enough arguments.\nUsage: modify_tle_list <tle_in_file> <tle_out_file>\n");
}

$tle_file_name = $ARGV[0];
$tle_out_file_name = $ARGV[1];

if (! open(TLE_IN, "+<", $tle_file_name)) 
{
    die("** ERROR: File $tle_file_name could not be opened\n");
}

open TLE_OUT, ">", $tle_out_file_name;

$object_count = 0;

print { TLE_OUT } "platform_type SATELLITE WSF_PLATFORM\n   side green\n   mover WSF_NORAD_SPACE_MOVER end_mover\n   icon satellite\nend_platform_type\n\n";
print { TLE_OUT } "platform_type ROCKET_BOOSTER SATELLITE\n   side indigo\nend_platform_type\n\n";
print { TLE_OUT } "platform_type IRIDIUM SATELLITE\n   side brown \nend_platform_type\n\n";
print { TLE_OUT } "platform_type GLOBALSTAR SATELLITE\n   side orange \nend_platform_type\n\n";
print { TLE_OUT } "platform_type DEBRIS SATELLITE\n   side red\nend_platform_type\n\n";
print { TLE_OUT } "platform_type ISS SATELLITE\n   side yellow\nend_platform_type\n\n";
print { TLE_OUT } "platform_type FENGYUN SATELLITE\n   side magenta\nend_platform_type\n\n";
$skip = 0;

while ($line = <TLE_IN>)
{
   $header = $line;
   $tle_line1 = <TLE_IN>;
   $tle_line2 = <TLE_IN>;
   print $line;
   print $tle_line1;
   print $tle_line2;
   chop($header);
   chop($tle_line1);
   chop($tle_line2);
   $header =~ s/\s+$//;
   $header =~ s/ /_/g;
   $header =~ s/\[\+\]//g;
   $catalog_number = substr $tle_line2, 2, 5;
   print $catalog_number;
   $header .= "(" . $catalog_number . ")";
   $type = "SATELLITE";
   
   # only use operational satellites
   if (($header =~ /[-]/) || ($header =~ /[S]/))   
   {
      $skip = 1;
   }
   elsif ($header =~ /R\/B/)
   {
      $type =  "ROCKET_BOOSTER";
      $skip = 1;
   }
   elsif ($header =~ /FENGYUN/)
   {
      $type =  "FENGYUN";
      $skip = 0;
   }
   elsif ($header =~ /DEB/)
   {
      $type =  "DEBRIS";
      $skip = 1;
   }
   elsif ($header =~ /IRIDIUM/)
   {
      $type =  "IRIDIUM";
      $skip = 0;
   }
   elsif ($header =~ /ZARYA/)
   {
      $type =  "ISS";
      $skip = 0;
   }
   elsif ($header =~ /GLOBALSTAR/)
   {
      $type =  "GLOBALSTAR";
      $skip = 0;
   }
   else
   {
      $skip = 0; # FOR TYPE SATELLITE
   }
   if ($skip == 0)
   {
      ++$object_count;
      print { TLE_OUT } "platform ", $header, " ", $type, "\n";
      print { TLE_OUT } "   orbit\n";
      print { TLE_OUT } $tle_line1, "\n";
      print { TLE_OUT } $tle_line2, "\n";
      print { TLE_OUT } "   end_orbit\n", "end_platform\n\n";
   }   
}
# Close input and output files
close(TLE_IN);
close(TLE_OUT);
print "Finished; processed ", $object_count, " objects.\n";
