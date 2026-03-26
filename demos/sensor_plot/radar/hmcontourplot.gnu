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

set contour
set cntrparam levels 1

set view map

set mxtics 2
set mytics 2
set grid xtics
set grid ytics
set grid mxtics
set grid mytics
set xrange [-300:300]
set yrange[-300:300]
#set zrange [0.5:1] # ignore the limits
set size square
set xlabel "Down Range"
set ylabel "Cross Range"

set title "Bi-Static Radar"
splot "hm-bistatic-lab-100km.plt" using ($1-50):2:3  with lines title "100 km", \
      "hm-bistatic-lab-200km.plt" using ($1-100):2:3 with lines title "200 km", \
      "hm-bistatic-lab-300km.plt" using ($1-150):2:3 with lines title "300 km", \
      "hm-bistatic-lab-400km.plt" using ($1-200):2:3 with lines title "400 km"

#splot "hm-bistatic-lab-300km.plt" using ($1-150):2:3  with lines title "R0=300 km", \
#      "hm-bistatic-lab-jamming-300km.plt" using ($1-150):2:3 with lines title "Burnthrough", \
#      "hm-bistatic-lab-ft-jamming-300km.plt" using ($1-150):2:3 with lines title "False Target"