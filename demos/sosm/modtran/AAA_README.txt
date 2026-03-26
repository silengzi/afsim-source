# ****************************************************************************
# CUI//REL TO USA ONLY
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************
===============================================================================
Instructions for creating SOSM atmospheric tables using MODTRAN
17 June 2009
===============================================================================

This directory contains the scripts and data files necessary to run MODTRAN to
generate atmospheric data and convert it to the format used by the Spectral
Optical Detection Model (SOSM).

Before running, two things must be done:

1) Ensure 'perl' is loaded on your PC.

2) Define the environment variable MODROOT to point to the directory that
   contains the MODTRAN executable. This is used by 'modtran.bat'.

To create the atmospheric tables, perform the following:

1) Create a '.def' file which defines the altitude, elevation, ranges and
   MODTRAN input for the desired atmospheric characteristics. Several definitions
   have been provided:

      us_std_day.def              1976 U.S. Standard, Day, Clear
      mid_lat_summer_day.def      Mid-Latitude Summer, Day, Clear
      mid_lat_winter_day.def      Mid-Latitude Winter, Day, Clear
      us_std_night.def            1976 U.S. Standard, Night, No Moon, Clear Sky
      mid_lat_summer_night.def    Mid-Latitude Summer, Night, No Moon, Clear Sky
      mid_lat_winter_night.def    Mid-Latitude Winter, Night, No Moon, Clear Sky

   These cases all share the following characteristics:

      a) Clear sky (no haze, no clouds, no rain, rural extintion)
      b) Mie scattering
      c) Lambertian reflectance, using the standard MODTRAN albedo file
         (DATA/spec_alb.dat), 'farm' curve.
      d) Spectral range of 240 to 6680 cm-1 (1.497 um to 41.667 um) in bins of
         20 cm-1. The Near IR (NIR) band (0.75 nm to 1.5 nm) is omitted because
         it doubles the size of the resulting tables, and is 'never' used.

   The '.def' file also includes specification of the altitude, elevation and
   range breakpoints to be used.

2) Execute MODTRAN:

      $ perl modtran_execute.pl <name-of-def-file>

   This command may take several hours! It will create 4 files:

      <def-file-basename>_bgr.plt      Background radiance
      <def-file-basename>_bgt.plt      Background transmittance
      <def-file-basename>_fgr.plt      Foreground radiance
      <def-file-basename>_fgt.plt      Foreground transmittance

3) Convert the MODTRAN output to SOSM format:

      $ perl modtran_convert.pl <name-of-def-file>

   This will take MODTRAN '.plt' file and create 4 files:

      <def-file-basename>.bgr          Background radiance
      <def-file-basename>.bgt          Background transmittance
      <def-file-basename>.fgr          Foreground radiance
      <def-file-basename>.fgt          Foreground transmittance

   These files should be copied to where they are needed. The '.plt' files may
   be deleted if desired.


===============================================================================
===============================================================================

                              NOMINAL MODTRAN INPUT

===============================================================================
===============================================================================

This section describes more fully the 'nominal MODTRAN input'.

In the following text, the term 'nominal MODTRAN input' refers to the baseline
MODTRAN input provided by the user. For our baseline atmospheres the input is
GENERALLY set up as follows.


================================================================================
CARD 1
         1         2         3         4         5         6         7         8
1---|----0----|----0----|----0----|----0----|----0----|----0----|----0----|----0

MS  x    3    2    1    0    0    0    0    0    0    0    0    1     0.0LAMBER

    ^    ^    ^    ^                                             xxxx.xxxyyyyyyy
    |    |    |    |
    |    |    |    +--- IMULT  (see below)
    |    |    +-------- IEMSCT (see below)
    |    +------------- ITYPE  (internally set to 2 or 3)
    +------------------ MODEL  (set to 1-6 as desired)

IEMSCT will internally be set to 0 when calculating transmittance values. The
       value defined here will be used for calculating radiance values

IMULT  will internally be set to 0 when calculation transmittance values. The
       value defined here will be used for calculating radiance values.

================================================================================
CARD 1A
         1         2         3         4         5         6         7         8
1---|----0----|----0----|----0----|----0----|----0----|----0----|----0----|----0
ff  8f   0   365.000         0         0 f f f f         0.0

For the U.S. Standard Atmosphere case, the value of CO2MX (columns 11-20) is
330.0 (per Joe Samocha), which is the MODTRAN default value. For all other cases
it will be 365.000, which is the MODTRAN recocmmened value.

================================================================================
CARD 2
         1         2         3         4         5         6         7         8
1---|----0----|----0----|----0----|----0----|----0----|----0----|----0----|----0
    1    0    0    3    0    0       0.0       0.0       0.0       0.0       0.0

 ^  ^^   ^  ^ ^    ^    ^    ^       VIS       WSS       WHH    RAINRT    GRDALT
 |  ||   |  | |    |    |    |
 |  ||   |  | |    |    |    +--- IVSA
 |  ||   |  | |    |    +-------- ICLD
 |  ||   |  | |    +------------- ICSTL
 |  ||   |  | +------------------ IVULCN
 |  ||   |  +-------------------- ARUSS
 |  ||   +----------------------- ISEASN
 |  |+--------------------------- CNOVAM
 |  +---------------------------- IHAZE
 +------------------------------- APLUS

IHAZE  = 1, RURAL extinction, default VIS = 23km
ISEASN = 0, Season determined by value of MODEL from CARD 1.
IVULCN = 0, Background stratospheric profile and extinction
ICSTL  = 3, Air mass character used when IHAZE = 3 (default value is 3).
            Since we are running IHAZE=1, this has no impact.
ICLD   = 0, No clouds or rain

================================================================================
CARD 3
         1         2         3         4         5         6         7         8
1---|----0----|----0----|----0----|----0----|----0----|----0----|----0----|----0

All of these values will be computed internally.

CARD 3A1
         1         2         3         4         5         6         7         8
1---|----0----|----0----|----0----|----0----|----0----|----0----|----0----|----0
    2    2  xxx    y
    ^    ^    ^    ^
    |    |    |    |
    |    |    |    +--- ISOURC = 0 for sun, 1 for moon
    |    |    +-------- IDAY, day of the year
    |    +------------- IPH
    +------------------ IPARM

CARD 3A2
         1         2         3         4         5         6         7         8
1---|----0----|----0----|----0----|----0----|----0----|----0----|----0----|----0
         ^         ^         ^         ^         ^         ^         ^         ^
      xx.x      yy.y                                             zzz.z       0.0
         |         |                                                 |
         |         +---- PARM2                             ANGLEM ---+
         +-------------- PARM1

PARAM1   Azimuth angle from observer line of sight and the observer-to-source
         path, measured from the line of sight.

PARAM2   Zenith angle of the source.

ANGLEM   If moon is the source (ISOURC=1), the phase angle of the moon.
         0.0 for full moon, 90.0 for half moon, 180.0 for no moon.

================================================================================
CARD 4
         1         2         3         4         5         6         7         8
1---|----0----|----0----|----0----|----0----|----0----|----0----|----0----|----0

       240      6666        20        20TW       WTAA

         ^         ^         ^         ^^^
         |         |         |         |||
         |         |         |         ||+- XFLAG
         |         |         |         |+-- YFLAG
         |         |         |         +--- FHVW
         |         |         +------------- DV
         |         +----------------------- V2
         +--------------------------------- V1


V1       Initial wavenumber. This value should always start on a multiple of DV.

V2       Final wavenumber

DV       The output bin size/increment, in wavenumbers.

FHVW     = 20, which should equal the value of DV to avoid convolution.

YFLAG    will be set internally to 'T' (output transmittance) or 'R' (output
         'radiance') depending on the type of output needed.

XFLAG    = 'W', output in wavenumbers.

================================================================================
CARD 4A, 4L1 and 4L2 are needed for Lambertian surfaces (CARD 1)

         1         2         3         4         5         6         7         8
1---|----0----|----0----|----0----|----0----|----0----|----0----|----0----|----0

1      0.0
DATA/spec_alb.dat
farm


===============================================================================
===============================================================================

                           MODTRAN EXECUTION PROCESS

===============================================================================
===============================================================================

'modtran_execute.pl' takes the 'nominal MODTRAN input' provided in the '.def'
file, along with the prescribed altitude, elevation and range sample points,
and executes MODTRAN 4 times for each sample point:

   *) Background transmittance
   *) Background radiance
   *) Foreground transmittance
   *) Foreground radiance

The follow sections define how the 'nominal MODTRAN input' is modified to
execute each of the 'modes'.

===============================================================================
Background Transmittance
------------------------

Using the nominal MODTRAN input:

   Card 1:
      Set ITYPE  = 3 (vertical or slant path to space or ground)
      Set IEMSCT = 0 (spectral transmittance mode)

   Card 3:
      Uses H1, ANGLE form.

   Card 4:
      Sets YFLAG = 'T' (output transmittance)

===============================================================================
Background Radiance
-------------------

Using the nominal MODTRAN input:

   Card 1:
      Set ITYPE = 3  (vertical or slant path to space or ground)

      NOTE: IEMSCT is used as-is from the nominal MODTRAN input. This should be
            1, 2 or 3.

   Card 3:
      Uses the H1, ANGLE form

   Card 4:
      Sets YFLAG = 'R' (output radiance)


===============================================================================
Foreground Transmittance
------------------------

Using the nominal MODTRAN input:

   Card 1:
      Set ITYPE  = 2 (slant path between two altitudes)
      Set IEMSCT = 0 (spectral transmittance mode)

   Card 3:    The form used will depend on conditions

      Vertical path:
         Use H1, H2, ANGLE form with ANGLE = 0 or 180.

      Non-vertical path:
         Use H1, H2, ANGLE, RANGE form. Range will possibly be truncated to
         prevent intersection with the surface (problem in MODTRAN).

   Card 4:
      Sets YFLAG = 'T' (output transmittance)

===============================================================================
Foreground Radiance
-------------------

Using the nominal MODTRAN input:

   Card 1:
      Set ITYPE  = 2 (slant path between two altitudes)

      NOTE: IEMSCT is used as-is from the nominal MODTRAN input. This should be
            1, 2 or 3.

   Card 3:    The form used will depend on conditions

      Vertical path:
         Use H1, H2, ANGLE form with ANGLE = 0 or 180.

      Non-vertical path:
         Use H1, H2, ANGLE, RANGE form. Range will possibly be truncated to
         prevent intersection with the surface (problem in MODTRAN).

   Card 4:
      Sets YFLAG = 'R' (output radiance)
