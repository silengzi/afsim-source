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
set size square
set zrange [-299:299] # ignore the limits
set xlabel "Down Range"
set ylabel "Cross Range"

#set title "Jammer Detect"
#splot "hm-jammer-detect.plt" using 1:2:3 with pm3d

#set title "Passive Detect"
#splot "hm-pass-detect.plt" using 1:2:3 with pm3d

#set title "Required Jammer power"
#splot "hm-required-jammer-power.plt" using 1:2:3 with pm3d

#set title "UCAV Self-Protect Jammer"
#splot "hm-ucav-spj.plt" using 1:2:3 with pm3d

#set title "UCAV Acq Radar Dry"
#splot "hm-ucav_vs_acq-dry.plt" using 1:2:4 with pm3d

#set title "UCAV vs ACQ Radar with Standoff Jammer"
#splot "hm-ucav_vs_acq-soj.plt" using 1:2:3 with pm3d

#set title "UCAV vs EW Radar with Standoff Jammer"
#splot "hm-ucav_vs_ew-soj.plt" using 1:2:3 with pm3d

#set title "Bi-Static Radar"
#splot "hm-bistatic-radar.plt" using 1:2:3 with pm3d

#set title "Repeater Jammer Effect"
#splot "hm-repeater-effect.plt" using 1:2:3 with pm3d
