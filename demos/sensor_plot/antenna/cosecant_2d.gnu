# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
# GNUPLOT plotting commands
# Plot the antenna 2d pattern
# load "ant2dplot.cmd"

reset

set title "2-D Cosecant"
set xlabel "Azimuth / Elevation (degrees)"
set ylabel "Gain (dB)"
#set yrange [-35:35]
#set xrange [-90:90]
set grid
plot "cosecant_az.plt" with lines,\
     "cosecant_el.plt" with lines