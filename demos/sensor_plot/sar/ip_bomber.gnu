# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
# ============================================================================
# GNUPLOT commands for the 'bomber' SAR incident power plot.
#
# The input file is created by running 'sensor_plot ip_bomber.txt'
# ============================================================================

reset
set pm3d
unset surface

set title "Bomber Example: 40kft, 450 kts\nIncident Ground Power"
set size square
set grid front
set xrange [-100:100]
set xtics 20
set yrange [-100:100]
set ytics 20
set zrange [-140:-60]
set zrange [-150:-50]
set ylabel "Cross Range"
set xlabel "Down Range"
set view 0,270
set view map
splot "ip_bomber.plt" with pm3d

