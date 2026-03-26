# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
# ============================================================================
# GNUPLOT commands for the 'circular_3d' plot
#
# The input file is created by running 'sensor_plot circular_3d.txt'
# ============================================================================

reset
set pm3d
unset surface

set title "GENAP 3-D Rectangular"
#set size ratio -1
#set grid front
#set xrange [-180:180]
#set xtics 30
#set yrange [-90:90]
#set ytics 30
#set zrange [-100:40]
set ylabel "Elevation"
set xlabel "Azimuth"
set view 0,0
splot "genap_rectangular_3d.plt" with pm3d

