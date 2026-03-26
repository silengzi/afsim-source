# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
Most of these launch vehicles are a work in progress. The DELTA IV Medium (delta_iv_m) is fairly well
developed and is used by several of the demos.

Most directories will include the following files:

<vehicle-type>.txt
<vehicle-type>_base.txt   (May be present)
   The definition of the launcher. If the '_base' file is NOT present then <vehicle-type>.txt simply
   defines the vehicle. If the '_base` file IS present then it defines <VEHICLE-TYPE>_BASE. the
   other file will simply use this to define <VEHICLE-TYPE>

   This was done to eliminate duplication. A user can simply include the base definition and use the
   `edit mover` capability to only update those things that are needed (e.g. payload mass) or to
   to add probabilities of ignition failure. The 'delta_iv_m' does this, and it should be used as a
   pattern.

lcg_ccafs_leo.txt
   The weapon_tools input to generate a launch computer. The resulting file will be
   <vehicle-type>_ccafs_leo.txt

test.txt
   Performs a simple test shot of the launch vehicle.

tune.txt
   weapon_tools input used to aid in tuning the guidance computer.

Status of directories
---------------------

atlas_v_401   Tuned and functional
delta_iv_m    Tuned and functional. Launch computer included.
falcon_9      Somewhat tuned and functional. I had to guess at a lot of data and it was pretty sensitive.
falcon_heavy  Initial capability. A lot of guessing. THis is very sensitive and it would help to know more about it.
launcher_one  Initial capability. A lot of guessing.
proton_m      Unknown state.
saturn_v      Simply a demonstrator. This was used for development because there was a lot known about it.
