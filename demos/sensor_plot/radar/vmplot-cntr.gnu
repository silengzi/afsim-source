# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
# GNUPLOT plotting commands
# Plot the vertical map, note that the loewr, incremental, and upper cntrparam
#   may need adjusting depending upon the variable that is plotted
# load "vmplot.cmd"

set contour
set view 0,0
set cntrparam levels auto 20
unset surface
set zrange [-299:299] # ignore the limits
set xlabel "Range"
set ylabel "Altitude"
splot "vm-ucav_vs_acq-soj.plt" with points pt 7 ps 0.5
#splot "vm-ucav_vs_acq-soj2.plt" with points pt 7 ps 0.5

