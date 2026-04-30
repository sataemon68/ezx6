@echo off
REM ÅüLANG:SJISÅü
:loop

if "%1"=="" (
  set scr=.\ezx6.ps1
) else (
  set scr="%1"
)

rem PowerShell -ExecutionPolicy RemoteSigned %scr%
PowerShell -ExecutionPolicy Bypass  %scr%

tree /f ..\
pause

