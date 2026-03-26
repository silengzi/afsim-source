# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
*******************************************************************************
The coefficients for atmospheric attenuation and scattering found in
this file are derived primarily from the output of ModTran,
Any additional data can be derived by running that model.

7/2009: File input format has been changed;
provided files now have the name convention as follows:

'coefs'<wavelength>.txt
Please "include_once" these files in the WSF input stream, as in

include_once coefs1064.txt

where the following wavelengths are supported (in nanometers):
1000
1060
1064
1080
1315
1620
3800

the following atmosphere models are supported from the ModTran,
Models 2,3, and 6 are supported for WSF at wavelength 1064;
otherwise only model 2 is supported at other wavelengths.
1 - Tropical Atmosphere
2 - Midlatitude Summer (default)
3 - Midlatitude Winter
4 - Subarctic Summer
5 - Subarctic Winter
6 - 1976 U.S. Standard

The following haze values are supported;
Currently all models are only available for wavelength 1064;
otherwise only model 1 is available (see model extraction procedure, below.
to access other models at other wavelengths).
1   RURAL Extinction, VIS = 23 km (Clear) (default)
2   RURAL Extinction, VIS = 5 km (Hazy)
3   Navy maritime Extinction
4   MARITIME Extinction, VIS = 23 km
5   Urban Extinction, VIS = 5 km

***********************************
Model extraction procedure:
***********************************
The following method was used to extract these values:
- Load the data
>load ModFasData.mat

- Examine the contents:
>whos -file ModFasData.mat

- Run ModFasCoefs.m to create the structure:
      >coefs = ModFasCoefs('<wavelength>', 1, haze)
e.g., >coefs = ModFasCoefs('1064',1,1)
 Creates a structure, coefs, with altitude, attenuation, and scattering 1-d
 tables.  The parameters to ModFasCoefs are wavelength, atmosphere model
 (not used, so this value can always be "1"), and haze value.

- Examine the contents of the fields in the command window:
>format long eng
>coefs.Altitude
>coefs.Abs
>coefs.Scat

- Save the template file, COEFSxxxx_x.txt, to one with the appropriate name.

- Copy and paste the data into the file, in the appropriate blocks.

The template of coefsxxxx.txt is as follows:

***********************************
atmospheric_coefficients

wavelength xxxx nanometers  // wavelength in nm for which table is valid
atmosphere_model  // 1-6; see explanation
haze_model  // 1-6; see explanation

altitude
end_altitude

attenuation
end_attenuation

scattering
end_scattering

end_atmospheric_coefficients
********************************************