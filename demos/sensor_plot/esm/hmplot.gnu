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
splot "hm-jammer-detect-1.plt" with pm3d
#splot "hm-jammer-detect-2.plt" with pm3d
     