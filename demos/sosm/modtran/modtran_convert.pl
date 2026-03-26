# ****************************************************************************
# CUI//REL TO USA ONLY
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
#!/usr/bin/perl -W
# =============================================================================
# Convert MODTRAN PLT files to SOSM files
# =============================================================================

# Altitude samples (meters)
@gAltitudeList = ( );

# Elevation angle sample (meters)
@gElevationList = ( );

# Range samples (meters)
@gRangeList = ( );

$gCaseName = "";

# Wavenumbers
@gWavenumberList = ( );

# Values from the current block.
@gBlockElevation = "";
@gBlockAltitude  = "";
@gBlockRange     = "";
$gBlockKey       = "";
@gBlockWavenumbers = ( );
@gBlockValues      = ( );
$gBlockIsBoundary  = 0;
$gDefaultValue     = "";

# The table of values. The key is the 'block key'
%gTable = ( );

# The user-supplied identification line.
$gIdentLine1 = "";
$gIdentLine2 = "";
$gIdentLine3 = "";

# =============================================================================

if (@ARGV > 0)
{
   $gCaseName = $ARGV[0];
}
die "***** ERROR: Case name not specified\n" if $gCaseName eq "";

my $extIndex = rindex $gCaseName, '.';
if ($extIndex > 0)
{
   # Suffix supplied
   $gCaseName = substr($gCaseName, 0, $extIndex);
}

# Convert background transmittance file
$gDefaultValue = "0.00000000";
ConvertAltElFile($gCaseName, 'bgt', 0);

# Convert background radiance file
$gDefaultValue = "1.00000E-15";
ConvertAltElFile($gCaseName, 'bgr', 1);

# Convert foreground transmittance file
$gDefaultValue = "0.00000000";
ConvertAltElRangeFile($gCaseName, 'fgt', 0);

# Convert foreground radiance file
$gDefaultValue = "1.00000E-15";
ConvertAltElRangeFile($gCaseName, 'fgr', 1);

# =============================================================================
# Convert a MODTRAN plt file to a altitude/elevation file.
sub ConvertAltElFile
{
   my ($baseName, $fileType, $radianceFile) = @_;
   my $ifile = $baseName . '_' . $fileType . '.plt';
   my $ofile = $baseName . '.' . $fileType;
   print "Converting $ifile -> $ofile\n";
   open IFILE, "<$ifile" or die "***** ERROR: could not open $ifile for reading";
   open OFILE, ">$ofile" or die "***** ERROR: could not open $ofile for writing";

   BeginConversion(\*IFILE, \*OFILE);
   my $line;
   while ($line = <IFILE>)
   {
      if (substr($line, 0, 1) eq ' ')
      {
         SaveSpectralValue($line);
      }
      elsif (substr($line, 0, 2) eq '%{')
      {
         BeginSpectralBlock($line);
      }
      elsif (substr($line, 0, 2) eq '%}')
      {
         EndSpectralBlock();
      }
      elsif ($line =~ /^BOUNDARY/)
      {
         $gBlockIsBoundary = 1;
      }
   }
   
   PrintSpectralRange(\*OFILE);
   print OFILE scalar(@gAltitudeList), ' ', scalar(@gElevationList), "\n";
   my @previousBlock = ( );
   foreach $altitude (@gAltitudeList)
   {
      @previousBlock = MakeDefaultBlock();
      foreach $elevation (@gElevationList)
      {
         $gBlockKey = "$altitude $elevation";
         @block = split(' ', $gTable{$gBlockKey});
         if (@block == 0)
         {
            @block = @previousBlock;
         }
         if ($block[0] eq 'BOUNDARY')
         {
            # Block is a 'BOUNDARY' block. Indicate to the table reader that it should
            # just copy the value from the previous elevation.
            print OFILE $altitude, ' ', $elevation, " copy\n";
         }
         else
         {
            print OFILE $altitude, ' ', $elevation, "\n";
            print OFILE '  ';
            PrintArray(\*OFILE, " %12.5E",  '  ', \@block, $radianceFile);
         }
         @previousBlock = @block;
      }
   }
   close IFILE;
   close OFILE;
}

# =============================================================================
# Convert a MODTRAN plt file to an altitude/elevation/range file.
sub ConvertAltElRangeFile
{
   my ($baseName, $fileType, $radianceFile) = @_;
   my $ifile = $baseName . '_' . $fileType . '.plt';
   my $ofile = $baseName . '.' . $fileType;
   print "Converting $ifile -> $ofile\n";
   open IFILE, "<$ifile" or die "***** ERROR: could not open $ifile for reading";
   open OFILE, ">$ofile" or die "***** ERROR: could not open $ofile for writing";
   
   BeginConversion(\*IFILE, \*OFILE);
   my $line;
   while ($line = <IFILE>)
   {
      if (substr($line, 0, 1) eq ' ')
      {
         SaveSpectralValue($line);
      }
      elsif (substr($line, 0, 2) eq '%{')
      {
         BeginSpectralBlock($line);
      }
      elsif (substr($line, 0, 2) eq '%}')
      {
         EndSpectralBlock();
      }
      elsif ($line =~ /^BOUNDARY/)
      {
         $gBlockIsBoundary = 1;
      }
   }
   
   PrintSpectralRange(\*OFILE);
   print OFILE scalar(@gAltitudeList), ' ', scalar(@gElevationList), ' ', scalar(@gRangeList), "\n";
   my @previousBlock = ( );
   foreach $altitude (@gAltitudeList)
   {
      print OFILE $altitude, "\n";
      foreach $elevation (@gElevationList)
      {
         @previousBlock = MakeDefaultBlock();
         foreach $range (@gRangeList)
         {
            $gBlockKey = "$altitude $elevation $range";
            @block = split(' ', $gTable{$gBlockKey});
            if (@block == 0)
            {
               @block = @previousBlock;
            }
            if ($block[0] eq 'BOUNDARY')
            {
               # Block is a 'BOUNDARY' block. Indicate to the table reader that it should
               # just copy the value from the previous range.
               print OFILE '  ', $elevation, ' ', $range, " copy\n";
            }
            else
            {
               print OFILE '  ', $elevation, ' ', $range, "\n";
               print OFILE '   ';
               PrintArray(\*OFILE, " %12.5E", '   ', \@block, $radianceFile);
            }
            @previousBlock = @block;
         }
      }
   }
   close IFILE;
   close OFILE;
}

#===============================================================================
# AddToList(\@list, $value)
# Like 'push' except it won't do anything if the value is already in the list.
sub AddToList
{
   my ($listRef, $value) = @_;
   
   foreach $listValue (@$listRef)
   {
      return if ($value eq $listValue);
   }
   push @$listRef, $value;
}

# =============================================================================
# Begin the conversion process.
#
# This reads the header from the input file (which defines the sizes of the arrays)
sub BeginConversion()
{
   my ($IFILE, $OFILE) = @_;

   # Read the three user-supplied case identification lines.
   
   $gIdentLine1 = <$IFILE>;
   $gIdentLine2 = <$IFILE>;
   $gIdentLine3 = <$IFILE>;
   print $OFILE $gIdentLine1;
   print $OFILE $gIdentLine2;
   print $OFILE $gIdentLine3;

   @gAltitudeList  = ( );
   @gElevationList = ( );
   @gRangeList     = ( );
   %gTable         = ( );
   $gBlockKey      = "";
   @gBlockWavenumbers = ( );
   @gBlockValues      = ( );
   $gBlockIsBoundary  = 0;
}

# =============================================================================
# This is called when a "%{" line is read.
sub BeginSpectralBlock
{
   my $line = $_[0];
   
   $line = substr($line, 2);
   ($gBlockAltitude, $gBlockElevation, $gBlockRange) = split(" ", $line);
   
   AddToList(\@gAltitudeList, $gBlockAltitude);
   AddToList(\@gElevationList, $gBlockElevation);
   
   if ($gBlockRange eq "")
   {
      # Altitude/Elevation block
      $gBlockKey = "$gBlockAltitude $gBlockElevation";
   }
   else
   {
      # Altitude/Elevation/Range block
      $gBlockKey = "$gBlockAltitude $gBlockElevation $gBlockRange";
      AddToList(\@gRangeList, $gBlockRange);
   }
   
   @gBlockWavenumbers = ( );
   @gBlockValues      = ( );
   $gBlockIsBoundary  = 0;
}

# =============================================================================
# This is called when a "%}" line is read.
sub EndSpectralBlock
{
   if ((@gBlockWavenumbers != 0) &&
       $gBlockIsBoundary)
   {
      # A 'BOUNDARY' block shouldn't have any MODTRAN data present!
      die "***** ERROR: MODTRAN data found for BOUNDARY $gBlockKey";
   }
   
   if (@gBlockWavenumbers == 0)
   {
      # A MODTRAN solution was not present for this block, this occurs for one
      # of two reasons:
      #
      # 1) MODTRAN died without generating data.
      # 2) The execution was suppressed because a previous range sample for this
      #    altitude/elevation hit the space/ground boundary.
      #
      # In case 1 issue a warning. In case 2 we don't. In either case, the previous
      # block will be used.

      if ($gBlockIsBoundary)
      {
         push @gBlockValues, 'BOUNDARY';
      }
      else
      {
         print "***** WARNING: No data was present for altitude=$gBlockAltitude,",
               " elevation=$gBlockElevation";
         if ($gBlockRange ne "")
         {
            print " range=$gBlockRange";
         }
         print "\n";
      }
   }
   elsif (@gWavenumberList == 0)
   {
      # Wavenumbers have not been captured - save them for future use.
      @gWavenumberList = @gBlockWavenumbers;
   }
   else
   {
      # Ensure the wavenumbers for this block match the saved values.
   }

   $gTable{$gBlockKey} = join(' ', @gBlockValues);
}

# =============================================================================
sub MakeDefaultBlock
{
   my @block = ( );
   my $i;
   for ($i = 0; $i < @gWavenumberList; ++$i)
   {
      push @block, $gDefaultValue;
   }
   return @block;
}

# =============================================================================
sub PrintArray
{
   my ($FILE, $format, $indent, $arrayRef, $radianceValues) = @_;
   my $count = 0;
   my $index = 0;
   my $inValue;
   my $outValue;
   my $wavenumber;
   
   foreach $inValue (@$arrayRef)
   {
      if ($count == 6)
      {
         print $FILE "\n", $indent;
         $count = 0;
      }
      ++$count;

      $outValue = $inValue;
      if ($radianceValues)
      {
         # Convert value from 'per-(cm-1)' to 'per-um' (i.e.: W/cm^2/sr/cm-1 -> W/cm^2/sr/um)
         $wavenumber = $gWavenumberList[$index];
         $outValue *= 1.0E-4 * $wavenumber * $wavenumber;
      }
      printf $FILE $format, $outValue;
      ++$index;
   }
   printf $FILE "\n";
}

# =============================================================================
sub PrintSpectralRange
{
   my $FILE = $_[0];
   print $FILE 1.0 * $gWavenumberList[0],
               ' ', $gWavenumberList[1] - $gWavenumberList[0],
               ' ', scalar(@gWavenumberList),
               "\n";
}

# =============================================================================
sub SaveSpectralValue
{
   my $line = $_[0];
   chomp($line);
   my ($wavenumber, $value) = split(" ", $line);
   push @gBlockWavenumbers, $wavenumber;
   push @gBlockValues, $value;
}
