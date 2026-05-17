echo off
REM EZX6：このファイルはEZX6システムで使用します最下段に自動実行コマンドを記述できます。
PATH %path%;A:\TL;A:\MX;A:\RC
path
IF EXIST A:\MX\MX.BAT echo MX で MXDRVを組み込めます。解除はMX -R
IF EXIST A:\RC\RC.BAT echo RC で RCDを組み込めます。解除はRC -R
IF EXIST A:\TL\MMDSP.R echo ドライバ常駐後　MMDSPが使用できます。
REM EZX6：USER COMMAND ↓

