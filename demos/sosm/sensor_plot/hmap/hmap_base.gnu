# ****************************************************************************
# CUI//REL TO USA ONLY
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
# ==============================================================================
# GNUPLOT commands for the 'hmap' plot used by 'hmaps.gnu' and 'hmapf.gnu'
# ==============================================================================

reset
set pm3d
unset surface

set title ""
set size square
set grid front
set xrange [-200:200]
set xtics 20
set yrange [-200:200]
set ytics 20
#set zrange [0:1]
set ylabel "Cross Range"
set xlabel "Down Range"
set view 0,270
set view map

