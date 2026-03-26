# ****************************************************************************
# CUI//REL TO USA ONLY
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
# =============================================================================
# Used to plot the results of test_stp.txt
# =============================================================================

reset

set key on left top box lt -1 lw 2

set title "1 m^2 Presented Area and U.S. Standard Day Atmosphere"

set xlabel "Radiant Intensity (W/sr)
set xrange [0.01:10000]
set logscale x 10
set mxtics 9
set grid ytics mytics linetype -1 linewidth 2, linetype 0 linewidth 1

set ylabel "Mach"
set yrange [0:4]
set ytics 0,0.8,4.0
set mytics 4
set grid xtics mxtics linetype -1 linewidth 2, linetype 0 linewidth 1

plot "simple_target.plt" using 2:1 title "MWIR" w l lw 3, "" using 3:1 title "LWIR" w l lw 3

