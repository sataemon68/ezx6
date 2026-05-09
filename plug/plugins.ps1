
#プラグインCSVの読み込みテスト

#$plugins = Import-Csv .\plug\plugins.csv -Encoding UTF8
$plugins = Import-Csv .\plugins.csv -Encoding UTF8
$plugins | Format-Table
# $data = Import-Csv "file.csv"; $data.Count
    Write-Host ("csvレコード数=" + $plugins.Count )

#cmp,sURL,dURL,dFile,type,addDir,addBAT,addPATH,isFile,ck,ps1,sp1, sp2,sp3,sp4,sp5
#コンポーネント名
#ソースURL
#ダウンロードURL
#ダウンロードファイル
#type (配置先)
# X68   X68ROOT
# HDD   HDD
#配置先のディレクトリ先
#追加実行BAT(オプション)
#追加PATH(オプション)
#インストール判定ファイル(オプション→インストール判定せずチェック変更しない)
#追加ps1ファイル(オプション)
#インストールチェック(デフォルト値)
#予備1～5

foreach ($pn in $plugins) {
    # 各列（Name, Age）を個別にアクセス
    Write-Host "======================================================="
    Write-Host ("cmp="+ $pn.cmp)
    Write-Host ("sURL="+   $pn.sURL)
    Write-Host ("dURL="+   $pn.dURL)
    Write-Host ("dFile="+   $pn.dFile)
    Write-Host ("type="+   $pn.type)
    Write-Host ("aDir="+   $pn.aDir)
    Write-Host ("aBAT="+   $pn.aBAT) 
    Write-Host ("aPATH="+   $pn.aPATH) 
    Write-Host ("isFile="+   $pn.isFile) 
    Write-Host ("ps1="+   $pn.ps1 )
    Write-Host ("ck="+   $pn.ps1 )
    
#    " sURL="   $pn.sURL `
#    " dURL="   $pn.dURL `
#    " type="   $pn.type `
#    " aDir="   $pn.aDir `
#    " aBAT="   $pn.aBAT `
#    " aPATH="   $pn.aPATH `
#    " isFile="   $pn.isFile `
#    " ps1="   $pn.ps1 `
#    " sp1="   $pn.sp1 `
#    " sp2="   $pn.sp2 `
#    " sp3="   $pn.sp3 `
#    " sp4="   $pn.sp4 `
#    " sp5="   $pn.sp5 

    
#` 

}
