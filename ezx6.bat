@echo off
REM ÅüLANG:SJISÅü
cd /d "%~dp0"
path "%~dp0"\shell;%path%
rem set BASEPATH=C:\_EZX6\
rem if exist %BASEPATH%shell\ezx6.ps1
:loop

if "%1"=="" (
  set pa=C:\_EZX6\shell
) else (
  set pa="%1"
)
rem  cd /D %pa%
rem echo cpath : %pa%
rem PowerShell -ExecutionPolicy RemoteSigned %scr%
rem PowerShell -ExecutionPolicy Bypass  %BASEPATH%shell\ezx6.ps1
cd
path
PowerShell -ExecutionPolicy Bypass  .\ezx6.ps1

rem tree /f ..\
pause

