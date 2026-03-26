# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
###############################################################################
# gnuplot commands to plot the file created by running 'sensor_plot comm.txt'.
###############################################################################

reset
unset surface
set pm3d

set view 0,0
set size square
set xlabel "Down Range"
set ylabel "Cross Range"
splot "comm.plt" with pm3d
     