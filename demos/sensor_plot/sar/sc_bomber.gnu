# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
# ============================================================================
# GNUPLOT commands for the 'bomber' SAR constraint plot.
#
# The input file is created by running 'sensor_plot sc_bomber.txt'
# ============================================================================

reset
set contour
unset surface

# ============================================================================
# Clutter-to-noise
set table "cnr.plt"
set cntrparam levels discrete 4        # <-- Specify the CNR limit
splot "sc_bomber.plt" using (-$2):1:3

# Dwell time
set table "dwell.plt"
set cntrparam levels discrete 10       # <--- Specify the dwell time
splot "sc_bomber.plt" using (-$2):1:4


# Doppler foldover
set table "doppler.plt"
set cntrparam levels discrete 0        # <-- Doppler foldover limit (0 transition)
splot "sc_bomber.plt" using (-$2):1:5

# Field of view
set table "fov.plt"
set cntrparam levels discrete 45       # <-- FOV limit
splot "sc_bomber.plt" using (-$2):1:6

unset table

# ============================================================================

set title "Bomber Example: 40kft, 450 kts - 1 Meter Resolution, 10 sec max dwell time"
set size square
set angles degrees
set grid polar 15
set xrange [-0:150]
set xtics 15
set yrange [-100:100]
set ytics 20
set xlabel "Cross Range (NMI)"
set ylabel "Down Range (NMI)"
set key on left top outside spacing 1 title "Limits" nobox


plot "dwell.plt"   title "Dwell Time"       with lines lw 2,\
     "cnr.plt"     title "CNR"              with lines lw 2,\
     "fov.plt"     title "FOV"              with lines lw 2,\
     "doppler.plt" title "Doppler Foldover" with lines lw 2



