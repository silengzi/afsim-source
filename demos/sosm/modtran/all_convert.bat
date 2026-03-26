@echo off
rem ****************************************************************************
rem CUI//REL TO USA ONLY
rem
rem The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
rem
rem The use, dissemination or disclosure of data in this file is subject to
rem limitation or restriction. See accompanying README and LICENSE for details.
rem ****************************************************************************
setlocal

perl modtran_convert.pl mid_lat_summer_day
perl modtran_convert.pl mid_lat_summer_night
perl modtran_convert.pl mid_lat_winter_day
perl modtran_convert.pl mid_lat_winter_night
perl modtran_convert.pl us_std_day
perl modtran_convert.pl us_std_night

endlocal