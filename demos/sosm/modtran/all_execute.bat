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

perl modtran_execute.pl mid_lat_summer_day   2>&1 | tee mid_lat_summer_day.lis
perl modtran_execute.pl mid_lat_summer_night 2>&1 | tee mid_lat_summer_night.lis
perl modtran_execute.pl mid_lat_winter_day   2>&1 | tee mid_lat_winter_day.lis
perl modtran_execute.pl mid_lat_winter_night 2>&1 | tee mid_lat_winter_night.lis
perl modtran_execute.pl us_std_day           2>&1 | tee us_std_day.lis
perl modtran_execute.pl us_std_night         2>&1 | tee us_std_night.lis

endlocal