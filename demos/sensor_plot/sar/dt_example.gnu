# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
# ============================================================================
# GNUPLOT commands for the 'fighter' SAR signal-to-noise plot.
#
# The input file is created by running 'sensor_plot sn_fighter.txt'
# ============================================================================

reset
set pm3d
unset surface

set title "Dwell Time @ 40kft 400 kts"
set size square
set grid front
set xrange [-100:100]
set xtics 20
set yrange [-100:100]
set ytics 20
set zrange [0:40]
set ylabel "Cross Range"
set xlabel "Down Range"
set view 0,270
set view map
splot "dt_example.plt" with pm3d

