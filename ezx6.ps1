#◆LANG:UTF8◆
$ver="v1.03"
$title="EZX6インストーラ"+$ver

$basepath="C:\_EZX6\"
$dlpath=$basepath + "DL\"
$fdpath=$basepath + "FD\"
$hddpath=$basepath + "HDD\"
$shell=$basepath + "shell\"
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
$imagePath = ".\EZX6.jpg" # 表示したい画像のパス
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
$form.ShowDialog()

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
$iconPath = ".\EZX6.ico"
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
$form.ShowDialog()

# フォームが閉じた後にチェックボックスの選択を読み取る
if ($chk1.Checked) {
    $inst_txt += $chk1.Text + "`n"
    $instf+=1;
}
if ($chk2.Checked) {
    $inst_txt += $chk2.Text + "`n"
    $instf+=2;
}

$string = $inst_txt + "これらのインストール内容で実行しますか？ "
#有効　Write-Host "140:" + $string


# フォームの設定
$form = New-Object System.Windows.Forms.Form
$form.Text = $title
$form.Size = New-Object System.Drawing.Size(400, 200)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.Topmost = $true

# ラベルの設定（文字サイズを大きくする）
$label = New-Object System.Windows.Forms.Label
$label.Text = $string
$label.Font = New-Object System.Drawing.Font("MS Gothic", 16, [System.Drawing.FontStyle]::Bold) # ここでサイズを指定
$label.Size = New-Object System.Drawing.Size(350, 100)
$label.Location = New-Object System.Drawing.Point(20, 20)
$label.TextAlign = "MiddleCenter"
$form.Controls.Add($label)

# Yesボタン
$yesButton = New-Object System.Windows.Forms.Button
$yesButton.Location = New-Object System.Drawing.Point(100, 120)
$yesButton.Size = New-Object System.Drawing.Size(80, 30)
$yesButton.Text = "Yes"
$yesButton.DialogResult = [System.Windows.Forms.DialogResult]::Yes
$form.AcceptButton = $yesButton
$form.Controls.Add($yesButton)

# Noボタン
$noButton = New-Object System.Windows.Forms.Button
$noButton.Location = New-Object System.Drawing.Point(200, 120)
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


echo 全ての作業が終わりました。
Start-Sleep -Seconds 3
echo $xm6gpath から xm6g.exe を起動できます。
Start-Sleep -Seconds 3
Invoke-Item $xm6gpath

