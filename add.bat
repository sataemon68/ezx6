echo off
REM EZX6：このファイルはEZX6システムで使用します最下段に自動実行コマンドを記述できます。
PATH %path%;A:\TL;A:\MX;A:\RC;A:\TF;A:\MC
path
IF EXIST A:\MX\MX.BAT echo MX で MXDRVを組み込めます。解除はMX -R
IF EXIST A:\RC\RC.BAT echo RC で RCDを組み込めます。解除はRC -R
IF EXIST A:\MC\MC.BAT echo MC で MCDRVを組み込めます。解除はMC -R
IF EXIST A:\MC\MCDISP.r echo  MCDRV常駐後 MCDISPが使用できます。

IF EXIST A:\TL\MMDSP.R echo MUSICドライバ常駐後 MMDSPが使用できます。
IF EXIST A:\TF\tf.x echo STF(tf.x)が使用できます。
REM EZX6：USER COMMAND ↓

