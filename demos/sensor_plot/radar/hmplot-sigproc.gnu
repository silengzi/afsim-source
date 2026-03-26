# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
# GNUPLOT plotting commands
# Plot the horizontal map
# load "hmplot.cmd"

reset

unset surface
set pm3d

set view 0,0
set size square 1,1
set view equal xy
set zrange [-299:299] # ignore the limits
set xlabel "Down Range"
set ylabel "Cross Range"

set term wxt 0
set title "PD Radar vs 1-sqm Target"
splot "hm-pd_radar.plt" using 1:2:3 with pm3d

set term wxt 1
set title "MTI Radar vs 1-sqm Target"
splot "hm-mti_radar.plt" using 1:2:3 with pm3d

set term wxt 2
set title "MTD Radar vs 1-sqm Target"
splot "hm-mtd_radar.plt" using 1:2:3 with pm3d
