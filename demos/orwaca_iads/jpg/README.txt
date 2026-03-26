# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
Use this to put a map into VESPA for the area.
In the CME site/geodata.dat file, put the following entry in:

<geodata>

   <database name="ORWACA_Area">
	    <file src="../../NewProjects/orwaca_iads/jpg/orwaca.earth"/>
   </database>

</geodata>

That entry then reads in the orwaca.earth file in this directory.
