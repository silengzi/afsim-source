# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
# ============================================================================
# GNUPLOT commands for the 'bomber' SAR signal-to-noise plot.
#
# The input file is created by running 'sensor_plot sn_bomber.txt'
# ============================================================================

reset
set pm3d
unset surface

set title "Bomber Example: 40kft, 450 kts\nSignal-To-Noise"
set size square
set grid front
set xrange [-100:100]
set xtics 20
set yrange [-100:100]
set ytics 20
#set zrange [-20:]
set zrange [-200:]
set ylabel "Cross Range"
set xlabel "Down Range"
set view 0,270
set view map
splot "sn_bomber.plt" with pm3d

