Write-Host "開始初始化 Sandbox 環境..." -ForegroundColor Cyan

# Windows 任務欄設定：永不合併 (Combine taskbar buttons: never)
Write-Host "設定工作列永不合併..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Value 2
Stop-Process -Name explorer -Force

# 強制啟用 TLS 1.2，避免 Invoke-WebRequest 下載失敗
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

# 1. 安裝 Chocolatey (套件管理工具)
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "正在安裝 Chocolatey..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# 2. 安裝所有必備軟體 (-y 代表自動同意，不跳提示)
# 解決 NVM 遇到預裝 Node.js 會跳出視窗卡住的問題：先將其資料夾移除
$NodeJSPath = "C:\Program Files\nodejs"
if (Test-Path $NodeJSPath) {
    Write-Host "清理預裝的 Node.js 以確保 NVM 靜默安裝..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $NodeJSPath -ErrorAction SilentlyContinue
}

Write-Host "正在安裝/更新 VSCode, Chrome, Git, NVM, Notion, GitHub CLI, AntiGravity, SetDefaultBrowser..." -ForegroundColor Yellow
choco install vscode googlechrome git nvm notion gh antigravity setdefaultbrowser -y --ignore-checksums

# 3. Git 設定
Write-Host "設定 Git..." -ForegroundColor Yellow
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
git config --global user.email "tc"
git config --global user.name "tc"

# 3.5 透過 NVM 裝回 Node 18 並設定為預設 (補回剛才刪除的 Node)
Write-Host "透過 NVM 安裝並啟用 Node 18..." -ForegroundColor Yellow
nvm install 18
nvm use 18

# 5. VSCode 設定 (Git Bash 預設 & 信任工作區)
Write-Host "設定 VSCode..." -ForegroundColor Yellow
$vscodeSettingsDir = "$env:APPDATA\Code\User"
$vscodeSettingsFile = "$vscodeSettingsDir\settings.json"

if (-not (Test-Path $vscodeSettingsDir)) {
    New-Item -ItemType Directory -Force -Path $vscodeSettingsDir | Out-Null
}

$settings = New-Object PSObject
if (Test-Path $vscodeSettingsFile) {
    $content = Get-Content $vscodeSettingsFile -Raw
    if (-not [string]::IsNullOrWhiteSpace($content)) {
        $settings = ConvertFrom-Json $content
    }
}

$settings | Add-Member -MemberType NoteProperty -Name 'terminal.integrated.defaultProfile.windows' -Value 'Git Bash' -Force
$settings | Add-Member -MemberType NoteProperty -Name 'security.workspace.trust.enabled' -Value $false -Force
$settings | Add-Member -MemberType NoteProperty -Name 'workbench.editor.wrapTabs' -Value $true -Force

$settings | ConvertTo-Json -Depth 10 | Set-Content $vscodeSettingsFile

# 6. 建立常用軟體的桌面捷徑 (替代無法釘選到工作列的限制)
Write-Host "建立 VSCode, Chrome, Notion 的桌面捷徑..." -ForegroundColor Yellow
$WshShell = New-Object -comObject WScript.Shell

$AppShortcuts = @(
    @{ Name = "Google Chrome"; Paths = @("C:\Program Files\Google\Chrome\Application\chrome.exe", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe") },
    @{ Name = "Visual Studio Code"; Paths = @("$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe", "C:\Program Files\Microsoft VS Code\Code.exe") },
    @{ Name = "Notion"; Paths = @("$env:LOCALAPPDATA\Programs\Notion\Notion.exe", "C:\Program Files\Notion\Notion.exe") }
)

foreach ($App in $AppShortcuts) {
    foreach ($Path in $App.Paths) {
        $ResolvedPath = [System.Environment]::ExpandEnvironmentVariables($Path)
        if (Test-Path $ResolvedPath) {
            $Shortcut = $WshShell.CreateShortcut("C:\Users\Public\Desktop\$($App.Name).lnk")
            $Shortcut.TargetPath = $ResolvedPath
            $Shortcut.Save()
            break
        }
    }
}

# 7. 設定 Chrome 為預設瀏覽器
Write-Host "設定 Google Chrome 為預設瀏覽器..." -ForegroundColor Yellow
SetDefaultBrowser chrome

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "自動化腳本執行完畢！接下來你需要手動完成的幾件事："
Write-Host "1. 登入 Notion"
Write-Host "2. 登入 GitHub (打開終端機輸入 gh auth login)"
Write-Host "======================================" -ForegroundColor Cyan
