Write-Host "Initializing Sandbox Environment..." -ForegroundColor Cyan

# Windows Taskbar Settings: Combine taskbar buttons: never
Write-Host "Setting taskbar to never combine..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Value 2
Stop-Process -Name explorer -Force

# Force enable TLS 1.2 to prevent Invoke-WebRequest download failures
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

# 1. Install Chocolatey (Package Manager)
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# 2. Install all necessary software (-y means auto-approve, no prompts)
# Fix NVM issue where pre-installed Node.js causes a popup to freeze: remove its folder first
$NodeJSPath = "C:\Program Files\nodejs"
if (Test-Path $NodeJSPath) {
    Write-Host "Cleaning up pre-installed Node.js to ensure silent NVM installation..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $NodeJSPath -ErrorAction SilentlyContinue
}

Write-Host "Installing/Updating VSCode, Chrome, Git, NVM, GitHub CLI, AntiGravity, SetDefaultBrowser, Claude Desktop..." -ForegroundColor Yellow
choco install vscode googlechrome git nvm gh antigravity setdefaultbrowser claude -y --ignore-checksums

# Reload environment variables (so subsequent commands like git, nvm can run properly)
Write-Host "Reloading environment variables..." -ForegroundColor Yellow
Import-Module "$env:ProgramData\chocolatey\helpers\chocolateyProfile.psm1"
Update-SessionEnvironment

# 3. Git Settings
Write-Host "Configuring Git..." -ForegroundColor Yellow
git config --global user.email "tc"
git config --global user.name "tc"

# 3.5 Reinstall Node 18 via NVM and set it as default (restoring the Node we just deleted)
Write-Host "Installing and enabling Node 18 via NVM..." -ForegroundColor Yellow
nvm install 18
nvm use 18

# 3.6 Install Claude Code (requires Node 18+, installed globally via npm)
Write-Host "Installing Claude Code..." -ForegroundColor Yellow
# Reload environment so the npm/node from 'nvm use' is on PATH for this session
Update-SessionEnvironment
npm install -g @anthropic-ai/claude-code

# 5. VSCode Settings (Git Bash default & Trust Workspace)
Write-Host "Configuring VSCode..." -ForegroundColor Yellow
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

# 6. Create desktop shortcuts for common software (workaround for inability to pin to taskbar)
Write-Host "Creating desktop shortcuts for VSCode, Chrome..." -ForegroundColor Yellow
$WshShell = New-Object -comObject WScript.Shell

$AppShortcuts = @(
    @{ Name = "Google Chrome"; Paths = @("C:\Program Files\Google\Chrome\Application\chrome.exe", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe") },
    @{ Name = "Visual Studio Code"; Paths = @("$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe", "C:\Program Files\Microsoft VS Code\Code.exe") }
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

# 7. Set Chrome as the default browser
Write-Host "Setting Google Chrome as the default browser..." -ForegroundColor Yellow
# 重新整理 PATH，確保剛由 Chocolatey 安裝的 SetDefaultBrowser 可被找到
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# 嘗試從 PATH 取得指令；若 PATH 尚未生效，再退回 Chocolatey 安裝路徑直接搜尋
$sdb = (Get-Command SetDefaultBrowser -ErrorAction SilentlyContinue).Source
if (-not $sdb) {
    $sdb = (Get-ChildItem "C:\ProgramData\chocolatey\lib\setdefaultbrowser" -Recurse -Filter "SetDefaultBrowser.exe" -ErrorAction SilentlyContinue | Select-Object -First 1).FullName
}

if ($sdb) {
    # 此 Chocolatey 套件 (kolbi.cz) 正確語法為： SetDefaultBrowser HKLM "<browser name>"
    & $sdb HKLM "Google Chrome"
} else {
    Write-Host "找不到 SetDefaultBrowser，請於安裝完成後手動設定預設瀏覽器。" -ForegroundColor Red
}

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Automation script completed! Here are a few things you need to do manually:"
Write-Host "1. Login to GitHub (open a terminal and run 'gh auth login')"
Write-Host "======================================" -ForegroundColor Cyan
