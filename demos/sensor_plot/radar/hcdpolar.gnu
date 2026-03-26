# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
# GNUPLOT plotting commands
# Plot the vcd's. X axis should be in 'nm' and Y axis in 'kft'
# load "vcdplot.cmd"

reset
set autoscale
set polar
set size square
set angles degrees
set rrange[0:500]
set grid polar 30
plot "hcd-ew_radar.hcd" using 1:2 with lines title "Radar"
     