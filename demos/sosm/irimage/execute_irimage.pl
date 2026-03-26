# ****************************************************************************
# CUI//REL TO USA ONLY
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
#!/usr/bin/perl
# =============================================================================
# Execute IRIMAGE to generate the kio3 files necessary to create the target
# tables needed for the 'Spectral Optical Detection Model' (SOSM).
# =============================================================================

use Cwd;
use Cwd 'abs_path';
use File::Basename;
use File::Spec;

# =============================================================================

$gFileTemplate = "";
$gMachStr = "";
$gMach = 0.0;

# Band list (name)
@gBandList = ( );

# Altitude samples (feet)
@gAltitudeList = ( );

$gConfigBase = "";

# =============================================================================

$onWindows = 0;
$onUnix    = 1;
if ($^O =~ /MSWin/)
{
    $onWindows = 1;
    $onUnix    = 0;
}

# Locate the directory containing this script and form the name
# of the execution interface scripts needed to execute IRIMAGE.
#
# Absolute path names are required because we 'cd' around.

$proc_fullname = File::Spec->rel2abs($0);
( $proc_vol, $proc_dir, $proc_file) = File::Spec->splitpath($proc_fullname);
if ($onWindows)
{
    $irimage = File::Spec->catpath($proc_vol, $proc_dir, "irimage.bat");
}
else
{
    $irimage = File::Spec->catpath($proc_vol, $proc_dir, "irimage.sh");
}
die "-FAIL- Unable to locate script $irimage\n" if (! -f $irimage);

# =============================================================================

ReadInput();

die "***** ERROR: 'band_list' block not provided\n"     if @gBandList == 0;
die "***** ERROR: 'altitude_list' block not provided\n" if @gAltitudeList == 0;

$gVehicleType = $gConfigBase;
$gBaseFile = $gConfigBase . '_base.nam';

print "***** Starting " . localtime() . "\n";

foreach $bandEntry (@gBandList)
{
   ($bandStr, $bandFile) = split(' ', $bandEntry);
   foreach $altEntry (@gAltitudeList)
   {
      ($altStr, $altitude) = split(' ', $altEntry);
      my $fileTemplate = $gFileTemplate;
      $fileTemplate =~ s/%ALT%/$altStr/g;
      $fileTemplate =~ s/%MACH%/$gMachStr/g;
      $fileTemplate =~ s/%BAND%/$bandStr/g;
      my $line;
      my $nam_file = $fileTemplate . '.nam';
         
      open(TARGET, ">$nam_file") or die "Unable to open output file $nam_file";
      print TARGET " \$NAM1\n";

      open(SOURCE, "<$bandFile") or die "Unable to open input file $bandFile";         
      while ($line = <SOURCE>)
      {
         print TARGET $line;
      }
      print TARGET "\n";
      close SOURCE;

      $base_file = $gConfigBase . ".iri";
      open(SOURCE, "<$base_file") or die "Unable to open input file $base_file";
      while ($line = <SOURCE>)
      {
         $line =~ s/%ZTAR%/$altitude/;
         $line =~ s/%XMACH%/$gMach/;
         $line =~ s/%CASE%/$fileTemplate/;
         print TARGET $line;
      }
      close SOURCE;
         
      close TARGET;

      my $suffix;   
      foreach $suffix ( '.env', '.iriout', '.kio3')
      {
         unlink($baseName . $suffix);
      }
         
      print "Invoking: irimage $nam_file\n";
      system("$irimage $nam_file");
   }
}

# =============================================================================
sub ReadInput
{
   my $configFile = "";
   if (@ARGV > 0)
   {
      $configFile = $ARGV[0];
   }
   die "***** ERROR: Configuration not specified\n" if $configFile eq "";

   my $extIndex = rindex($configFile, '.');
   if ($extIndex < 0)
   {
      # No suffix, assume ".def"
      $gConfigBase = $configFile;
      $configFile  = $gConfigBase . '.def';
   }
   else
   {
      # Suffix supplied
      $gConfigBase = substr($configFile, 0, $extIndex);
   }

   open CONFIG, "<$configFile" or die "***** ERROR Unable to open $configFile\n";

   # Read three 'identification cards'. These are simply copied to the output files
   # so the user can identify the source of the files.
   
   my $line;
   while ($line = <CONFIG>)
   {
      chomp($line);
      next if ($line =~ /^ *#/);     # Skip comments
      next if ($line =~ /^ *$/);     # Skip blank lines
      my @values = split(' ', $line);
      if ($values[0] =~ /^\s*altitude/)
      {
         my $altStr = $values[1];
         my $alt = $values[2];
         push @gAltitudeList, "$altStr $alt";
      }
      elsif ($values[0] =~ /^\s*band/)
      {
         my $bandStr = $values[1];
         my $bandFile = $values[2];
         push @gBandList, "$bandStr $bandFile";
      }
      elsif ($values[0] =~ /\s*file_template/)
      {
         $gFileTemplate = $values[1];
      }
      elsif ($values[0] =~ /\s*mach/)
      {
         $gMachStr = $values[1];
         $gMach    = $values[2];
      }
      else
      {
         die "***** ERROR: Unknown line: $line\n";
      }
   }
   close CONFIG;
}
