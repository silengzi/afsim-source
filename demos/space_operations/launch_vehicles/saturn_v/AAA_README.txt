# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
This is an example of the Apollo 11 ascent. There is no practical use other than showing
that it is possible to create a definition and match it to data.

References:

1) http://www.braeunig.us/apollo/saturnV.htm
   A detailed description of the input and sources that went into creating a Saturn V simulation.

2) http://www.braeunig.us/apollo/SaturnV.pdf
   The second-by-second results of the simulation

3) http://www.aulis.com/pdf%20folder/SaturnV1969.pdf
   Apollo/Saturn V Postflight trajectory - AS-506 (Doc. # D5-15560)

Similar documents to that in reference 3:

https://history.nasa.gov/afj/ap13fj/pdf/as-508-postflight-traj-19700610-1992075313.pdf

There are two definitions. Both are based fundamentally on the parameters given in reference 1.

1) 'saturn_v_complex.txt' and its test driver 'complex_test.txt'. This version is a bit more
   complex in that it attempts to come as close as possible to the time history given in
   reference 2.

2) 'saturn_v_simple.txt' and its test driver 'simple_test.txt'. This removes a lot of extra
   mass accounting and guidance computer states. It shows that even using a simplified
   representation that it is possible to get pretty close.

Other files
-----------

'atmosphere.txt' - The atmosphere from reference 1.

'saturn_v_mach_and_cd.txt' - The digitized aero data from reference 1.

'tune.txt' - A file used to drive weapon_tools. This was used in aborted attempt to apply
    a process to tune the simple definition guidance computer. I had to fall back on simplifying
    the complex computer.