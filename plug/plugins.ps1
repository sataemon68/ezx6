
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName Microsoft.VisualBasic

# --- 設定値 ---
$defaultCsvPath = Join-Path $PSScriptRoot "plugins.csv"
$windowTitle = "プラグインリストビューア"
$descriptionText = "URLをダブルクリックでブラウザを開けます"

# 監視用フラグ（ダイアログ重複防止ガード）
$global:isDialogShowing = $false

# --- メインウインドウ構築 ---
$form = New-Object System.Windows.Forms.Form
$form.Text = $windowTitle
$form.Size = New-Object System.Drawing.Size(900, 650)
$form.StartPosition = "CenterScreen"

# 上部レイアウト用パネル
$topPanel = New-Object System.Windows.Forms.Panel
$topPanel.Dock = "Top"
$topPanel.Height = 50

# 説明用ラベル
$label = New-Object System.Windows.Forms.Label
$label.Text = $descriptionText
$label.Location = New-Object System.Drawing.Point(15, 15)
$label.AutoSize = $true

# CSV参照ボタン（エクスプローラー起動用）
$btnBrowse = New-Object System.Windows.Forms.Button
$btnBrowse.Text = "CSVを参照する"
$btnBrowse.Size = New-Object System.Drawing.Size(120, 30)
$btnBrowse.Location = New-Object System.Drawing.Point(280, 10)

# データグリッドビュー（表形式）
$grid = New-Object System.Windows.Forms.DataGridView
$grid.Dock = "Fill"
$grid.AllowUserToAddRows = $false
$grid.AllowUserToDeleteRows = $false
$grid.ReadOnly = $true
$grid.RowHeadersVisible = $false
$grid.SelectionMode = "FullRowSelect"
$grid.AutoSizeColumnsMode = "AllCells" 
$grid.AutoSizeRowsMode = "None"

# コントロールの配置
$topPanel.Controls.Add($label)
$topPanel.Controls.Add($btnBrowse)
$form.Controls.Add($grid)
$form.Controls.Add($topPanel)

# --- CSV読み込み・表示関数 ---
function Load-PluginCsv {
    param([string]$targetPath)

    if (-not (Test-Path $targetPath)) {
        [System.Windows.Forms.MessageBox]::Show("ファイルが見つかりません`n$targetPath", "エラー", "OK", "Error")
        return
    }

    try {
        $parser = New-Object Microsoft.VisualBasic.FileIO.TextFieldParser($targetPath)
        $parser.TextFieldType = [Microsoft.VisualBasic.FileIO.FieldType]::Delimited
        $parser.SetDelimiters(",")
        $parser.HasFieldsEnclosedInQuotes = $true 

        # ヘッダー取得
        $headers = @()
        if (-not $parser.EndOfData) {
            $rawHeaders = $parser.ReadFields()
            foreach ($rawHeader in $rawHeaders) {
                $trimmed = $rawHeader.Trim()
                if (-not [string]::IsNullOrWhiteSpace($trimmed)) {
                    $headers += $trimmed
                } else {
                    $headers += "EmptyColumn_" + [Guid]::NewGuid().ToString().Substring(0,8)
                }
            }
        }

        if ($headers.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show("CSVファイルにヘッダーが含まれていません。", "警告", "OK", "Warning")
            $parser.Close()
            return
        }

        # DataTable定義
        $table = New-Object System.Data.DataTable
        foreach ($header in $headers) {
            [void]$table.Columns.Add($header, [string])
        }

        # カウント管理ハッシュ
        $columnCountsRow2Plus = @{}
        foreach ($header in $headers) { $columnCountsRow2Plus[$header] = 0 }

        $dataRowNum = 0

        # データ行ループ
        while (-not $parser.EndOfData) {
            $rowCells = $parser.ReadFields()
            $dataRowNum++ 
            $dr = $table.NewRow()
            
            for ($c = 0; $c -lt $headers.Count; $c++) {
                $header = $headers[$c]
                $val = if ($c -lt $rowCells.Count) { $rowCells[$c] } else { "" }
                if ($val -ne $null) { $val = $val.Trim() }
                
                $dr[$header] = $val
                
                # 2行目以降のデータのみカウント
                if ($dataRowNum -gt 1 -and (-not [string]::IsNullOrWhiteSpace($val))) {
                    $columnCountsRow2Plus[$header] += 1
                }
            }
            $table.Rows.Add($dr)
        }
        $parser.Close()

        # GUIの更新処理
        $grid.Columns.Clear()
        $grid.AutoGenerateColumns = $false

        foreach ($header in $headers) {
            if ($header -match "^EmptyColumn_") { continue }
            $col = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
            $col.DataPropertyName = $header  
            $col.HeaderText = $header        
            $col.AutoSizeMode = "AllCells"
            [void]$grid.Columns.Add($col)
        }

        $grid.DataSource = $table

        # 2行目以降が0個の列を非表示にする判定
        foreach ($col in $grid.Columns) {
            $finalCount = $columnCountsRow2Plus[$col.DataPropertyName]
            if ($finalCount -eq 0) {
                $col.Visible = $false
            }
        }

        Update-GridSizes

    } catch {
        [System.Windows.Forms.MessageBox]::Show("CSVの読み込み中にエラーが発生しました。`nファイルが他で開かれロックされている可能性があります。`n`n$($_.Exception.Message)", "エラー", "OK", "Error")
    }
}

# --- サイズ更新共通関数 ---
function Update-GridSizes {
    $currentSize = $grid.Font.Size
    $newHeight = [int]($currentSize * 2.5) 
    $grid.RowTemplate.Height = $newHeight
    foreach ($row in $grid.Rows) {
        $row.Height = $newHeight
    }
    $grid.ColumnHeadersHeight = $newHeight
}

# --- 【根本解決】ファイル監視インスタンスと同期処理の設定 ---
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = Split-Path $defaultCsvPath
$watcher.Filter = Split-Path $defaultCsvPath -Leaf
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite

# .NETのイベント（SynchronizingObject）をフォームに紐付けることで、別スレッドバグを完全回避
$watcher.SynchronizingObject = $form

# ファイル変更時に確実に動く同期イベントスクリプト
$watcher.add_Changed({
    if ($global:isDialogShowing) { return }
    $global:isDialogShowing = $true

    # 外部エディタの保存書き込み完了を待つ安全マージン
    Start-Sleep -Milliseconds 600

    # フォームに直接同期しているため、Invokeなしで安全にダイアログを表示
    $result = [System.Windows.Forms.MessageBox]::Show(
        $form, 
        "CSVの更新を検知しました再読み込みしますか？", 
        "ファイル更新通知", 
        "YesNo", 
        "Question"
    )

    if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        Load-PluginCsv -targetPath $defaultCsvPath
    }

    $global:isDialogShowing = $false
})

# --- イベントハンドラ ---

# ボタンクリック：エクスプローラーをファイル選択状態で開く
$btnBrowse.add_Click({
    if (Test-Path $defaultCsvPath) {
        Start-Process "explorer.exe" -ArgumentList "/select,`"$defaultCsvPath`""
    } else {
        [System.Windows.Forms.MessageBox]::Show("選択するCSVファイルが見つかりません。`n$defaultCsvPath", "エラー", "OK", "Error")
    }
})

# ウインドウサイズに連動してフォントサイズと行の高さを変更する処理
$lastFormSize = $form.ClientSize
$form.add_Resize({
    $scaleChangeX = $form.ClientSize.Width / $lastFormSize.Width
    $scaleChangeY = $form.ClientSize.Height / $lastFormSize.Height
    $averageScale = ($scaleChangeX + $scaleChangeY) / 2
    
    $newSize = $grid.Font.Size * $averageScale
    if ($newSize -lt 10) { $newSize = 10 }
    if ($newSize -gt 18) { $newSize = 18 }

    $newFont = New-Object System.Drawing.Font($grid.Font.FontFamily, $newSize, $grid.Font.Style)
    $grid.Font = $newFont
    $grid.ColumnHeadersDefaultCellStyle.Font = $newFont 

    Update-GridSizes

    $btnBrowse.Left = $label.Right + 20
    $lastFormSize = $form.ClientSize
})

# ダブルクリックでURLを開く処理
$grid.add_CellMouseDoubleClick({
    $rowIndex = $_.RowIndex
    $columnIndex = $_.ColumnIndex

    if ($rowIndex -ge 0 -and $columnIndex -ge 0) {
        $cellValue = $grid.Rows[$rowIndex].Cells[$columnIndex].Value
        if ($cellValue -ne $null) {
            $cellValue = $cellValue.ToString()
            if ($cellValue -match "^https?://") {
                try {
                    [System.Diagnostics.Process]::Start($cellValue)
                } catch {
                    Start-Process $cellValue
                }
            }
        }
    }
})

# フォームが完全に開いた瞬間に監視を開始する
$form.add_Load({
    $watcher.EnableRaisingEvents = $true
})

# 表を閉じたら監視を確実に終了する
$form.add_FormClosing({
    $watcher.EnableRaisingEvents = $false
    $watcher.Dispose()
})

# --- 初期起動処理 ---
$initialFont = New-Object System.Drawing.Font($grid.Font.FontFamily, 11, $grid.Font.Style)
$grid.Font = $initialFont
$grid.ColumnHeadersDefaultCellStyle.Font = $initialFont

# 初期読み込み実行
Load-PluginCsv -targetPath $defaultCsvPath

# ボタン配置の最終微調整
$btnBrowse.Left = $label.Right + 20

# フォームの表示
[void]$form.ShowDialog()

