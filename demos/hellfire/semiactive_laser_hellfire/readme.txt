# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
// =========================================================================
Primary Input File = ldt_combined_test.txt
   (LDT = Laser Designation Test)
   (Combined = All platforms modeled in one instance of WSF (DIS is not used).)

Scenario:
A first static Apache aircraft is the designator, and continuously attempts
to place his laser spot on the target platform.  A second Apache aircraft
is the shooter, and has a laser tracker on board (as do his missiles).
Shooter flies up a valley, and does a pop-up manuever in the proximity
of a target.  When his tracker indicates a properly coded laser spot is
found, he fires a SAL Hellfire missile.  The missile tracks the spot to
impact.
// =========================================================================

