@echo off
rem ****************************************************************************
rem CUI
rem
rem The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
rem
rem The use, dissemination or disclosure of data in this file is subject to
rem limitation or restriction. See accompanying README and LICENSE for details.
rem ****************************************************************************
setlocal
call ..\..\..\bin\weapon_tools.exe blue_sr_sam_lcg.txt
call ..\..\..\bin\weapon_tools.exe blue_lr_sam_lcg.txt
call ..\..\..\bin\weapon_tools.exe blue_naval_sam_lcg.txt
endlocal