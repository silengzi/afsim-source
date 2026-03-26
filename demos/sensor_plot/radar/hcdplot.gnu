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
set grid
set size square 1,1
set view equal xy
plot "hcd-ew_radar.hcd" using 3:4 with lines title "Radar"
