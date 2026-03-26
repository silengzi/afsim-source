# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
# GNUPLOT plotting commands
# Plot the vertacal map.
# load "vmplot.cmd"
 
unset surface
set pm3d
set view 0,0
set zrange [-299:299] # ignore the limits
set xlabel "Range"
set ylabel "Altitude"
splot "vm-ucav_vs_acq-soj.plt" with pm3d
#splot "vm-ucav_vs_acq-soj2.plt" with pm3d