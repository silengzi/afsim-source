# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
// =====================================================================================
Primary Input Files = ldt_designator_only.txt, ldt_target_only.txt, ldt_shooter_only.txt
// =====================================================================================

LDT = Laser Designation Test

Each of the three platforms in the scenario are modeled in a different instance of WSF.
DIS is the only mechanism of the three simulations interacting.  Purpose is to confirm
ability to place a laser spot in one simulation, and track it in another, via DIS.

WARNING:  This capability does not currently work via DIS.  This is a known issue and is being looked into.  If you combine the shooter and designator in the same startup file, and run the target via DIS, it should work.

Scenario:
A first Apache aircraft is the designator, and continuously attempts to
place his laser spot on the target platform.  A second Apache aircraft
is the shooter, and has a laser tracker on board (as do his missiles).
Shooter flies up a valley, and does a pop-up maneuver in the proximity
of a target.  When his tracker indicates a properly coded laser spot is
found, he fires a SAL Hellfire missile.  The missile tracks the spot to
impact.

