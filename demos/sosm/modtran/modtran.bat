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

if "%MODROOT%" == "" (
   set MODROOT=c:\PcModWin5\bin
)

if "%1" == "" (
   echo Name of case not provided
   exit /b 1
)
set CURDIR=%CD%
echo %CD%\%1>%MODROOT%\mod5root.in

cd %MODROOT%
rem Mod5.2.0.0.exe
Mod5.2.0.0.exe 2>&1 >%CURDIR%\%1.log
del %MODROOT%\mod5root.in
del %CURDIR%\%1.log

endlocal
@echo on

