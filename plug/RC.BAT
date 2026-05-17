
REM 引数-Rで解除
IF "%1" == "-r" GOTO UNSET
IF "%1" == "-R" GOTO UNSET

IF "%MDRV%" == "" GOTO EXIT
rcd
SET MDRV=rcd
SET MDRV_R=rcd -R
REM XM6のメニュー[ツール][オプション][MIDI]から適切なMIDIデバイスを設定して下さい。
goto EXIT
:UNSET
REM ドライバを解除する
%MDRV_R%
SET MDRV=""
SET MDRV_R=""

:EXIT
