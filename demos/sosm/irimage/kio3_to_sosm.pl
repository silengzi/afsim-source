# ****************************************************************************
# CUI//REL TO USA ONLY
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
#!/usr/bin/perl -w
# =============================================================================
# Convert IRIMAGE KIO3 files to SOSM target signature files.
# =============================================================================
#
# Note:
#
# The spectral value lists in KIO3 are stored in increasing wavelength and not
# increasing wavenumber. Thus, they must be reversed before writing to the
# output file!
# =============================================================================

use Getopt::Std;

# =============================================================================
# Global KIO3 Data
#
# NOTE: Any data defined in this block should be initialized in ResetGlobalData()!
# =============================================================================

$gOrigin   = 0;              # lowest wavenumber (cm-1)
$gBinCount = 0;              # number of bins
$gBinSize  = 0;              # the size of a bin (cm-1)
@gWavenumbers = ( );

$gAlt  = 0.0;
$gMach = 0.0;
$gAz   = 0.0;
$gEl   = 0.0;
$gAMO  = 0.0;
$gAMF  = 0.0;

@gAzList  = ( );
@gElList  = ( );
$gAzElKey = "";

# =============================================================================
# Data managed by CreateIntensityList and CreateWavenumberList to control the
# mapping of input bins to output bins.

# gBinMapIn and gBinMapOut form the mapping of input bins to output bins.
@gBinMapIn    = ( );
@gBinMapOut   = ( );

# gBinRefCount is index by output bin number and indicates how many input bins
# contribute to the output bin.
@gBinRefCount = ( );

# =============================================================================
# Configuration file information.
# =============================================================================

# The desired size for the output bins.
$gBinSizeOut = 20;

# The user-supplied identification lines.
$gIdentLine1 = "";
$gIdentLine2 = "";
$gIdentLine3 = "";

@gIgnoredPartNames = ( );              # Names of components to be ignored

# If the following is 1, the plume is considered to be opaque.
# The plume intensity will be the sum of 'splir' and 'bkgrdtpl' and the plume
# area will be the real plume area.
#
# If the following is 0, the plume is considered to be translucent.
# The plume intensity will contain only 'splir' and the the plume area will be
# set to zero.
#
# This is what has been been agreed upon by Don Walters and Joe Samocha as the
# proper way for things to operate.

$gOpaquePlume = 0;

# If the following value is 1, 'stlir' is used for the body intensity.
# If it is 0 then explicit components are used.

$gUse_stlir = 1;

# =============================================================================
# Command line options
# =============================================================================

%gOptions = ( );
$gConfigFile = "";
$gVerbose    = 0;

# =============================================================================

# Assign default values to the options and parse the options.

$Getopt::Std::STANDARD_HELP_VERSION = 1;      # see Perl documentation

$gOptions{"v"} = 0;
$gOptions{"c"} = "kio3_to_sosm.txt";

if (! getopts('h?vc:', \%gOptions))
{
    print "\n***** ERROR: Invalid arguments\n\n";
    HELP_MESSAGE(\*STDERR);
    exit 1;
}
if ($gOptions{"h"} || $gOptions{"?"})
{
    HELP_MESSAGE(\*STDERR);
    exit 0;
}
if (@ARGV == 0)
{
    print "\n***** ERROR: List of kio3 files not provided\n\n";
    HELP_MESSAGE(\*STDERR);
    exit 1;
}
$gVerbose = $gOptions{"v"};
$gConfigFile = $gOptions{"c"};

ReadConfigFile();

foreach $arg (@ARGV)
{
    foreach $argFileName (glob($arg))
    {
        ProcessFile($argFileName);
    }
}
exit 0;

# =============================================================================
sub ProcessFile
{
    my $baseName = $_[0];
    die "***** ERROR: File name not specified\n" if $baseName eq "";

    my $extIndex = rindex $baseName, '.';
    if ($extIndex > 0)
    {
        # Suffix supplied
        $baseName = substr($baseName, 0, $extIndex);
    }

    my $fileName = $baseName . '.kio3';
    open KIO3, "<$fileName" or die "Unable to open $fileName\n";

    print "\nProcessing file: " . $fileName . "\n";

    ResetGlobalData();

    # Body data
    my %bodyArea       = ( );
    my %bodyIntensity  = ( );

    # Plume data
    my %plumeArea      = ( );
    my %plumeIntensity = ( );

    while ($gLine = <KIO3>)
    {
        my @values = split(' ', $gLine);
        my $blockName = $values[0];
        
        if ($blockName eq '$NAMIR')
        {
            ReadNamelistBlock();
        }
        elsif ($blockName eq 'wv')
        {
            ReadWavelengthBlock();
        }
        elsif (InList(\@gIgnoredPartNames, $blockName))
        {
            SkipBlock();
        }
        elsif ($blockName eq 'splir')
        {
            # Plume intensity
            ReadIntensityBlock(\%plumeArea, \%plumeIntensity);
        }
        elsif ($blockName eq 'bkgrdtpl')
        {
            # 'background-through-plume'
            # See comments at top of file about this command...
            if ($gOpaquePlume)
            {
                ReadIntensityBlock(\%plumeArea, \%plumeIntensity);
            }
            else
            {
                SkipBlock();
            }
        }
        elsif ($gUse_stlir)
        {
            if ($blockName eq 'stlir')
            {
                ReadIntensityBlock(\%bodyArea, \%bodyIntensity);
            }
            else
            {
                SkipBlock();
            }
        }
        else
        {
            # If we get to this point the block represents either the thermal emission by the
            # body (a user defined part) or a reflections by the body from the environment
            # (sgrdir, ssolir or sskyir) AND we are NOT using 'stlir'.
            
            ReadIntensityBlock(\%bodyArea, \%bodyIntensity);
        }
    }

    # Ensure the azimuth/elevation values are in ascending order.
    @gAzList = sort { $a <=> $b } @gAzList;
    @gElList = sort { $a <=> $b } @gElList;
    
    # Verify that the provided azimuth/elevations form a rectangular table.
    # ... and fill any holes in the plume table.
    my @nullPlumeIntensityList = (0) x $gBinCount;
    my $az;
    my $el;
    foreach $az (@gAzList)
    {
        foreach $el (@gElList)
        {
            $azElKey = $az . ':' . $el;
            if (! exists($bodyArea{$azElKey}))
            {
                print "***** ERROR: Non-rectangular azimuth/elevation data in:\n";
                print "***** ERROR:   $fileName\n";
                print "***** ERROR: File ignored....\n";
                return;
            }
            if (! exists($plumeArea{$azElKey}))
            {
                $plumeArea{$azElKey} = 0.0;
                $plumeIntensity{$azElKey} = join(',', @nullPlumeIntensityList);
            }
        }
    }
    WriteFiles($baseName, 'bd', \%bodyArea,  \%bodyIntensity);
    WriteFiles($baseName, 'pl', \%plumeArea, \%plumeIntensity);
}

# =============================================================================
# Process and airframe or plume intensity block
sub ReadIntensityBlock
{
    my ($areaRef, $intensityRef) = @_;

    my $m_per_ft   = 0.3048;
    my $in_per_ft  = 12.0;
    my $m_per_in   = $m_per_ft / $in_per_ft;
    my $m2_per_in2 = $m_per_in * $m_per_in;

    my @values = split(' ', $gLine);
    my $name      = $values[0];
    my $itemCount = $values[1];
    my $area      = $values[2] * $m2_per_in2;              # convert from in^2 -> m^2

    # For ssolir, sskyir and sgrdir, the area is not used.
    # (It is total area, which should be the sum of the other airframe parts)
    #
    # For bkgrdtpl, the area is also not used. It is just a repeat of the plume area
    # and must not be added again.
    
    if (($name eq 'ssolir') ||
        ($name eq 'sskyir') ||
        ($name eq 'sgrdir') ||
        ($name eq 'bkgrdtpl'))
    {
       $area = 0;
    }

    # The plume area is forced to zero if the plume does NOT obscure the background.
    
    if (($name eq 'splir') &&
        (! $gOpaquePlume))
    {
        $area = 0;
    }

    if ($gVerbose)
    {
        print "    Processing intensity block $name\n";
    }

    @intensityList = ( );
    while ($gLine = <KIO3>)
    {
        chomp($gLine);
        @values = split(' ', $gLine);
        push @intensityList, @values;
        last if (@intensityList >= $itemCount);
    }

    # Reverse the values as incoming values are in order of increasing wavelength
    # and they need to be in order of increasing wavenumber.
    
    @intensityList = reverse(@intensityList);

    # Create the effective intensity list based on the desired bin size.

    CreateIntensityList(\@intensityList);
    

    # If contributors already exist for this az/el, simply add them to the input values.

    if (exists($$areaRef{$gAzElKey}))
    {
        if ($gVerbose)
        {
            print "      Contributions exist: adding new contributions\n";
        }
        my $currentArea      = $$areaRef{$gAzElKey};
        my @currentIntensity = split(',', $$intensityRef{$gAzElKey});
        for ($i = 0; $i < @intensityList; ++$i)
        {
            $intensityList[$i] += $currentIntensity[$i];
        }
        $area += $currentArea;
    }

    # Add/update the contributions.

    $$areaRef{$gAzElKey} = $area;
    $$intensityRef{$gAzElKey} = join(',', @intensityList);
}

# =============================================================================
# Process the $NAMIR namelist block. 
sub ReadNamelistBlock
{
    my $namelistStr = substr($gLine, 7);
    while ($gLine = <KIO3>)
    {
        last if ($gLine =~ /\$END/);
        chomp $gLine;
        $namelistStr = $namelistStr . $gLine;
    }
    $namelistStr =~ s/\s//g;

    # Create a hash of the variables

    my %nlHash = ( );
    my $name;
    my $value;
    my $strBeg = 0;
    my $strEnd;
    while ($strBeg < length($namelistStr))
    {
        # Find the '=' that terminates the variable name.
        $strEnd  = index($namelistStr, '=', $strBeg);
        last if ($strEnd < 0);
        $name = substr($namelistStr, $strBeg, $strEnd - $strBeg);
        $strBeg  = $strEnd + 1;                  # Skip over the '='

        # Find the ',' that terminates the variable value.
        $strEnd  = index($namelistStr, ',', $strBeg);
        if ($strEnd < 0)
        {
            $strEnd = length($namelistStr);
        }
        $value = substr($namelistStr, $strBeg, $strEnd - $strBeg);
        $strBeg = $strEnd + 1;                   # Skip over the ' '

        # Save the value
        $namelistHash{$name} = $value;
    }
    $gAlt  = $namelistHash{"ztar"};
    $gMach = $namelistHash{"xmach"};
    $gAz   = $namelistHash{"azi"};
    $gEl   = $namelistHash{"elev"};
    $gAMO  = $namelistHash{"amo"};
    $gAMF  = $namelistHash{"amf"};
    if ($gVerbose)
    {
        print "  ** Alt=$gAlt, Mach=$gMach, Az=$gAz, El=$gEl\n";
    }
    
    # Convert azimuth range from [0 .. 360] to [-180 .. 180]
    if ($gAz > 180.0)
    {
        $gAz = sprintf "%6.2f", $gAz - 360.0;
    }
    
    $gAzElKey = $gAz . ':' . $gEl;

    # Add values to respective lists

    AddToList(\@gAzList, $gAz);
    AddToList(\@gElList, $gEl);
}

# =============================================================================
# Process the 'wv' block
sub ReadWavelengthBlock
{
    # Read the size of the block (i.e.: the number of bins)
    chomp $gLine;
    my @values = split(' ', $gLine);
    my $binCount = $values[1];

    # Read the wavelengths (in 'um');
    my @wavelengths = ( );
    while ($gLine = <KIO3>)
    {
        chomp($gLine);
        @values = split(' ', $gLine);
        push @wavelengths, @values;
        last if (@wavelengths >= $binCount);
    }

    if (@wavelengths != $binCount)
    {
        print "***** ERROR: Wavenumber count mismatch, expected: $binCount",
        ", got ", scalar(@wavelengths), "\n";
        die;
    }

    # Convert from wavelength (um) to wavenumber(cm-1)
    # Note that the wavelengths are read in increasing order. We need to
    # reverse this so we get wavenumbers in increasing order.

    my $i;                             # Old perl doesn't like 'my' in 'for' loop context
    my @wavenumbers;
    my $wavelength;
    my $wavenumber;
    foreach $wavelength (reverse(@wavelengths))
    {
        $wavenumber = 10000.0 / $wavelength;

        # Note that the resulting wavenumber could be slightly over or under
        # an integral wavenumber due to the fact that the input wavelength
        # is not precise.

        $wavenumber = int ($wavenumber + 0.5);
        # print "$wavelength -> $wavenumber\n";
        push @wavenumbers, $wavenumber;
    }

    # Make sure the wavenumbers are good.
    
    if (@wavenumbers < 2)
    {
        print "***** ERROR: Must have at least two wavelengths\n";
        die;
    }
    my $binSize = $wavenumbers[1] - $wavenumbers[0];
    if ($binSize <= 0)
    {
        print "***** ERROR: Invalid bin size: $binSize\n";
        die;
    }
    for ($i = 2; $i < @wavenumbers; ++$i)
    {
        my $gotBinSize = $wavenumbers[$i] - $wavenumbers[$i-1];
        if ($gotBinSize != $binSize)
        {
            print "***** ERROR: Inconsistent wavenumber spacing\n";
            print " expected: $binSize, got $gotBinSize\n";
            print " Actual wavenumbers: $wavenumbers[$i-1] $wavenumbers[$i]\n";
            print " Actual wavelengths: ", 10000.0 / $wavenumbers[$i], " ",
                                           10000.0 / $wavenumbers[$i-1], "\n";
            die;
        }
    }

    # Create the effective wavenumber list based on the desired bin size.
    
    CreateWavenumberList(\@wavenumbers);
    
    # If this is the first call, save the wavenumbers in the global list.
    # For second and subsequent calls, simply ensure the values read are
    # consistent with the first values that were read.

    if ($gOrigin == 0)
    {
        # first call
        @gWavenumbers = @wavenumbers;
        $gOrigin      = $wavenumbers[0];
        $gBinSize     = $wavenumbers[1] - $wavenumbers[0];
        $gBinCount    = @wavenumbers;
        if ($gVerbose)
        {
            print "** Origin=$gOrigin, Bin Size=$gBinSize, Bin Count=$gBinCount\n";
        }
    }
    elsif (@wavenumbers != $gBinCount)
    {
        print "***** ERROR Inconsistent bin counts, expected ", $gBinCount,
        ", got ", scalar(@wavenumbers), "\n";
    }
    else
    {
        # second or subsequent calls
        for ($i = 0; $i < @wavenumbers; ++$i)
        {
            if ($wavenumbers[$i] != $gWavenumbers[$i])
            {
                print "***** ERROR: Inconsistent wavenumber lists\n";
                print "$i $wavenumbers[$i] $gWavenumbers[$i]\n";
                die;
            }
        }
    }
}

# =============================================================================
# Reset global KIO3 Data
sub ResetGlobalData()
{
    $gOrigin   = 0;              # lowest wavenumber (cm-1)
    $gBinCount = 0;              # number of bins
    $gBinSize  = 0;              # the size of a bin (cm-1)
    @gWavenumbers = ( );

    $gAlt  = 0.0;
    $gMach = 0.0;
    $gAz   = 0.0;
    $gEl   = 0.0;
    $gAMO  = 0.0;
    $gAMF  = 0.0;

    @gAzList  = ( );
    @gElList  = ( );
    $gAzElKey = "";
}

# =============================================================================
sub SkipBlock
{
    my @values = split(' ', $gLine);
    my $name      = $values[0];
    my $itemCount = $values[1];
    my $area      = $values[2];
    @itemList = ( );
    while ($gLine = <KIO3>)
    {
        chomp($gLine);
        @values = split(' ', $gLine);
        push @itemList, @values;
        last if (@itemList >= $itemCount);
    }
}

# =============================================================================
sub PrintArray
{
   my ($FILE, $format, $indent, $arrayRef) = @_;
   my $count  = 0;
   my $value;
   foreach $value (@$arrayRef)
   {
      if ($count == 6)
      {
         print $FILE "\n", $indent;
         $count = 0;
      }
      ++$count;
      printf $FILE $format, $value;
   }
   printf $FILE "\n";
}

#==============================================================================
sub WriteFiles
{
    my ($baseName, $component, $areaRef, $intensityRef) = @_;

    # Exit immediately if no data for this component.
    return if (scalar(keys %$areaRef) < 1);

    my $az;
    my $el;
    my $azElKey;
    my @list;
    my $identLine1 = $gIdentLine1;
    if ($identLine1 eq "")
    {
        $identLine1 = $baseName;
    }
    my $identLine2 = $gIdentLine2;
    if ($identLine2 eq "")
    {
        $identLine2 = "Mach: " . $gMach * 1.0
            . ', Altitude: ' . $gAlt * 1.0 . ' ft.'
            . ', Wavelength: ' . $gAMO . ' to ' . $gAMF . ' um';
    }
    my $identLine3 = $gIdentLine3;

    # Write the projected area file

    my $ofile = $baseName . '.' . $component . 'a';
    open OFILE, ">$ofile" or die "***** ERROR: Could not open $ofile for writing";
    print "  Writing $ofile\n";
    print OFILE  $identLine1, "\n";
    print OFILE  $identLine2, "\n";
    print OFILE  $identLine3, "\n";
    print OFILE  scalar(@gAzList), ' ', scalar(@gElList), "\n";
    print OFILE '        ';
    PrintArray(\*OFILE, " %12g", '        ', \@gElList);
    foreach $az (@gAzList)
    {
        @list = ( );
        foreach $el (@gElList)
        {
            $azElKey = $az . ':' . $el;
            push @list, $$areaRef{$azElKey};
        }
        printf OFILE "%8g", $az * 1.0;
        PrintArray(\*OFILE, " %12g", '        ', \@list);
    }
    close OFILE;

    # Write the intensity file

    $ofile = $baseName . '.' . $component . 'i';
    open OFILE, ">$ofile" or die "***** ERROR: Could not open $ofile for writing";
    print "  Writing $ofile\n";
    print OFILE  $identLine1, "\n";
    print OFILE  $identLine2, "\n";
    print OFILE  $identLine3, "\n";
    print OFILE  $gOrigin, ' ', $gBinSize, ' ', $gBinCount, "\n";
    print OFILE  scalar(@gAzList), ' ', scalar(@gElList), "\n";
    foreach $az (@gAzList)
    {
        foreach $el (@gElList)
        {
            print OFILE $az * 1.0, ' ', $el * 1.0, "\n";
            $azElKey = $az . ':' . $el;
            @list = split(',', $$intensityRef{$azElKey});
            PrintArray(\*OFILE, " %12g", '', \@list);
        }
    }
    close OFILE;
}

#==============================================================================
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

#==============================================================================
# InList(\@list, $value)
# Returns 1 if in the list, 0 if not
sub InList
{
    my ($listRef, $value) = @_;

    foreach $listValue (@$listRef)
    {
        return 1 if ($value eq $listValue);
    }
    return 0;
}

# =============================================================================
sub ReadConfigFile
{
    if ($gConfigFile eq "")
    {
        return;
    }
    open(CONFIG, "<$gConfigFile") or die "***** ERROR: Unable to open $gConfigFile";

    # Read three 'identification cards'. These are simply copied to the output files
    # so the user can identify the source of the files.

    $gIdentLine1 = <CONFIG>;
    chomp($gIdentLine1);
    $gIdentLine2 = <CONFIG>;
    chomp($gIdentLine2);
    $gIdentLine3 = <CONFIG>;
    chomp($gIdentLine3);

    my $line;
    while ($line = <CONFIG>)
    {
        chomp($line);
        next if ($line =~ /^ *#/);     # Skip comments
        next if ($line =~ /^ *$/);     # Skip blank lines
        if ($line =~ /^\s*opaque_plume/)
        {
            $gOpaquePlume = 1;
        }
        elsif ($line =~ /^\s*ignore_part/)
        {
            my @values = split(' ', $line);
            print "***** INFO: Part $values[1] will be ignored\n";
            AddToList(\@gIgnoredPartNames, $values[1]);
        }
        else
        {
            die "***** ERROR: Unknown line: $line\n";
        }
    }

    # 'bkgrdrad' is ALWAYS ignored.
    
    AddToList(\@gIgnoredPartNames, 'bkgrdrad');
    
    # If 'stlir' is in the ignored part list then the old style of computations are performed;
    # i.e.: the user-selected components are summed to produce the total body intensity.
    #
    # If 'stlir' is NOT in the list then only it is used to produce the total body intensity.
    
    if (InList(\@gIgnoredPartNames, 'stlir'))
    {
        $gUse_stlir = 0;
    }
}

# =============================================================================
# Display help message (also called implicitly with --help option)
sub HELP_MESSAGE
{
    my $OUTFH = shift;

    print $OUTFH "Usage: kio3_to_sosm.pl -v -c <config> file1 [... filen]\n";
    print $OUTFH "\n";
    print $OUTFH "  -c <config>         The configuration file (default: kio3_to_sosm.txt)\n";
    print $OUTFH "  -v                  Verbose output.\n";
    print $OUTFH "  file1 [...filen]    The list of KIO3 files to be processed.\n";
    print $OUTFH "\n";
}

# =============================================================================
# This method takes an input intensity list and creates a new intensity list that
# is of the desired bin size. It uses the mapping generated by CreateWavenumberList
# to determine which input bins contribute to which output bins.
#
# NOTE: This method computes the unweighted average of the contributing bins. No
# attempt is made to the fraction of the bin that contributes.

sub CreateIntensityList
{
    my ($intensitiesRef) = @_;
    
    my @intensitiesOut = (0) x $gBinCount;                 # Initialize
    
    # In each output bin, sum the intensities of the contributing input bins.
    
    my $i;                             # Old perl doesn't like 'my' in 'for' loop context
    my $indexIn;
    my $indexOut;
    my $binMapSize  = @gBinMapIn;
    for ($i = 0; $i < $binMapSize; ++$i)
    {
       $indexIn  = $gBinMapIn[$i];
       $indexOut = $gBinMapOut[$i];
       $intensitiesOut[$indexOut] += $$intensitiesRef[$indexIn];
    }
    
    # Divide the sum in each output intensity by its reference count to get the average.
    
    for ($i = 0; $i < $gBinCount; ++$i)
    {
       $intensitiesOut[$i] /= $gBinRefCount[$i];
    }
    
    @$intensitiesRef = @intensitiesOut;
}

# =============================================================================
# This method takes a wavenumber list and creates a new wavenumber list that is of
# the desired bin size. It also creates a mapping used by CreateIntensityList so it
# combine (if necessary) smaller bins into larger bins.

sub CreateWavenumberList
{
    my ($wavenumbersRef) = @_;
   
    my $i;                             # Old perl doesn't like 'my' in 'for' loop context
    my $j;                             # Old perl doesn't like 'my' in 'for' loop context
    my $binSizeOut = $gBinSizeOut;
   
    # Get the bin configuration of the input.
    
    my $originIn   = $$wavenumbersRef[0];
    my $binCountIn = @$wavenumbersRef;
    my $binSizeIn  = $$wavenumbersRef[1] - $$wavenumbersRef[0];

    # Find the wavenumbers of the lower and upper output bins
   
    my $loWavenumberIn = $$wavenumbersRef[0];
    my $hiWavenumberIn = $$wavenumbersRef[$binCountIn - 1];
    my ($loWavenumberOut, $temp1) = DetermineOutputBins($loWavenumberIn, $binSizeIn, $binSizeOut);
    my ($temp2, $hiWavenumberOut) = DetermineOutputBins($hiWavenumberIn, $binSizeIn, $binSizeOut);
    
    # Determine the bin configuration of the output
    
    $originOut   = $loWavenumberOut;
    $binCountOut = (($hiWavenumberOut - $loWavenumberOut) / $binSizeOut) + 1;
    
    # Create the intput-bin-to-output-bin map and bin reference count
    
    @gBinRefCount = (0) x $binCountOut;                    # Initialize
    @gBinMapIn    = ( );
    @gBinMapOut   = ( );
    for ($i = 0; $i < $binCountIn; ++$i)
    {
       my $wavenumber = $$wavenumbersRef[$i];
       ($loWavenumberOut, $hiWavenumberOut) = DetermineOutputBins($wavenumber, $binSizeIn, $binSizeOut);
       my $loIndexOut = ($loWavenumberOut - $originOut) / $binSizeOut;
       my $hiIndexOut = ($hiWavenumberOut - $originOut) / $binSizeOut;
       for ($j = $loIndexOut; $j <= $hiIndexOut; ++$j)
       {
           push @gBinMapIn, $i;
           push @gBinMapOut, $j;
           ++$gBinRefCount[$j];
       }
    }
    
    # Create the output wavenumber array.

    @$wavenumbersRef = ( );
    for ($i = 0; $i < $binCountOut; ++$i)
    {
       push @$wavenumbersRef, $originOut + $i * $binSizeOut;
    }
}

# =============================================================================
# For a given input bin determine which output bins are referenced.
sub DetermineOutputBins
{
    my ($midIn, $binSizeIn, $binSizeOut) = @_;

    # Assume bins are the same size.
    my $loOut = $midIn;
    my $hiOut = $midIn;
    if ($binSizeIn != $binSizeOut)
    {
        my $loIn = $midIn - $binSizeIn / 2;
        my $hiIn = $midIn + $binSizeIn / 2;
        $loOut = int(($loIn + $binSizeOut / 2) / $binSizeOut) * $binSizeOut;
        $hiOut = int(($hiIn + $binSizeOut / 2) / $binSizeOut) * $binSizeOut;
    }
    
    return ($loOut, $hiOut);
}
