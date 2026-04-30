# ezx6
EZX6  XM6自動構築ツール
◆LANG:UTF8◆
==================================================================
                 EZX6  XM6自動構築ツール
                 by SaTa. 
==================================================================
Ver.1.00 2026/04/26 初期バージョン
Ver.1.01 2026/04/26 PowerShell -ExecutionPolicy Bypass指定にした
                    1GB.HDS追加
                    Windrv Win X68ROOT = X68のC:にマッピング設定
Ver.1.02 2026/04/29 ほぼ完成版
                    XDFからの起動をやめた
                    ROM作成済みならユーティリティ起動しないようにした
                    HFS起動にHuman68kのファイルを配置
                    AUTOEXEC.BAT,CONFIG.SYSを変更したものを追加
Ver.1.02a 2026/04/30 1GB.HDSをzipにした影響を修正した（実質的な動作変更なし）
==================================================================
What's this
   XM6 type G のインストールをいい感じに全自動でやってくれるツールです。
   ・各種ファイルの自動ダウンロード
   ・ファイルの自動展開
   ・初期設定済みのSRAM.DAT,xm6g.inを自動設置
   ・HDD(HFS)起動用のCONFIG.SYS,AUTOEXEC.BATを同梱、
     必要に応じて書き換えてください。
How to use
   zipを適当なディレクトリにすべて展開して
   install.bat
   を実行してください。
   あとは画面の指示に従ってください。
Note
   オプション選択がありますがすべてチェック状態でしか動作確認していません。
   7-zipが入っていない場合は画面通りインストールしてください。
   ROM設定だけXM6付属のユーティリティで作成が必要です。
   一度設定してROMファイル類が残っている場合はスキップされます。
   失敗した場合、やり直したい場合、
   インストール先（C:\_EZX6）配下を削除してやり直してください。
   なお、DLディレクトリを残しておくとダウンロードをスキップできます。
==================================================================
Copyright
	SaTa.(X@sataemon) 2026/04/29～
	ダウンロードされたファイルの著作権及び使用許諾はダウンロード元に従います。
	このツールを使う場合全てのダウンロードファイルの要件に
	同意されたとみなされます。同意できない場合は使用しないでください。
==================================================================
files
    C:\_EZX6		インストール先
    C:\_EZX6\DL		ダウンロード先
    残しておくと再ダウンロードしません）
    C:\_EZX6\HDD	HDSファイル(SCSI HDDイメージ)
    			1GB.HDS ブランクの1GB HDDディスク(Bドライブ)
    				自由にファイルを書き込めます。
    			WindrvXMboot.HDS WindrvXMを自動で組み込むブートローダー
    				ファイルを書き込むことはできません。
    C:\_EZX6\X68000Z	X68000 Z用のディレクトリ
    			現時点で未使用
    C:\_EZX6\XM6tG	XM6typeGのインストール先
    C:\_EZX6\X68ROOT	HFS起動用のファイル(Aドライブにマッピング)
fileset
    ダウンロード時のファイル
	1GB.zip		上記C:\_EZX6\HDD参照
	ezx6.bat	ezx6.ps1呼び出しbat（２回目以降の再設定用）
	EZX6.ico	EZX6アイコン
	EZX6.jpg	EZX6ロゴイメージ
	ezx6.ps1	EZX6インストーラ本体
	install.bat	初期起動用のインストールbat(通常はこれを実行)
	Readme.txt	このファイル
	SRAM.DAT	XM6typeGの初期設定済みSRAM.DAT
	xm6g.ini	XM6typeGの初期設定済みxm6g.ini
==================================================================
To Do (実装済みや将来実装する予定など)
P1：済 1.01
 WindrvXM-boot  X68ROOT に設定
  Human68kファイルを配置する
  PowerShell -ExecutionPolicy Bypass  %scr%
  にて解決
P2:済 1.02
  Human68kファイルを追加ダウンロード
  HFS(C:\_EZX6\X68ROOT)に起動用ファイルを配置する ディレクトリ付き
  CONFIG.SYS   HFS起動初期設定ファイル
  AUTOEXEC.BAT HFS起動初期設定ファイル
  必要なツール類選定　STF
  ディレクトリ配置決定　
  	\TL	ツール STF
  	\ETC 	BAT
  	\MX	MXDRV
  	\MTL	音楽ツール類 MMDSP,PCM8
  PATHを切る
Pn
 便利ツール・ドライバ
 TwentyOne.x
 LHA
 KeyWitch.X
 STF
Pn
 MUSICドライバ導入
 　MXDRV \MX
 　PCM8  \MTL
 　MMDSP \MTL
 　ドライバ組み込み・解除BAT MX.BAT/OUT.BAT
Pn
 サンプルMDX配置
Pn
 MMDSPジョイスティック操作対応
Pn いずれ
 ch30*_omake.sys
 SX-WINDOW ver3.1 辞書ディスク
 補足など
==================================================================
Acknowledgment (謝辞、敬称略)
	XM6typeG開発者 ＰＩ．
	WindrvXM-boot製作者 yunkya2
==================================================================
データ入手元
  XM6 TypeG　http://retropc.net/pi/xm6/
  IPL-ROM　http://retropc.net/x68000/software/sharp/x68bios/
  Human68kシステムディスク　http://retropc.net/x68000/software/sharp/human302/
  7-Zip　https://7-zip.opensource.jp/
  WindrvXM-boot　https://github.com/yunkya2/windrvxm-boot　
  
==================================================================


[EOF]

