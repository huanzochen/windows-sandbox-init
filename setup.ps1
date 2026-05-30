Write-Host "開始初始化 Sandbox 環境..." -ForegroundColor Cyan

# 1. 安裝 Chocolatey (套件管理工具)
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "正在安裝 Chocolatey..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# 2. 安裝所有必備軟體 (-y 代表自動同意，不跳提示)
Write-Host "正在安裝/更新 VSCode, Chrome, Git, NVM, Notion, GitHub CLI, AntiGravity..." -ForegroundColor Yellow
choco install vscode googlechrome git nvm notion gh antigravity -y

# 3. Git 設定
Write-Host "設定 Git..." -ForegroundColor Yellow
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
git config --global user.email "tc"
git config --global user.name "tc"

# 4. Windows 任務欄設定：永不合併 (Combine taskbar buttons: never)
Write-Host "設定工作列永不合併..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Value 2
Stop-Process -Name explorer -Force

# 5. VSCode 設定 (Git Bash 預設 & 信任工作區)
Write-Host "設定 VSCode..." -ForegroundColor Yellow
$vscodeSettingsDir = "$env:APPDATA\Code\User"
$vscodeSettingsFile = "$vscodeSettingsDir\settings.json"

if (-not (Test-Path $vscodeSettingsDir)) {
    New-Item -ItemType Directory -Force -Path $vscodeSettingsDir | Out-Null
}

$settings = @{}
if (Test-Path $vscodeSettingsFile) {
    $settings = Get-Content $vscodeSettingsFile -Raw | ConvertFrom-Json -AsHashtable
}

$settings['terminal.integrated.defaultProfile.windows'] = 'Git Bash'
$settings['security.workspace.trust.enabled'] = $false

$settings | ConvertTo-Json -Depth 10 | Set-Content $vscodeSettingsFile

# 6. 自動將 Chrome 設為預設瀏覽器
Write-Host "正在設定 Chrome 為預設瀏覽器..." -ForegroundColor Yellow
Invoke-WebRequest -Uri "https://github.com/DanTup/SetDefaultBrowser/releases/download/v1.4/SetDefaultBrowser.exe" -OutFile "$env:TEMP\SetDefaultBrowser.exe"
& "$env:TEMP\SetDefaultBrowser.exe" HKLM "Google Chrome"

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "自動化腳本執行完畢！接下來你需要手動完成的幾件事："
Write-Host "1. 登入 Notion"
Write-Host "2. 登入 GitHub (打開終端機輸入 gh auth login)"
Write-Host "======================================" -ForegroundColor Cyan
