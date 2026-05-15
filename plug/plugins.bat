@echo off
REM ÅüLANG:SJISÅü

if "%1"=="" (
  set scr=.\plugins.ps1
) else (
  set scr="%1"
)
:loop
PowerShell -ExecutionPolicy Bypass  %scr%
pause
goto loop
