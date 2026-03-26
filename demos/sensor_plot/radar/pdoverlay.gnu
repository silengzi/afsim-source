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
# load "pdoverlay.cmd"

set view 0,0
set zrange [0.5:1] # ignore the limits
set xlabel "Cross Range"
set ylabel "Down Range"
splot "hm-ucav_vs_acq-dry.plt"with dots lw 3,\
"hm-ucav_vs_acq-soj.plt" with dots lw 3,\
"players-soj.plt" with points pt 6 lw 3
