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

reset

set title "ESA 2-D"
set xlabel "Azimuth / Elevation (degrees)"
set ylabel "Gain (dB)"
#set yrange [-35:35]
#set xrange [-90:90]
set grid
plot "esa_az.plt" with lines,\
     "esa_el.plt" with lines