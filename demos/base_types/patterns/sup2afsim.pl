# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
#!/usr/bin/perl -w
# convert a suppressor antenna pattern to a tabular pattern
#

sub ReadAndTrim
{
   # Read a single line from the input file, checking for EOF.
   $eof = !($line = <ANT_IN>);

   # Trim leading and trailing whitespace.
   $line =~ s/^\s+|\s+$//g;
};

if (@ARGV != 2)
{
   die("Wrong number of arguments.\nUsage: convert <in_file> <out_file>\n");
}

$file_name = $ARGV[0];
$out_file_name = $ARGV[1];

if (! open(ANT_IN, "+<", $file_name))
{
    die("** ERROR: File $file_name could not be opened\n");
}

if (! open ANT_OUT, ">", $out_file_name)
{
    die("** ERROR: File $out_file_name could not be opened\n");
}

$el_array_index = 0;
$data_value_set_index = 0;
$az_array_length = 0;
$max_el_values_size = 0;
$max_el_values_index = 0;
$el_array_length = 0;
my @el_array;
#Read first line;
ReadAndTrim();

while (!eof)
{
   #print $line, "\n";
   # first character in the line should not be "$"
   # if DIMENSION 1 AZ found
   if (index($line , "DIMENSION 1  AZ")!= -1)
   {
      $firstChar = index($line, "(") + 1;
      $lastChar = index($line, ")") - 1;
      $az_units = lc(substr $line, $firstChar,  ($lastChar - $firstChar + 1));
      ReadAndTrim();
      while (index($line, "\$") != 0)
      {
         # push all whitespace delimited values into the array.
         push (@az_array, split(/\s+/, $line));
         ReadAndTrim();
      }
      $az_array_length = @az_array;

      # get ready for next block
      $index = 0;
      while ($index != $az_array_length)
      {
         $offset = 0.0;  # may change
         push(@az_array_padded, $az_array[$index]);
         if (($index != 0) &&
             ($index != ($az_array_length - 1)))
         {
            push(@az_array_padded, $az_array[$index] + 0.0001);
         }
         $index = $index + 1;
      }
   }

   # convert to array with staggered edge values (e.g. -0.00001 and 0.00001)
   # else if DIMENSION 2 EL found
   elsif (index($line, "DIMENSION 2  EL") != -1)
   {
      # check the value in parentheses
      # these are the units
      $firstChar = index($line, "(") + 1;
      $lastChar = index($line, ")") - 1;
      $el_units[$data_value_set_index] = lc(substr $line, $firstChar,  ($lastChar - $firstChar + 1));

      #print {STDOUT} "el units: ", $el_units[data_value_set_index], "\n";

      # read next line
      ReadAndTrim();

      # Clear the el values
      @el_values = ();

      # read in el values until we get to the actual data
      while (index($line, "GAIN") == -1)
      {
         # push all whitespace delimited values into the array.
         push (@el_values, split(/\s+/, $line));
         ReadAndTrim();
      }

      # these need to be saved for later evaluation
      $el_values_size = @el_values;
      for($i=0; $i<$el_values_size; $i=$i+1)
      {
         $el_array[$data_value_set_index][$i] = $el_values[$i];
      }
      $el_array_length[$data_value_set_index] = $el_values_size;

      # Need to determine which set of el values has the most elements
      # as all other el arrays will be expanded to fit this one.
      if ($el_values_size > $max_el_values_size)
      {
         $max_el_values_index = $data_value_set_index;
         $max_el_values_size = $el_values_size;
      }

      # read data values
      # this is tricky because we read either until we encounter another
      # header or comment line, or we reach eof :(
      # for now, we will REQUIRE a comment break "$"; although this does not
      # appear to be required, the files I've seen follow the rule.

      # Clear the data values.
      @data_values = ();

      # Keep reading data until we encounter the "$" char (comment) at the first position of a line.
      do
      {
         ReadAndTrim();
         if (! $eof)
         {
            $char1 = substr $line, 0, 1; #check for valid data

            # read el values;
            push (@data_values, split(/\s+/, $line));
         }
         else
         {
            print "End of file.\n";
         }
      }
      while ((!$eof) && (!($char1 =~ /\$/)));

      # these need to be saved for later evaluation
      $data_values_size = @data_values;
      for($i=0; $i<$data_values_size; $i=$i+1)
      {
         $data_array[$data_value_set_index][$i] = $data_values[$i];
      }
      $data_array_length[$data_value_set_index] = $data_values_size;

      # increment the data value set index
      #print "Data Values: ", @data_values, "end_data_values\n";
      $data_value_set_index = $data_value_set_index + 1;

      # Find max set of el values.  The entire table will have
      # to be expanded and padded to include all elevation values.
   }
   else
   {
      #comment line; read next
      ReadAndTrim();
   }
}

# Done reading input
print "Done reading input.";

$el_array_padded[0] = $el_array[$max_el_values_index][0];
$index = 1;
while ($index != $max_el_values_size)
{
   $offset = 0.0;  # may change
   push(@el_array_padded,  $el_array[$max_el_values_index][$index]);
   if ($index != ($max_el_values_size - 1))
   {
      push(@el_array_padded,  $el_array[$max_el_values_index][$index]);
   }
   $index = $index + 1;
}

#now ready to write out data
$num_padded_el_values = @el_array_padded;
$num_padded_az_values = @az_array_padded;
#$num_padded_values = $num_padded_az_values * $num_padded_el_values;

# Three comment lines
print {ANT_OUT} "# Generated from Suppressor\n";
print {ANT_OUT} "# \n";
print {ANT_OUT} "# \n";
print {ANT_OUT} $num_padded_az_values, " ", $num_padded_el_values, "\n  ";
$prevElValue = 500;
for ($i=0; $i<$num_padded_el_values; ++$i)
{
   if ($el_array_padded[$i] == $prevElValue)
   {
      print {ANT_OUT} $el_array_padded[$i]+0.01, " ";
   }
   else
   {
      print {ANT_OUT} $el_array_padded[$i], " ";
   }
   $prevElValue = $el_array_padded[$i];
}
print {ANT_OUT} "\n";

#print el index
# All data for the first az bin (first and second indices) are available in the first el set.
# Just need to expand values into all el bins
$az_index = 0;
for ($az = 0; $az < $num_padded_az_values; ++$az)
{
   $el_index = 0;
   #print $az, " ", $az_array[$az_index], " ", $az_array_padded[$az],"\n";
   for ($el = 0; $el < $num_padded_el_values; ++$el)
   {
      #print $az, " ", $el, " ", $az_index, " ", $el_index, " ", $el_array[$az_index][$el_index], " ", $el_array_padded[$el], " ", $data_array[$az_index][$el_index], "\n";
      $pattern[$az][$el] = $data_array[$az_index][$el_index];
      if ($el_array[$az_index][$el_index] < $el_array_padded[$el])
      {
         if ($el_array[$az_index][$el_index+1] <= $el_array_padded[$el])
         {
            $el_index += 1;
         }
      }
   }
   if ($az_array[$az_index] < ($az_array_padded[$az] - 0.0001))
   {
      $az_index += 1;
   }
}

$prevAzValue = 500;
for ($az = 0; $az < $num_padded_az_values; ++$az)
{
   if ($az_array_padded[$az] == $prevAzValue)
   {
      print {ANT_OUT} $az_array_padded[$az]+0.01, "  ";
   }
   else
   {
      print {ANT_OUT} $az_array_padded[$az], "  ";
   }
   $prevAzValue = $az_array_padded[$az];
   for ($el = 0; $el < $num_padded_el_values; ++$el)
   {
      print {ANT_OUT} $pattern[$az][$el], "  ";
   }
   print {ANT_OUT} "\n";
}

#print $az_array_padded;
# Close input and output files
close(ANT_IN);
close(ANT_OUT);
select(STDOUT);
