# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************

#!/usr/bin/perl -w
#
# globals
$types = "satellite_types.txt";  
$types_file = "./platforms/" . $types;  # The boilerplate types file.  
                                        # Either use this file or create your own custom type(s).
$save = "./TLE/"; # The directory where the tle-based platform definitions are stored.
my %seen; # Keep track of satellites we've processed as they may occur in multiple files.

# Convert a single tle file, producing an output file with platform definitions
sub ConvertTLE_File # <infile> <outfile>
{
   $tle_file_name = $_[0];
   $tle_out_file_name = $_[1];

   if (! open(TLE_IN, "+<", $tle_file_name)) 
   {
       die("** ERROR: File $tle_file_name could not be opened\n");
   }

   open TLE_OUT, ">", $tle_out_file_name;
   print { TLE_OUT } "# See $types for platform type definitions.\n\n";
   $object_count = 0;

   while ($line = <TLE_IN>)
   {
      $header = $line;
      $tle_line1 = <TLE_IN>;
      $tle_line2 = <TLE_IN>;
      $header    =~ s/\s+$//;
      $tle_line1 =~ s/\s+$//;
      $tle_line2 =~ s/\s+$//;
      $header =~ s/ /_/g;
      $header =~ s/\[\+\]//g;
      $catalog_number = substr $tle_line2, 2, 5;
      $header .= "(" . $catalog_number . ")";
      $skip = 0;
      #print $header, "\n";
      # By default, only use operational satellites
      # (not inactive or spares)
      if (($header =~ /\[\-\]/) || ($header =~ /\[S\]/))   
      {
         $skip = 1;
         #print "Skipped!";
      }
      if (exists $seen{$header})
      {
         $skip = 1;
         #print "Skipped $header\n";
      }
      else
      {
         $seen{$header}=$header;
      }
      if ($skip == 0)
      {
         ++$object_count;
         print { TLE_OUT } "platform $header $type\n",
                           "   orbit\n",
                           "$tle_line1\n",
                           "$tle_line2\n",
                           "   end_orbit\n", 
                           "end_platform\n\n";
      }   
   }

   # Close input and output files
   close(TLE_IN);
   close(TLE_OUT);
   select(STDOUT);
   print "Finished; processed ", $object_count , " objects.\n\n";
}

# Save a boilerplate platform type to the types file.
sub SavePlatformType  # <type> <side> <icon>
{
   $type = $_[0];
   $side = $_[1];
   $icon = $_[2];
   #print "Saving type " . $type, "\n";
   open(TYPES_FILE, ">>", $types_file);
   print { TYPES_FILE } "platform_type $type WSF_PLATFORM\n",
                        "  side $side\n",
                        "  icon $icon\n",
                        "  mover WSF_NORAD_SPACE_MOVER\n",
                        "  end_mover\n",
                        "end_platform_type\n\n";
}

# Extract a single tle file from the celestrack database
# and write it to a temporary file for processing into platform instances
sub Extract
{
   use LWP::Simple;
   my $save = $_[0];
   $url = 'http://www.celestrak.com/NORAD/elements/' . $_[1] . '.txt';
   print "Downloading " . $url . "\n";
   my $file = get $url;
   $tmp = $save .  $_[1] . '_out.txt';
   $out = $save .  $_[1] . '_platforms.txt';
   open( FILE, '>', $tmp ) or die $!;
   #print $file;
   print "  ...Saving data\n";
   print FILE $file;
   close( FILE );
   my $type = $_[2];
   my $side = $_[3];
   my $icon = $_[4];
   SavePlatformType($type, $side, $icon);
   print "  ...Converting data\n";
   #print `perl convert_tle_file.pl $tmp $out $type $side $icon 2>&1`;
   ConvertTLE_File($tmp, $out);
   unlink($tmp);
}

if (! -d $save)
{
   unless(mkdir $save)
   {
      die("Cannot create directory " . $save);
   }
}

#Delete old types file
if (-e $types_file)
{
   unless(unlink $types_file)
   {
      die("Cannot delete old types file " . $types_file);
   }
}

#List of files to extract
#By default, extract everything
#Comment out the lines you don't want extracted
# Arguments    filename   type     side   icon
Extract($save, "stations",    "SPACE_STATION",  "yellow",      "satellite");
Extract($save, "argos",       "NOAA",           "light_yellow","satellite");
Extract($save, "beidou",      "BEIDOU",         "green",       "satellite");
Extract($save, "education",   "EDUCATION",      "light_green", "satellite");
Extract($save, "engineering", "ENGINEERING",    "yellow",      "satellite");
Extract($save, "galileo",     "GALILEO",         "orange",     "satellite");
Extract($save, "geo",         "GEO",            "blue",        "satellite");
Extract($save, "glo-ops",     "glonass",        "red",         "satellite");  #COSMOS
Extract($save, "globalstar",  "GLOBALSTAR",     "blue",        "satellite");
Extract($save, "goes",        "GOES",           "orange",      "satellite");
#Extract($save, "gorizont",    "GORIZONT",       "violet",      "satellite"); # all inactive
Extract($save, "gps-ops",     "GPS",            "green",       "satellite");
Extract($save, "intelsat",    "INTELSAT",       "pink",        "satellite");
Extract($save, "iridium",     "IRIDIUM",        "brown",       "satellite");
Extract($save, "molniya",     "MOLNIYA",        "magenta",     "satellite");
Extract($save, "musson",      "RUSSIA_LEO_NAV", "red",         "satellite");
Extract($save, "nnss",        "NAVY_NAV",       "blue",        "satellite");
Extract($save, "orbcomm",     "ORBCOMM",        "light_blue",  "satellite");
Extract($save, "resource",    "RESOURCE",       "light_green", "satellite");
Extract($save, "sarsat",      "SEARCH_RESCUE",  "yellow",      "satellite");
Extract($save, "science",     "SCIENCE",        "violet",      "satellite");
Extract($save, "tdrss",       "TDRSS",          "gray",        "satellite");
Extract($save, "weather",     "WEATHER",        "violet",      "satellite");
Extract($save, "x-comm",      "X-COMM",         "brown",       "satellite");

Extract($save, "amateur",     "AMATEUR",        "gray",        "satellite");
Extract($save, "cubesat",     "CUBESAT",        "light_blue",  "satellite");

print "Done.\n"
