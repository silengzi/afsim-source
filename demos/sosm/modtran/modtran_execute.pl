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
# Execute MODTRAN to generate the files necessary to create the atmopheric
# tables needed for the 'Spectral Optical Detection Model' (SOSM).
#
# =============================================================================
#
# NOTE:
#
# This script was originally set up to create 4 MODTRAN input files.
# Each of the input files utilized the 'repeat execution' flag on CARD 5
# to run all the altitude, elevation elevations and ranges in one pass.
# Unfortunately there are cases where MODTRAN gets confused and loses
# track of where it is at and stops in the middle of the file.
#
# Therefore, the script now creates one file per run and calls MODTRAN
# internally to execute the file.
#
# =============================================================================

# The following variables, if set to 1, will cause the temporary tp5/tp6 files
# to be appended to the $gConfigBase . '_xx'.tp5/6. This is useful for debugging.

$gSave_tp5 = 0;
$gSave_tp6 = 0;

$gConfigBase = "";

# User-defined identification lines
$gIdentLine1 = "";
$gIdentLine2 = "";
$gIdentLine3 = "";

# Altitude samples (meters)
@gAltitudeList = ( );

# Elevation elevation sample (meters)
@gElevationList = ( );

# NOTE MODTRAN does not like a range of 0 M
# Range samples (meters) (NOTE: MODTRAN does not like 
@gRangeList = ( );

# The MODTRAN input lines.
@gCard12_Lines = ( );
@gCard3_Lines  = ( );
@gCard4_Lines  = ( );

$gPI = 4.0 * atan2(1.0, 1.0);

# =============================================================================

ReadInput();

die "***** ERROR: 'altitude_list' block not provided\n"  if @gAltitudeList == 0;
die "***** ERROR: 'elevation_list' block not provided\n" if @gElevationList == 0;
die "***** ERROR: 'range_list' block not provided\n"     if @gRangeList == 0;

print "***** Starting " . localtime() . "\n";

# Sort the altitude, elevation and range lists in ascending order.

@gAltitudeList  = sort { $a <=> $b } @gAltitudeList;
@gElevationList = sort { $a <=> $b } @gElevationList;
@gRangeList     = sort { $a <=> $b } @gRangeList;

# Remove any existing versions of the files produced by this script.

foreach $table_type ("_bgt", "_bgr", "_fgt", "_fgr")
{
   Delete_MODTRAN_Files($gConfigBase . $table_type);
}

# Write the headers in the primary output files.

WriteConfiguration($gConfigBase . '_bgt.plt');
WriteConfiguration($gConfigBase . '_bgr.plt');
WriteConfiguration($gConfigBase . '_fgt.plt');
WriteConfiguration($gConfigBase . '_fgr.plt');

# =============================================================================
# Generate the files that have only a dependence on altitude and elevation elevation
#
#      -) Background transmittance
#      -) Background radiance

foreach $altitude (@gAltitudeList)
{
   print "Altitude=",$altitude,"\n";
   foreach $elevation (@gElevationList)
   {
      print "  Altitude=",$altitude," elevation=",$elevation,
            " (" . $gConfigBase . ", " . localtime(),")\n";

      Delete_MODTRAN_Files('temp_bgt');
      Delete_MODTRAN_Files('temp_bgr');
      
      # Background transmittance
      $tp5_file = 'temp_bgt.tp5';
      open BTFILE, ">$tp5_file" or die "***** ERROR Unable to create $tp5_file\n";

      # Background radiance
      $tp5_file = 'temp_bgr.tp5';
      open BRFILE, ">$tp5_file" or die "***** ERROR Unable to create $tp5_file\n";
      
      # Process the CARD 1 and CARD 2 lines
      
      $firstLine = 1;
      foreach $tempLine (@gCard12_Lines)
      {
         $line = $tempLine;            # Create a copy to avoid modifying original
         if ($firstLine)
         {
            $firstLine = 0;
            # Force ITYPE=3, Vertical or slant path to space or ground
            substr($line,  5, 5) = "    3";
            # Must print radiance line first as is uses the value from the input file.
            print BRFILE "$line\n";
            substr($line, 10, 5) = "    0";   # IEMSCT = 0; Transmittance
            substr($line, 15, 5) = "    0";   # IMULT  = 0
            print BTFILE "$line\n";
         }
         else
         {
            print BTFILE "$line\n";
            print BRFILE "$line\n";
         }
      }
      
      # Process the CARD 3 lines
      
      $firstLine = 1;
      foreach $tempLine (@gCard3_Lines)
      {
         $line = $tempLine;            # Create a copy to avoid modifying original
         if ($firstLine)
         {
            $firstLine = 0;
            # Process the geometry line (CARD 3)
            
            $H1 = $altitude * 0.001;         # Observer altitude in KM
            
            # Convert elevation from +/- elevation to MODTRAN elevation-from-zenith.
            $ANGLE = 90.0 - $elevation;
            
            printf BTFILE "%10.3f          %10.3f\n", $H1, $ANGLE;
            printf BRFILE "%10.3f          %10.3f\n", $H1, $ANGLE;
         }
         else
         {
            # The subsequent 3Ax, 3Bx and 3Cx lines only apply when running in radiance mode.
            #print BTFILE "$line\n";
            print BRFILE "$line\n";
         }
      }
      
      # Process the CARD 4 lines
      
      $firstLine = 1;
      foreach $tempLine (@gCard4_Lines)
      {
         $line = $tempLine;            # Create a copy to avoid modifying original
         if ($firstLine)
         {
            $firstLine = 0;
            substr($line, 42, 8) = 'ENDBLOCK';             # Set DLIMIT for reformatter
            substr($line, 40, 1) = "T";
            print BTFILE "$line\n";
            substr($line, 40, 1) = "R";
            print BRFILE "$line\n";
         }
         else
         {
            print BTFILE "$line\n";
            print BRFILE "$line\n";
         }
      }
      
      # CARD 5 line - no repeat run.
      
      $line = "    0";
      print BTFILE "$line\n";
      print BRFILE "$line\n";

      # Execute MODTRAN
      
      close BTFILE;
      close BRFILE;
      $caseLine = $altitude . ' ' . $elevation;
      Execute_MODTRAN('temp_bgt', $gConfigBase . '_bgt', $caseLine);
      Execute_MODTRAN('temp_bgr', $gConfigBase . '_bgr', $caseLine);
   }
}
Delete_MODTRAN_Files('temp_bgt');
Delete_MODTRAN_Files('temp_bgr');

# =============================================================================
# Generate the files that have a dependence on altitude, elevation elevation and
# range:
#
#      -) Foreground transmittance
#      -) Foreground radiance
#
# There is a lot of nonsense here because MODTRAN isn't very robust. We must generate
# the input in memory and then copy it to the files because there are cases where we
# have to go back and change a previous line (Look at CARD 3 processing)

# Earth Radius by Atmosphere
@RO_TABLE = ( 6371.23, 6378.39, 6371.23, 6371.23, 6356.91, 6356.91, 6371.23, 6371.23 );
$MODEL = 6;
foreach $altitude (@gAltitudeList)
{
   print "Altitude=",$altitude,"\n";
   foreach $elevation (@gElevationList)
   {
      print "  Altitude=",$altitude," elevation=",$elevation,"\n";
      $hitBoundary = 0;
      RANGE: foreach $range (@gRangeList)
      {
         $caseLine = $altitude . ' ' . $elevation . ' ' . $range;
         
         # Once the boundary (space or ground) has been encountered, there is no need to
         # continue execute MODTRAN for this altitude/elevation (all subsequent ranges
         # are larger and would also hit the boundary). We simply insert a tag in the
         # output file to indicate to modtran_convert.pl to copy the data from where the
         # boundary was first encountered.
         
         if ($hitBoundary)
         {
            AppendString('BOUNDARY', $gConfigBase . '_fgt.plt', "%{ " . $caseLine, "%}");
            AppendString('BOUNDARY', $gConfigBase . '_fgr.plt', "%{ " . $caseLine, "%}");
            next RANGE;
         }

         print "    Altitude=",$altitude," elevation=",$elevation," range=",$range,
               " (" . $gConfigBase . ", " . localtime(),")\n";
         
         Delete_MODTRAN_Files('temp_fgt');
         Delete_MODTRAN_Files('temp_fgr');

         # Atmospheric transmittance
         $tp5_file = 'temp_fgt.tp5';
         open FTFILE, ">$tp5_file" or die "***** ERROR Unable to create $tp5_file\n";

         # Foreground radiance
         $tp5_file = 'temp_fgr.tp5';
         open FRFILE, ">$tp5_file" or die "***** ERROR Unable to create $tp5_file\n";
         
         # Process the CARD 1 and CARD 2 lines

         @radModeLines = ( );
         @traModeLines = ( );
         
         $firstLine = 1;
         foreach $tempLine (@gCard12_Lines)
         {
            $line = $tempLine;            # Create a copy to avoid modifying original
            if ($firstLine)
            {
               $firstLine = 0;
               # Determine Earth Radius for CARD 3 adjustments
               $MODEL = substr($line, 2, 3);
               $MODEL =~ s/ //g;
               if ($MODEL eq "")
               {
                  $MODEL = 6;
               }
               if ($MODEL > 7)
               {
                  $MODEL = 6;
               }
               
               # Force ITYPE=2, Slant path between two altitudes
               substr($line,  5, 5) = "    2";
               # Must print radiance line first as is uses the value from the input file.
               push @radModeLines, $line;
               substr($line, 10, 5) = "    0";   # IEMSCT = 0; Transmittance
               substr($line, 15, 5) = "    0";   # IMULT  = 0
               push @traModeLines, $line;
            }
            else
            {
               push @traModeLines, $line;
               push @radModeLines, $line;
            }
         }
      
         # Process the CARD 3 lines
      
         $firstLine = 1;
         foreach $tempLine (@gCard3_Lines)
         {
            $line = $tempLine;            # Create a copy to avoid modifying original
            if ($firstLine)
            {
               $firstLine = 0;
               # Process the geometry line (CARD 3)
               
               # Capture the Earth radius for possible use later. Use either the supplied radius
               # or the model-specific default if not provided.
               
               $RO = substr($line, 50, 10);
               $RO =~ s/ //g;
               $RE = 0.0;
               if ($RO ne "")
               {
                  $RE = 1.0 * $RO;  # Checks for a good number
               }
               if ($RE <= 0.0)
               {
                  $RE = $RO_TABLE[$MODEL];
               }
               
               $H1 = $altitude * 0.001;          # Observer altitude in KM
               if ($H1 < 0.001)
               {
                  $H1 = 0.001;
               }
               $H2 = 0.0;
               
               # Convert elevation from +/- elevation to MODTRAN elevation-from-zenith.
               $ANGLE = 90.0 - $elevation;
               $RANGE = $range * 0.001;          # Path length in KM

               # MODTRAN has several problems with the ITYPE = 2:
               #
               # 1) If the range is <2KM it goes int a short path mode and converts 'Case 2b'
               #    to 'Case 2c'. Unfortunately it generates a bad call to acos/asin if the
               #    path is vertical or near vertical. Furthermore, the problem gets worse as
               #    the observer altitude increases.
               #
               # 2) 'Case 2b' didn't work well if the path intercepted the earth or went out the
               #    the top of the atmosphere. In other cases we switched back to ITYPE=3
               #    (slant path to space or ground).


               # For a pure vertical case we will change it to case 2a (H1, H2, angle)               

               if ($ANGLE < 0.001)
               {
                  # Straight up
                  $ANGLE = 0.0;
                  $H2    = $H1 + $RANGE;
                  $RANGE = 0.0;        # Forces case 2a
                  if ($H2  < 100.0)
                  {
                     $line = sprintf "%10.3f%10.3f%10.3f%10.3f", $H1, $H2, $ANGLE, $RANGE;
                  }
                  else
                  {
                     # Target is in 'space' - change to ITYPE=3 (slant path to space or ground)
                     substr($traModeLines[0],  5, 5) = "    3";
                     substr($radModeLines[0],  5, 5) = "    3";
                     $line = sprintf "%10.3f          %10.3f", $H1, $ANGLE;
                     $hitBoundary = 1;
                     print "     ***** Space boundary encountered\n";
                  }
                  push @traModeLines, $line;
                  push @radModeLines, $line;
               }
               elsif ($ANGLE > 179.999)
               {
                  # Straight down
                  $ANGLE = 180.0;
                  $H2    = $H1 - $RANGE;
                  $RANGE = 0.0;        # Forces case 2a
                  if ($H2 > 0.0)
                  {
                     $line = sprintf "%10.3f%10.3f%10.3f%10.3f", $H1, $H2, $ANGLE, $RANGE;
                  }
                  else
                  {
                     # Target is below ground - change to ITYPE=3 (slant path to space or ground)
                     substr($traModeLines[0],  5, 5) = "    3";
                     substr($radModeLines[0],  5, 5) = "    3";
                     $line = sprintf "%10.3f          %10.3f", $H1, $ANGLE;
                     $hitBoundary = 1;
                     print "      ***** Ground boundary encountered\n";
                  }
               
                  push @traModeLines, $line;
                  push @radModeLines, $line;
               }
               else
               {
                  # For this observer altitude, compute the slant range to the horizon point.
                  
                  $Robs = $RE + $H1;
                  $Rmax = sqrt(($Robs * $Robs) - ($RE * $RE));
                  # beta is the subtended angle on the Earth, in radians
                  $beta  = atan2($Rmax, $RE);
                  # Angle of horizon from zenith, in degrees
                  $horizonAngle = 90.0 + (180.0 * $beta / $gPI);
                  
                  # Determine the boundary that may be encountered. This may be either:
                  #
                  # 1) The surface of the Earth.
                  # 2) The 'top of atmosphere'.
                  #
                  # If either of these boundaries are crossed, MODTRAN *MAY* have problems.
                  
                  $Rbnd = $RE;                   # assume boundary is the surface of the Earth
                  if ($ANGLE <= $horizonAngle)
                  {
                     $Rbnd = $RE + 100.0;        # boundary is top of atmosphere (100 km)
                  }
                  
                  # For the desired angle, compute the range to where it intersects the boundary.
                  # Using law of cosines and quadratic formula:
                  #
                  #   Rbnd^2 = Robs^2 + Rmax^2 - 2 * Robs * Rmax * cos(theta)
                  #
                  # where: Robs  = radius to observer = RE + H1
                  #        Rbnd  = radius to boundary = RE or RE + 100 km (set above)
                  #        Rmax  = slant range to boundary (what we are solving for)
                  #        theta = 180 - angle from zenith.
                  #
                  # Put into quadratic form to solve for Rmax:
                  #
                  #   Rmax^2 - 2 * R1 * Rmax * cos(theta) + R1^2 - RB^2 = 0
                  #
                  # Therefore:
                  #
                  #   A = 1
                  #   B = - 2 * Robs * cos(theta)
                  #   C = Robs^2 - Rbnd^2
                  #
                  # And: Rmax = (-B +/- sqrt(B^2 - 4AC)) / 2A
                  
                  $theta    = 180.0 - $ANGLE;
                  $cosTheta = cos($theta * $gPI / 180.0);
                  $A = 1.0;
                  $B = -2.0 * $Robs * $cosTheta;
                  $C = ($Robs * $Robs) - ($Rbnd * $Rbnd);
                  $temp = ($B * $B) - (4.0 * $A * $C);
                  if ($temp < 0.0)
                  {
                     $temp = 0.0;
                  }
                  $temp = sqrt($temp);
                  
                  # There are two solutions - we need to take the smallest POSITIVE value
                  
                  $root1 = (-$B - $temp) / (2.0 * $A);
                  $root2 = (-$B + $temp) / (2.0 * $A);
                  if ($root1 <= 0.0)
                  {
                      $MAX_RANGE = $root2;       # root1 is negative, use root2
                  }
                  elsif ($root2 <= 0.0)
                  {
                      $MAX_RANGE = $root1;       # root2 is negative, use root1
                  }
                  elsif ($root1 <= $root2)
                  {
                      $MAX_RANGE = $root1;       # Both are positive, root1 <= root2, use root1
                  }
                  else
                  {
                      $MAX_RANGE = $root2;       # Both are positive, root2 < root1, use root2
                  }
                  if ($MAX_RANGE < 0.0)
                  {
                      die "***** ERROR: Cannot determine maximum range!!!";
                  }
                                    
                  # Subtract off a few meters to allow for slight numerical issues,
                  # and the fact we don't consider refraction.
                  $MAX_RANGE -= 0.002;
                  if ($MAX_RANGE < 0.001)
                  {
                     $MAX_RANGE = 0.001;
                  }
                  
                  # If the desired range is greater than the maximum allowable, change to ITYPE=3
                  
                  if ($RANGE > $MAX_RANGE)
                  {
                     substr($traModeLines[0],  5, 5) = "    3";
                     substr($radModeLines[0],  5, 5) = "    3";
                     $line = sprintf "%10.3f          %10.3f", $H1, $ANGLE;
                     push @traModeLines, $line;
                     push @radModeLines, $line;
                     print "      ****** Space/Ground boundary encountered (Rmax=", int($MAX_RANGE * 1000.0), ")\n";
                     $hitBoundary = 1;
                  }
                  else
                  {
               
                     $line = sprintf "%10.3f%10.3f%10.3f%10.3f", $H1, $H2, $ANGLE, $RANGE;
                     push @traModeLines, $line;
                     push @radModeLines, $line;
                  }
               }
            }
            else
            {
               # The subsequent 3Ax, 3Bx and 3Cx lines only apply when running in radiance mode.
               #push @traModeLines, $line;
               push @radModeLines, $line;
            }
         }
      
         # Process the CARD 4 lines
      
         $firstLine = 1;
         foreach $tempLine (@gCard4_Lines)
         {
            $line = $tempLine;            # Create a copy to avoid modifying original
            if ($firstLine)
            {
               $firstLine = 0;
               substr($line, 42, 8) = 'ENDBLOCK';          # Set DLIMIT for reformatter
               substr($line, 40, 1) = "T";
               push @traModeLines, $line;
               substr($line, 40, 1) = "R";
               push @radModeLines, $line;
            }
            else
            {
               push @traModeLines, $line;
               push @radModeLines, $line;
            }
         }
         
         # Dump the formatted lines for CARD's 1-4 to the input files.
         foreach $line (@traModeLines)
         {
             print FTFILE "$line\n";
         }
         foreach $line (@radModeLines)
         {
             print FRFILE "$line\n";
         }
         
         # CARD 5 line - no repeat run.
         
         $line = "    0";
         print FTFILE "$line\n";
         print FRFILE "$line\n";

         # Execute MODTRAN
      
         close FTFILE;
         close FRFILE;
         Execute_MODTRAN('temp_fgt', $gConfigBase . '_fgt', $caseLine);
         Execute_MODTRAN('temp_fgr', $gConfigBase . '_fgr', $caseLine);
      }
   }
}
Delete_MODTRAN_Files('temp_fgt');
Delete_MODTRAN_Files('temp_fgr');

print "***** Finished " . localtime() . "\n";

# =============================================================================
sub AppendString
{
   my $string     = shift;
   my $targetName = shift;
   my $prefixLine = shift;
   my $suffixLine = shift;

   open(TARGET, ">>$targetName") or die "AppendFile: Unable to open output file $targetName";
   
   if ($prefixLine ne "")
   {
      print TARGET $prefixLine, "\n";
   }
   
   print TARGET $string, "\n";
   
   if ($suffixLine ne "")
   {
      print TARGET $suffixLine, "\n";
   }
   
   close TARGET;
}

# =============================================================================
sub AppendFile
{
   my $sourceName = shift;
   my $targetName = shift;
   my $prefixLine = shift;
   my $suffixLine = shift;

   open(TARGET, ">>$targetName") or die "AppendFile: Unable to open output file $targetName";
   
   my $lineCount = 0;
   if ($prefixLine ne "")
   {
      print TARGET $prefixLine, "\n";
   }
   
   if (open(SOURCE, "<$sourceName"))
   {
      my $line;
      while ($line = <SOURCE>)
      {
         ++$lineCount;
         print TARGET $line;
      }
      close SOURCE;
   }
   
   if ($suffixLine ne "")
   {
      print TARGET $suffixLine, "\n";
   }
   
   close TARGET;
   return $lineCount;
}

# =============================================================================
sub Delete_MODTRAN_Files
{
   my $caseName = shift;
   my $suffix;
   
   foreach $suffix ( '.7sc', '.7sr', '.plt', '.tp5', '.tp6', '.tp7', '.tp8')
   {
      unlink($caseName . $suffix);
   }
}

# =============================================================================
sub Execute_MODTRAN
{
   my $inputBase  = shift;
   my $outputBase = shift;
   my $caseLine   = shift;

   system("modtran.bat $inputBase");
   my $failed = 0;
   if ($? != 0)
   {
       $failed = 1;
       if ($? == -1)
       {
           print "***** ERROR: MODTRAN failed to execute $!\n";
       }
       elsif ($? & 127)
       {
           printf "***** ERROR: MODTRAN Died with signal %d\n", ($? & 127);
       }
       else
       {
           printf "***** ERROR: MODTRAN Exited with status %d\n", $? >> 8;
       }
   }
   my $lineCount = AppendFile($inputBase . '.plt', $outputBase . '.plt', "%{ " . $caseLine, "%}");
   if ($lineCount <= 0)
   {
       print "***** WARNING: No output from MODTRAN ($outputBase).\n";
       $failed = 1;
   }
   if ($gSave_tp5 || $failed)
   {
      AppendFile($inputBase . '.tp5', $outputBase . '.tp5', "%{ " . $caseLine, "%}");
   }
   if ($gSave_tp6 || $failed)
   {
      AppendFile($inputBase . '.tp6', $outputBase . '.tp6', "%{ " . $caseLine, "%}");
   }
}   

# =============================================================================
sub WriteConfiguration
{
   my $fileName = shift;
   open OFILE, ">$fileName" or die "***** ERROR: Unable to open $fileName";

   # Include the three user-supplied identification lines from the configuration file.
   print OFILE $gIdentLine1;
   print OFILE $gIdentLine2;
   print OFILE $gIdentLine3;
   close OFILE;
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
   
   $gIdentLine1 = <CONFIG>;
   $gIdentLine2 = <CONFIG>;
   $gIdentLine3 = <CONFIG>;
   
   my $cardGroup = 0;
   my $line;
   while ($line = <CONFIG>)
   {
      chomp($line);
      next if ($line =~ /^ *#/);     # Skip comments
      next if ($line =~ /^ *$/);     # Skip blank lines
      if ($line =~ /^\s*altitude_list/)
      {
         @gAltitudeList = ReadListBlock(\*CONFIG, "end_altitude_list");
      }
      elsif ($line =~ /^\s*elevation_list/)
      {
         @gElevationList = ReadListBlock(\*CONFIG, "end_elevation_list");
      }
      elsif ($line =~ /^\s*range_list/)
      {
         @gRangeList = ReadListBlock(\*CONFIG, "end_range_list");
      }
      elsif ($line =~ /^\s*debug/)
      {
         $gSave_tp5 = 1;
         $gSave_tp6 = 1;
      }
      elsif ($line =~ /^%CARD /)
      {
         if ($line =~ /^%CARD *[1-4]/)
         {
            $line =~ s/\s+/ /g;        # collapse white space to one space
            $cardGroup = int(substr($line, 6, 1));
            if (($cardGroup < 1) || ($cardGroup > 4))
            {
               die "***** ERROR: Invalid card group: $line\n";
            }
         }
         else
         {
            die "***** ERROR: Invalid %CARD line: $line\n";
         }
      }
      elsif ($cardGroup > 0)
      {
         # Ensure a full 80 character line to allow modification of lines.
         $line = $line . '                                        ';
         $line = $line . '                                        ';
         $line = substr($line, 0, 80);
      
         if ($cardGroup <= 2)
         {
            push @gCard12_Lines, $line;
         }
         elsif ($cardGroup == 3)
         {
            push @gCard3_Lines, $line;
         }
         elsif ($cardGroup == 4)
         {
            push @gCard4_Lines, $line;
         }
         else
         {
            die "***** INTERNAL ERROR: Invalid card group: $cardGroup\n";
         }
      }
      else
      {
         die "***** ERROR: Unknown line: $line\n";
      }
   }
   close CONFIG;
}

# =============================================================================
# Reads the block of altitudes, elevations or ranges.
sub ReadListBlock
{
   my $FILE = shift;
   my $terminator = shift;
   my @listValues = ( );
   
   my $line;
   my @values;
   my $value;
   OUTER: while ($line = <$FILE>)
   {
      my @values = split(' ', $line);
      INNER: foreach $value (@values)
      {
         last INNER if ($value =~ /^#/);    # Skip comments
         last OUTER if ($value eq $terminator);
         push @listValues, $value;
      }
   }
   return @listValues;
}
