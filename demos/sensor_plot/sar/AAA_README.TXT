# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
This directory contains files that define some example SAR systems, sensor_plot
input file to create files for input to gnuplot, and gnuplot command files to
plot the files.

SAR system definitions
----------------------

example_sar.txt    A SAR 'sensor' definition the paper 'Synthetic Aperture Mode
                   Constraints' by Matt Renaud of The Boeing Company.

fighter_sar.txt    A SAR 'sensor' definition that might be typical of a SAR
                   mode for an AESA system mounted on the nose of a fighter.

bomber_sar.txt     A SAR 'sensor' definition that might be typical of a SAR
                   for a 'flying wing' bomber such as the X-45 UCAV.

senor_plot input files
----------------------

ag_bomber.txt      Generate a plot file of antenna gain.
ip_bomber.txt      Generate a plot file of incident power on the ground.

sc_bomber.txt      Generate a plot file for a 'SAR constraints' plot.
sc_example.txt
sc_fighter.txt

sn_bomber.txt      Generate a plot file of signal-to-noise.
sn_fighter.txt


'gnuplot' input files
---------------------

The following files can be used to plot the results of from the execution of
'sensor_plot' using one of the above input files. The file can be run by
entering the following command at the 'gnuplot' prompt:

     gnuplot> load "filename"

or from the command line:

     $ gnuplot filename -

ag_bomber.gnu      Plots the '.plt' file created by ag_bomber.txt
ip_bomber.gnu      Plots the '.plt' file created by ip_bomber.txt
sc_bomber.gnu      Plots the '.plt' file created by sc_bomber.txt
sc_example.gnu     Plots the '.plt' file created by sc_example.txt
sc_fighter.gnu     Plots the '.plt' file created by sc_fighter.txt
sn_bomber.gnu      Plots the '.plt' file created by sn_bomber.txt
sn_fighter.gnu     Plots the '.plt' file created by sn_fighter.txt

MATLAB-helper files
-------------------

The following files are used to convert a '.plt' file created by one of the
sensor_plot input (.txt) files for plotting within MATLAB.

hmap_to_matlab.pl  A PERL script to convert a '.plt' file into a '.dat' file
                   for use by the 'plot_dat.m' MATLAB function.

hmap_plot.m        Plots a '.dat' file created by the 'plt_to_dat.pl' script.


For example:

   $ run ip_bomber.txt
   $ perl hmap_to_matlab.pl ip_bomber.plt

And then in MATLAB:

   >> cd <this directory>
   >> hmap_plot

      select the desired '.dat' file.


