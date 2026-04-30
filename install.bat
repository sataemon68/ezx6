@echo off
set BASEPATH=C:\_EZX6\
rem if exist %BASEPATH%shell\ezx6.ps1 goto skip

echo %BASEPATH% へ設定ファイルをインストールします。
echo パスを変更したい場合は中止してから　
echo install.bat の set BASEPATH= 指定
echo ezx6.ps1 の $basepath= 指定
echo これらを変更してください。
pause 

mkdir %BASEPATH%
mkdir %BASEPATH%DL
mkdir %BASEPATH%HDD
mkdir %BASEPATH%shell
rem mkdir %BASEPATH%X68ROM
mkdir %BASEPATH%X68000Z
mkdir %BASEPATH%XM6tG
mkdir %BASEPATH%X68ROOT
copy /Y EZX6.* %BASEPATH%shell
copy /Y SRAM.DAT %BASEPATH%XM6tG
copy /Y xm6g.ini %BASEPATH%XM6tG
copy 1GB.zip %BASEPATH%shell
copy /Y AUTOEXEC.BAT %BASEPATH%shell
copy /Y CONFIG.SYS %BASEPATH%shell

:skip
cd /D %BASEPATH%shell

ezx6.bat


