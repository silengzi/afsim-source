# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
# ============================================================================
# GNUPLOT commands for the 'fighter' SAR pixel count plot.
#
# The input file is created by running 'sensor_plot px_fighter.txt'
# ============================================================================

reset
set pm3d
unset surface

set title "Fighter Example: 20kft, 444 kts\nPixel Count"
set size square
set grid front
set xrange [0:60]
set xtics 20
set yrange [-60:0]
set ytics 20
#set zrange [-20:]
set zrange [-200:]
set ylabel "Cross Range"
set xlabel "Down Range"
set view 0,270
set view map
splot "px_fighter.plt" with pm3d

