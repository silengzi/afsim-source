# ****************************************************************************
# CUI//REL TO USA ONLY
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
# ==============================================================================
# GNUPLOT commands for the 'vmap' slow-mode plot.
#
# The input file is created by running 'sensor_plot vmaps.txt'
# ==============================================================================

load "vmap_base.gnu"

set title "Contrast Radiant Intensity (cI)"
splot "vmaps.plt" using 1:2:3 with pm3d
pause -1

set title "Background Radiant Intensity (I_B)"
splot "vmaps.plt" using 1:2:4 with pm3d
pause -1

set title "Infrared Signature"
splot "vmaps.plt" using 1:2:5 with pm3d
pause -1

set title "Optical Signature"
splot "vmaps.plt" using 1:2:6 with pm3d
pause -1

set title "Probability of Detection"
splot "vmaps.plt" using 1:2:7 with pm3d
pause -1

