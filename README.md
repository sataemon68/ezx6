# ezx6
◆LANG:UTF8◆
## 📌 概要
EZX6  XM6自動構築ツール
```
==================================================================
                 EZX6  XM6自動構築ツール
                 by SaTa. 
==================================================================
```
## What's this
```
   XM6 type G のインストールをいい感じに
   全自動でやってくれるツールです。
   ・各種ファイルの自動ダウンロード
   ・ファイルの自動展開
   ・初期設定済みのSRAM.DAT,xm6g.inを自動設置
   ・スタートメニューにショートカット追加
   ・プラグイン方式でファイルを容易に追加できます
   ・HDD(HFS)起動用のCONFIG.SYS,AUTOEXEC.BATを同梱、
     必要に応じて書き換えてください。
```
## How to use
```
   zipを適当なディレクトリにすべて展開して
   install.bat
   実行後に管理者権限に移行します。
   あとは画面の指示に従ってください。
```
## Plugins
```
    プラグインはplug下のplugins.csvを追加することで対応します。
    同一ディレクトリにあるplugins.batで内容を確認できます。

plugins.csvレコードのフォーマット形式
＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
cmp,sURL,dURL,dFile,type,aDir,aBAT,aPATH,isFile,ps1,sp1,sp2,sp3,sp4,sp5
＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
以下詳細
cmp
	コンポーネント名
sURL
	ソースURL
	ダウンロード先が確認できるURLを指定してください。
	ツール内では使用しませんがメンテナンス用に。
dURL
	ダウンロードURL
	ダウンロードするファイルのURLを指定します。
dFile
	ダウンロードファイル名
	保存するときのファイル名です。
type 
	ファイルタイプ(配置先)
	現在有効なのはX68のみです。
	以下に対応予定
	X68   X68ROOT
	HDD   HDD
aDir
	配置先のディレクトリ先
	TLと指定するとX68ROOT下のTLになります
aBAT
	追加BAT(オプション)
	追加するBATファイルを指定します。
	plug下にBATを置きます。
aPATH   現在無効
	追加PATH(オプション)
	PATHに追加するパス
isFile  現在無効
	インストール判定ファイル(オプション→インストール判定せずチェック変更しない)
ps1	現在無効
	追加ps1ファイル(オプション)
sp1-5	未使用
	予備1～5
```
## Note
```
   オプション選択がありますがすべてチェック状態でしか動作確認していません。
   7-zipが入っていない場合は画面通りインストールしてください。
   ROM設定だけXM6付属のユーティリティで作成が必要です。
   一度設定してROMファイル類が残っている場合はスキップされます。
   失敗した場合、やり直したい場合、
   インストール先（C:\_EZX6）配下を削除してやり直してください。
   なお、DLディレクトリを残しておくとダウンロードをスキップできます。

   現状のディレクトリルールのメモ
   X68ROOT 下
   	Human68kの構成を基本とする。
   	追加のディレクトリとしては以下
   		TL ツール類、ほかに必要なファイルが少ないもの
   		固有ディレクトリ2～3文字(MX,RC,ZM) ある程度まとまったツールやドライバを置く
   		DATA データファイル置き場
   		     MDX,RCP,ZMU,PAN等自由に作れる
   		     なおHuman68kの制限があるのでMIDI,PCM,OPMというディレクトリは作らないように

```

## Copyright
```
	SaTa.(X@sataemon) 2026/04/29～
	ダウンロードされたファイルの著作権及び使用許諾はダウンロード元に従います。
	このツールを使う場合全てのダウンロードファイルの要件に
	同意されたとみなされます。同意できない場合は使用しないでください。
```

## files
```
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
```
## fileset
    ダウンロード時のファイル
```
	1GB.zip		上記C:\_EZX6\HDD参照
	ezx6.bat	ezx6.ps1呼び出しbat（スタートメニューのEZX6 XM6自動構築ツール）
	EZX6.ico	EZX6アイコン
	EZX6.jpg	EZX6ロゴイメージ
	ezx6.ps1	EZX6インストーラ本体
	install.bat	初期起動用のインストールbat(通常はこれを実行)
	README.md	このファイル
	SRAM.DAT	XM6typeGの初期設定済みSRAM.DAT
	xm6g.ini	XM6typeGの初期設定済みxm6g.ini
	plug		プラグイン用ディレクトリ
			plugins.bat
				プラグイン確認(スタートメニューのEZX6 plugins 確認)
			plugins.csv
				CSV形式プラグイン記述(UTF-8)
			plugins.ps1
				プラグイン確認本体(BATから起動)
			MX.BAT 
				MXDRV用追加BAT
			RC.BAT
				RCD用追加BAT

```
## Acknowledgment (謝辞、敬称略)
```
	XM6typeG開発者 ＰＩ．
	WindrvXM-boot製作者 yunkya2
	ezx6　Fixer Awed
```
## データ入手元
```
- XM6 TypeG　http://retropc.net/pi/xm6/
- IPL-ROM　http://retropc.net/x68000/software/sharp/x68bios/
- Human68kシステムディスク　http://retropc.net/x68000/software/sharp/human302/
- 7-Zip　https://7-zip.opensource.jp/
- WindrvXM-boot　https://github.com/yunkya2/windrvxm-boot
```

## 更新履歴
```
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
Ver.1.02b 2026/04/30 1GB.HDSが壊れていたのを修正（実質的な動作変更なし）
Ver.1.03 2026/04/30 Pull requests
                   fix: ダウンロードと展開処理にエラーハンドリングを追加
                   fix: チェックボックス選択無視・URLスペース・変数名タイポの修正
Ver.1.10  2026/05/09
                     プラグイン機能追加
                     	現在設定可能なもの
                     	PCM8、MXDRV、MMDSP
                     スタートメニューグループEZX6とアイコン追加
                     	EZX6 plugins 確認.lnk
                     	EZX6 XM6自動構築ツール.lnk
                     	X68000 EMULATOR XM6 UTILITY.lnk
                     	X680x0 EMULATOR XM6 TypeG.lnk
                     上記に伴い実行時に管理者権限で起動する必要があります。
                     README.mdの書式を整理した。
Ver.1.11  2026/05/09
                     管理者権限で実行しなくても、移行できるようにした
                     plug\MX.BATのドライバ解除順序を修正した
Ver.1.12  2026/05/17
                     プラグインRCD(RC-System)関係追加
                     XM6起動後に適切なMIDI音源を選択してください
                     ver.txtでバージョン情報を書くようにした
                     X68用のBAT内容を更新
==================================================================
```

[EOF]

