@echo off
REM ÅüLANG:SJISÅü
set BASEPATH=C:\_EZX6\
rem if exist %BASEPATH%shell\ezx6.ps1
:loop

if "%1"=="" (
  set pa=C:\_EZX6\shell
) else (
  set pa="%1"
)
  cd /D %pa%
echo cpath : %pa%
rem PowerShell -ExecutionPolicy RemoteSigned %scr%
PowerShell -ExecutionPolicy Bypass  %BASEPATH%shell\ezx6.ps1

rem tree /f ..\
pause

