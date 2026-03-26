# ****************************************************************************
# CUI//REL TO USA ONLY
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
# =============================================================================
# Used to plot the results of 'test_bbp.txt'
# =============================================================================

reset

set title "Spectral Radiant Emittance\n(W/cm^2/um)"
set xlabel "Wavelength (microns)"
set xtics 1
set ytics 0.1
set grid xtics linetype -1 linewidth 2
set grid ytics linetype -1 linewidth 2

set grid
plot "blackbody.plt" index 0 title "500 deg-K" with lines linewidth 2, \
     "" index 1 title "600 deg-K" with lines linewidth 2, \
     "" index 2 title "700 deg-K" with lines linewidth 2, \
     "" index 3 title "800 deg-K" with lines linewidth 2, \
     "" index 4 title "900 deg-K" with lines linewidth 2
