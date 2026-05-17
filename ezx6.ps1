#◆LANG:UTF8◆
$cd=$PSScriptRoot
Set-Location -Path $PSScriptRoot
$vertxt= Join-Path $PSScriptRoot "ver.txt"
$text = (Get-Content -Path $vertxt -Raw).Replace("`r`n", "").Replace("`n", "")
$ver="Ver."+$text

#バージョンのURL
$vurl1="https://raw.githubusercontent.com/sataemon68/ezx6/refs/heads/main/ver.txt"
$vurl2="https://raw.githubusercontent.com/sataemon68/ezx6/refs/heads/feature/test-new/ver.txt"

$title="EZX6インストーラ"+$ver
# $($args[0])
$arg= $($args[0])
#Write-Host $arg  #第一引数の内容
$currentDir = (Get-Location).Path


#管理者権限に移行
#管理者権限に移行 (正常に動作しないのでコメント)
Write-Host 管理者権限に移行
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $currentDir" -Verb RunAs  -WorkingDirectory $currentDir
    Exit
}
#管理者権限に移行 おわり

if
(-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) 
{
Write-Host 管理者権限で実行してください。
Start-Sleep -Seconds 10
exit 1
}

if($null -ne $arg )
{
	Write-Host "カレントディレクトリ変更"
	Set-Location -Path $arg
}
$currentDir = (Get-Location).Path
Write-Host "currentDir =" $currentDir


$basepath="C:\_EZX6\"
$dlpath=$basepath + "DL\"
$fdpath=$basepath + "FD\"
$hddpath=$basepath + "HDD\"
$shell=$basepath + "shell\"
$ppath=$basepath + "shell\plug"
$x68z=$basepath + "X68000Z\"
$xm6gpath=$basepath + "XM6tG\"
$xm6utl=$basepath + "XM6tG\XM6Util.exe"
#$rompath=$basepath + "X68ROM\"
$rompath=$xm6gpath
$x68root=$basepath + "X68ROOT\"






$ln=0
$addl=32
$inst_txt=""
$c1=""
$c2=""
# 1+2; // XM6tG , HDD
$instf=0

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Invoke-Download($url, $output) {
    try {
        Invoke-WebRequest -Uri $url -OutFile $output -ErrorAction Stop
    } catch {
        Write-Host "エラー: ダウンロード失敗 $url" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        exit 1
    }
}

function Invoke-Extract($args7z) {
    $proc = Start-Process -FilePath $exe7z -ArgumentList $args7z -Wait -PassThru
    if ($proc.ExitCode -ne 0) {
        Write-Host "エラー: 展開失敗 (終了コード $($proc.ExitCode))" -ForegroundColor Red
        exit 1
    }
}



# --- 設定項目 ---
$imagePath =  Join-Path $PSScriptRoot "EZX6.jpg" # 表示したい画像のパス
$displayTime = 3000 # 表示時間 (ミリ秒)
# ----------------

# フォームの作成
$form = New-Object Windows.Forms.Form
$form.Width = 220
$form.Height = 250
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$form.TopMost = $true





# 画像の表示
$pictureBox = New-Object Windows.Forms.PictureBox
$pictureBox.Image = [System.Drawing.Image]::FromFile($imagePath)
$pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage
$pictureBox.Dock = [System.Windows.Forms.DockStyle]::Fill
$form.Controls.Add($pictureBox)

# タイマー設定 (指定時間後に閉じる)
$timer = New-Object Windows.Forms.Timer
$timer.Interval = $displayTime
$timer.Add_Tick({
    $form.Close()
})

# フォーム表示
$form.Add_Shown({$timer.Start()})
$form.ShowDialog() | Out-Null #出力を捨てる(Cancel文字抑止)

$timer.Interval = 655360;

# フォームの作成
$form = New-Object System.Windows.Forms.Form
$form.Text = $title 
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.StartPosition = "CenterScreen"



# ラベルの作成
$label = New-Object System.Windows.Forms.Label
$label.Text = "コンポーネント選択"
$label.Location = New-Object System.Drawing.Point(0,$ln)
$ln+=$addl
$label.Size = New-Object System.Drawing.Size(300,20)

# ★ここが重要：文字サイズとフォントを変更（太字、サイズ20）
$label.Font = New-Object System.Drawing.Font("Arial", 16, [System.Drawing.FontStyle]::Bold)

# フォームにラベルを追加
$form.Controls.Add($label)

#$label = New-Object System.Windows.Forms.Label
#$label.Text =  "コンポーネント選択"
#$label.Location = New-Object System.Drawing.Point(100,10)

# Font(フォント名, サイズ, スタイル)
#$label.Font = New-Object System.Drawing.Font("MS Gothic",12, [System.Drawing.FontStyle]::Bold)


#$form.Controls.Add($label)


# チェックボックス1
$chk1 = New-Object System.Windows.Forms.CheckBox
$chk1.Checked = $true
 $c1 = "XM6 Type G and IPL-ROM"
$chk1.Text = $c1
$chk1.Location = New-Object System.Drawing.Point(10, $ln)
$ln+=$addl
$chk1.Size = New-Object System.Drawing.Size(300, 20)
$form.Controls.Add($chk1)

# チェックボックス2
$chk2 = New-Object System.Windows.Forms.CheckBox
$chk2.Checked = $true
$c2 = "HDS(HDDイメージファイル)"
$chk2.Text = $c2 
$chk2.Location = New-Object System.Drawing.Point(10, $ln)
$ln+=$addl
$chk2.Size = New-Object System.Drawing.Size(300, 20)
$form.Controls.Add($chk2)


# アイコンの設定 (.icoファイルのパスを指定)
$iconPath = Join-Path $PSScriptRoot "EZX6.ico"
if (Test-Path $iconPath) {
    $form.Icon = New-Object System.Drawing.Icon($iconPath)
}


# OKボタン
$btnOK = New-Object System.Windows.Forms.Button
$btnOK.Text = "OK"
$btnOK.Location = New-Object System.Drawing.Point(10, $ln)
$ln+=$addl
$btnOK.Add_Click({
    if ($chk1.Checked) { #Write-Host $chk1.Text
   #     $inst_txt += $chk1.Text + "`n"
#        $inst_txt += $c1 + "`n"
     }
    if ($chk2.Checked) { #Write-Host $chk2.Text 
   #     $inst_txt += $chk2.Text + "`n"
 #       $inst_txt += $c2 + "`n"
    }
#有効 Write-Host  "127:" + $inst_txt
    $form.Close()
})


$form.Controls.Add($btnOK)

#画像表示追加

$form.Controls.Add($pictureBox)

# フォームの表示
$form.ShowDialog() | Out-Null #出力を捨てる(Cancel文字抑止)

# フォームが閉じた後にチェックボックスの選択を読み取る
if ($chk1.Checked) {
    $inst_txt += $chk1.Text + "`n"
    $instf+=1;
}
if ($chk2.Checked) {
    $inst_txt += $chk2.Text + "`n"
    $instf+=2;
}





#pluginsのcsv入力
$plugins = Import-Csv plug\plugins.csv -Encoding UTF8
#$plugins = Import-Csv plugins.csv -Encoding UTF8
$plugins | Format-Table
    Write-Host ("csvレコード数=" + $plugins.Count )
#プラグインカウント
$cnt=$plugins.Count

#pluginsのフォーム表示
# フォームの作成
$form = New-Object System.Windows.Forms.Form
$form.Text = $title
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.StartPosition = "CenterScreen"


$ln=0

# ラベルの作成
$label = New-Object System.Windows.Forms.Label
$label.Text = "プラグイン選択"
$label.Location = New-Object System.Drawing.Point(0,$ln)
$ln+=$addl
$label.Size = New-Object System.Drawing.Size(300,20)

# ★ここが重要：文字サイズとフォントを変更（太字、サイズ20）
$label.Font = New-Object System.Drawing.Font("Arial", 16, [System.Drawing.FontStyle]::Bold)

# フォームにラベルを追加
$form.Controls.Add($label)
$chk = @();
# チェックボックスループ
for ($i = 0; $i -lt $cnt; $i++) {
    Write-Host ("カウント: $i cmp="+$plugins[$i].cmp ) 
	$chk += New-Object System.Windows.Forms.CheckBox
	#後でインストール状態を反映させる予定
	$chk[$i].Checked = $true
	 $c1 = $plugins[$i].cmp
	$chk[$i].Text = $c1
	$chk[$i].Location = New-Object System.Drawing.Point(10, $ln)
	$ln+=$addl
	$chk[$i].Size = New-Object System.Drawing.Size(300, 20)
	$form.Controls.Add($chk[$i])
}
# チェックボックスループ終わり



# アイコンの設定 (.icoファイルのパスを指定)
$iconPath = Join-Path $PSScriptRoot "EZX6.ico"
if (Test-Path $iconPath) {
    $form.Icon = New-Object System.Drawing.Icon($iconPath)
}



# OKボタン
$btnOK = New-Object System.Windows.Forms.Button
$btnOK.Text = "OK"
$btnOK.Location = New-Object System.Drawing.Point(10, $ln)
$ln+=$addl
$btnOK.Add_Click({
#pluginsのフォーム閉じる
    $form.Close()
})

$form.Controls.Add($btnOK)

#画像表示追加

$form.Controls.Add($pictureBox)

# フォームの表示
$form.ShowDialog() | Out-Null #出力を捨てる(Cancel文字抑止)


#pluginsのフォームチェックボックス確認
# チェックボックスループ
for ($i = 0; $i -lt $cnt; $i++) {
	#$chk[$i].Checked = $true
	if ($chk[$i].Checked) {
    		$inst_txt += $chk[$i].Text + "`n"
	}
}
# チェックボックスループ終わり

#pluginsのフォーム処理終わり



$string = $inst_txt + "これらのインストール内容で`n実行しますか？ "
Write-Host $string

# 最終確認フォームの設定
$form = New-Object System.Windows.Forms.Form
$form.Text = $title
$form.Size = New-Object System.Drawing.Size(500,(160+$ln))
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.Topmost = $true

# ラベルの設定（文字サイズを大きくする）
$label = New-Object System.Windows.Forms.Label
$label.Text = $string
$label.Font = New-Object System.Drawing.Font("MS Gothic", 16, [System.Drawing.FontStyle]::Bold) # ここでサイズを指定
$label.Size = New-Object System.Drawing.Size(400,(40+$ln))
$label.Location = New-Object System.Drawing.Point(20, 20)
$label.TextAlign = "MiddleCenter"
$form.Controls.Add($label)

# Yesボタン
$yesButton = New-Object System.Windows.Forms.Button
$yesButton.Location = New-Object System.Drawing.Point(150, (60+$ln))
$yesButton.Size = New-Object System.Drawing.Size(80, 30)
$yesButton.Text = "Yes"
$yesButton.DialogResult = [System.Windows.Forms.DialogResult]::Yes
$form.AcceptButton = $yesButton
$form.Controls.Add($yesButton)

# Noボタン
$noButton = New-Object System.Windows.Forms.Button
$noButton.Location = New-Object System.Drawing.Point(250, (60+$ln))
$noButton.Size = New-Object System.Drawing.Size(80, 30)
$noButton.Text = "No"
$noButton.DialogResult = [System.Windows.Forms.DialogResult]::No
$form.CancelButton = $noButton
$form.Controls.Add($noButton)

# フォーム表示と結果の取得
$result = $form.ShowDialog()

Write-Host Selected...
Write-Host $inst_txt
 
# 結果の判定
if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
    Write-Host "Yesが押されました"
} else {
    Write-Host "Noが押されました"
    exit 0;
}
# 最終確認フォーム処理終わり



echo 7-zipのインストール状態をチェックしています。

#& "C:\Program Files\7-Zip\7z.exe" x "C:\path\to\archive.7z" -o"C:\path\to\output_dir"
#lzh 展開に7-zipが必要
#7-Zip　https://7-zip.opensource.jp/　https://www.7-zip.org/a/7z2600-x64.exe

$exe7z="C:\Program Files\7-Zip\7z.exe"
# 7-zip
if (Test-Path $exe7z ) {
    # ファイルが存在する場合の処理
    Write-Host "7-zipはインストール済みです、続行します。"
    # 例: notepad.exe $filePath
} else {
    Write-Host "7-zipが存在しないためインストールしてください"
$url = "https://www.7-zip.org/a/7z2600-x64.exe"
$output = $dlpath + "7z2600-x64.exe"
Invoke-Download $url $output
    Write-Host $output "を実行します"
& $output
Start-Sleep -Seconds 3

}
# 7-zip




#ファイルダウンロード
echo ファイルダウンロード開始
Start-Sleep -Seconds 3

if ($instf -band 0x01 ) #XM6tG IPL-ROM
{

	$url = "http://retropc.net/pi/xm6/xm6_typeg_338_20260223.zip"
	$output = $dlpath + "xm6_typeg.zip"
	$xm6zip=$output;
	echo $url ダウンロード...

	if (Test-Path $output) {
	    Write-Host "$output が存在するためダウンロードしません。"
	} else {
	    Invoke-Download $url $output
	}

	$url = "http://retropc.net/pi/xm6/xm6_util_20220608.zip"
	$output = $dlpath + "xm6_util.zip"
	$xm6_utilzip=$output;
	Write-Host "$url ダウンロード..."

	if (Test-Path $output) {
	    Write-Host "$output が存在するためダウンロードしません。"
	} else {
	    Invoke-Download $url $output
	}

	$url = "http://retropc.net/x68000/software/sharp/x68bios/X68BIOSE.LZH"
	$output = $dlpath  + "X68BIOSE.LZH"
	$romlzh=$output
	Write-Host "$url ダウンロード..."

	if (Test-Path $output) {
	    Write-Host "$output が存在するためダウンロードしません。"
	} else {
	    Invoke-Download $url $output
	}

	#SCSI-ROM作成に必要
	$url = "http://retropc.net/x68000/software/sharp/human302/HUMN302I.LZH"
	$output = $dlpath  + "HUMN302I.LZH"
	$humanlzh=$output
	Write-Host "$url ダウンロード..."

	if (Test-Path $output) {
	    Write-Host "$output が存在するためダウンロードしません。"
	} else {
	    Invoke-Download $url $output
	}

	#HFS(C:\_EZX6\HDD)に起動用ファイルを配置するのに必要
	$url = "http://retropc.net/x68000/software/sharp/human302/HUMAN302.LZH"
	$output = $dlpath  + "HUMAN302.LZH"
	$humanlzh2=$output
	Write-Host "$url ダウンロード..."

	if (Test-Path $output) {
	    Write-Host "$output が存在するためダウンロードしません。"
	} else {
	    Invoke-Download $url $output
	}



}


if ($instf -band 0x02 ) #HDS HDDイメージダウンロード
{

	$url = "https://github.com/yunkya2/windrvxm-boot/releases/download/20240220/WindrvXMboot-20240220.zip"
	$output = $dlpath + "WindrvXMboot.zip"
	$hddzip=$output;
	echo $url ダウンロード...

	if (Test-Path $output) {
	    Write-Host "$output が存在するためダウンロードしません。"
	} else {
	    Invoke-Download $url $output
	}

}

	 #$shell=$basepath + "shell\"
	 #このファイルは同梱のファイル
	 $hddzip2=$shell + "1GB.zip"





#pluginsのダウンロード処理
#pluginsのフォームチェックボックス確認
# チェックボックスループ
for ($i = 0; $i -lt $cnt; $i++) {
	#$chk[$i].Checked = $true
	if ($chk[$i].Checked) {

		$url =$plugins[$i].dURL 
		$output = $dlpath + $plugins[$i].dFile
		echo $url ダウンロード...

		if (Test-Path $output) {
		    Write-Host "$output が存在するためダウンロードしません。"
		} else {
		    Invoke-Download $url $output
		}

	}

}
# チェックボックスループ終わり
#pluginsのダウンロード処理終了




echo ファイルダウンロード終了

Start-Sleep -Seconds 3

#ファイル展開
echo ファイル展開開始

if ($instf -band 0x01 ) #XM6tG IPL-ROM
{
# ディレクトリ無視して展開
# $exe7z e $xm6zip  $xm6gpath

#$rompath=$basepath + "X68ROM\"
#$xm6gpath=$basepath + "XM6tG\"

#
# Start-Process -FilePath "プログラム" -ArgumentList "引数1", "引数2" -Wait
 
Write-Host "$exe7z e $xm6zip -o$xm6gpath"
Invoke-Extract @("e", $xm6zip, "-o$xm6gpath", "-aoa", "-y")

Write-Host "$exe7z e $xm6_utilzip -o$xm6gpath"
Invoke-Extract @("e", $xm6_utilzip, "-o$xm6gpath", "-aoa", "-y")

Write-Host "$exe7z e $romlzh -o$rompath"
Invoke-Extract @("e", $romlzh, "-o$rompath", "-aoa", "-y")

Write-Host "$exe7z e $humanlzh -o$xm6gpath"
Invoke-Extract @("e", $humanlzh, "-o$xm6gpath", "-aoa", "-y")

Write-Host "$exe7z x $humanlzh2 -o$x68root"
Invoke-Extract @("x", $humanlzh2, "-o$x68root", "-aoa", "-y")

Write-Host "CONFIG.SYS,AUTOEXEC.BATは$shellから上書きします"
$ci1 = Join-Path $shell "CONFIG.SYS"
$ci2 = Join-Path $shell "AUTOEXEC.BAT"

try {
    Copy-Item -Path $ci1 -Destination "$x68root" -Force -ErrorAction Stop
    Copy-Item -Path $ci2 -Destination "$x68root" -Force -ErrorAction Stop
} catch {
    Write-Host "エラー: ファイルのコピー失敗" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}



}
if ($instf -band 0x02 ) #HDS HDDイメージ
{
Write-Host "WindrvXMboot.HDSの展開"
Write-Host "$exe7z e $hddzip -o$hddpath"
Invoke-Extract @("e", $hddzip, "-o$hddpath", "-aoa", "-y")

Write-Host "1GB.HDSの展開"
Write-Host "$exe7z e $hddzip2 -o$hddpath"
Invoke-Extract @("e", $hddzip2, "-o$hddpath", "-aoa", "-y")

}


#pluginsの展開処理
#pluginsのフォームチェックボックス確認
# チェックボックスループ
for ($i = 0; $i -lt $cnt; $i++) {
	#$chk[$i].Checked = $true
	if ($chk[$i].Checked) {
	$output = $dlpath  + $plugins[$i].dFile
	$lzhfile=$output

	#ファイルタイプ別に展開先を変える予定
	#$path = "C:\Folder"; $file = "file.txt"; Join-Path $path $file
	#追加パスの有無チェック
	if($plugins[$i].aPATH -eq "")
	{ #追加パス無し
		Write-Host "追加パスなし"
		$path = $x68root
		$extpath=$path

		Write-Host "extpath =" $extpath 
	}
	else
	{ #追加パスあり
		Write-Host "追加パスあり"
		$path = $x68root
		$file =  $plugins[$i].aPATH
		$extpath= Join-Path $path $file
		Write-Host "extpath =" $extpath 
	}
	Write-Host "$exe7z x $lzhfile -o$extpath"
	Invoke-Extract @("x", $lzhfile, "-o$extpath", "-aoa", "-y")
	}

}
# チェックボックスループ終わり
#pluginsの展開処理終了


echo ファイル展開終了


#ファイル加工

if ($instf -band 0x01 ) #XM6tG IPL-ROM
{
#& $exe7z x $xm6zip -o $xm6gpath
#& $exe7z x $romlzh -o $rompath


}

#ROM作成
if ($instf -band 0x01 ) #XM6tG IPL-ROM
{
#& $exe7z x $xm6zip -o $xm6gpath
#& $exe7z x $romlzh -o $rompath
#& $xm6utl ;

# $xm6gpath
# SCSIEXROM.DAT
# SCSIINROM.DAT
# CGROM.TMP
# 上記が存在したら起動しなくていい
echo ROMファイルチェック中...

$romf=0
$fp1 = Join-Path $xm6gpath "SCSIEXROM.DAT"
$fp2 = Join-Path $xm6gpath "SCSIINROM.DAT"
$fp3 = Join-Path $xm6gpath "CGROM.TMP"

	if (Test-Path $fp1 ) 
	{
		$romf+=1
	}
	if (Test-Path $fp2 ) 
	{
		$romf+=1
	}
	if (Test-Path $fp3 ) 
	{
		$romf+=1
	}

	if($romf -ne 3) # $romf != 3  の意味
	{
	echo "ROM作成のため $xm6utl を起動します"
	echo "以下のボタンを順番に押してください"
	echo "★CG-ROM(CDROM.TMP)を合成する"
	echo "★内蔵SCSI-ROM(SCSIINROM.DAT)を合成する"
	echo "★外付SCSI-ROM(SCSIEXROM.DAT)を合成する"
	echo "★閉じる"
	Start-Sleep -Seconds 3
	Start-Process -FilePath $xm6utl -Wait
	}
	else
	{
	echo "ROMが揃っているため $xm6utl を起動しません"	
	}
Start-Sleep -Seconds 3

}

#add.bat作成
#将来的には自動でPATH追加をやる
    Copy-Item -Path "add.bat" -Destination "$x68root" -Force -ErrorAction Stop

#add.bat作成終わり

#pluginsのbatコピー処理
#pluginsのフォームチェックボックス確認
# チェックボックスループ
for ($i = 0; $i -lt $cnt; $i++) {
	#$chk[$i].Checked = $true
	$flg=0
	if ($chk[$i].Checked) #チェックされている
	{
		$flg+=1
	}
	if ($plugins[$i].aBAT -ne "") #aBATがある
	{
		$flg+=1
		$abat=$plugins[$i].aBAT
	}
	
	if ($flg -eq 2)
	 {
		$output = $dlpath  + $plugins[$i].dFile
		$lzhfile=$output

		#$path = "C:\Folder"; $file = "file.txt"; Join-Path $path $file
		#追加パスの有無チェック
		if($plugins[$i].aPATH -eq "")
		{ #追加パス無し
			Write-Host "追加パスなし"
			$path = $x68root
			$extpath=$path

			Write-Host "extpath =" $extpath 
		}
		else
		{ #追加パスあり
			Write-Host "追加パスあり"
			$path = $x68root
			$file =  $plugins[$i].aPATH
			$extpath= Join-Path $path $file
			Write-Host "extpath =" $extpath 
		}
		#$ppath
		$file = $abat;
		$path= Join-Path $ppath $file
		
		Write-Host "Copy $path $extpath"
		Copy-Item -Path "$path" -Destination "$extpath" -Force -ErrorAction Stop

	}

}
# チェックボックスループ終わり
#pluginsの展開処理終了





#$shell=$basepath + "shell\"
#$ppath=$basepath + "shell\plug"
#$xm6gpath=$basepath + "XM6tG\"

Write-Host "スタートメニューを追加します"

Start-Sleep -Seconds 3
$IconPath = Join-Path $shell "EZX6.ico"


#スタートメニューにEZX6と実行用ショートを追加する。
# 1. フォルダ名とショートカット名の定義
$GroupName = "EZX6"
$ShortcutName1 = "EZX6 XM6自動構築ツール.lnk"
$TargetAppPath1 =  Join-Path $shell "ezx6.bat" # 実際のアプリパス
$wp1 = $shell

$ShortcutName2 = "EZX6 plugins 確認.lnk"
$TargetAppPath2 =  Join-Path $ppath "plugins.bat" # 実際のアプリパス
$wp2 = $ppath

$ShortcutName3 = "X680x0 EMULATOR XM6 TypeG.lnk"
$TargetAppPath3 =  Join-Path $xm6gpath "xm6g.exe" # 実際のアプリパス
$wp3 = $xm6gpath

$ShortcutName4 = "X68000 EMULATOR XM6 UTILITY.lnk"
$TargetAppPath4 =  Join-Path $xm6gpath "XM6Util.exe" # 実際のアプリパス
$wp4 = $xm6gpath

# 2. スタートメニューのプログラムフォルダパス
$StartMenuPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"
$NewFolderPath = Join-Path $StartMenuPath $GroupName

# 3. フォルダの作成
if (!(Test-Path $NewFolderPath)) {
    New-Item -ItemType Directory -Path $NewFolderPath
}

# 4. ショートカットの作成
$WshShell = New-Object -ComObject WScript.Shell

$scname=Join-Path $NewFolderPath $ShortcutName1
Write-Host "scname =" $scname
$Shortcut = $WshShell.CreateShortcut($scname)
$Shortcut.TargetPath = $TargetAppPath1
$Shortcut.WorkingDirectory = $wp1
$Shortcut.IconLocation = $IconPath
$Shortcut.Save()

$scname=Join-Path $NewFolderPath $ShortcutName2
Write-Host "scname =" $scname
$Shortcut = $WshShell.CreateShortcut($scname)
$Shortcut.TargetPath = $TargetAppPath2
$Shortcut.WorkingDirectory = $wp2
$Shortcut.IconLocation = $IconPath
$Shortcut.Save()

$scname=Join-Path $NewFolderPath $ShortcutName3
Write-Host "scname =" $scname
$Shortcut = $WshShell.CreateShortcut($scname)
$Shortcut.TargetPath = $TargetAppPath3
$Shortcut.WorkingDirectory = $wp3
$Shortcut.Save()

$scname=Join-Path $NewFolderPath $ShortcutName4
Write-Host "scname =" $scname
$Shortcut = $WshShell.CreateShortcut($scname)
$Shortcut.TargetPath = $TargetAppPath4
$Shortcut.WorkingDirectory = $wp4
$Shortcut.Save()




Write-Host "グループ '$GroupName' を作成しました。"

#スタートメニューにEZX6と実行用ショートを追加終わり


Write-Host  全ての作業が終わりました。
Write-Host  スタートメニューから起動できます。
Start-Sleep -Seconds 3
Invoke-Item $NewFolderPath

