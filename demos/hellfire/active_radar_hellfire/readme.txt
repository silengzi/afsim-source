# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
Primary Input File = rf_autonomous_test.txt

Scenario:
A single Apache aircraft is equiped with RF Hellfire Missiles and a Radar.
He traverses up a valley while terrain following a side wall of a valley,
and then at an expect location for a threat, he does a pop-up to scan for
targets with his radar.  When a track is established, he hands off the
track to the fire-and-forget active radar Hellfire missile, which homes
in and kills the target.  After the weapon is fired, he departs through
the center of the valley, not bothering to terrain follow, as he scanned
for threats on the way in.
