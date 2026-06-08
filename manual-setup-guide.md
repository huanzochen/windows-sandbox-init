# 🛠️ Windows Sandbox 手動設定指南

> 本文件對應 `setup.ps1` 自動化腳本的所有步驟。
> 當腳本因為任何原因無法執行時，可以按照以下步驟手動完成環境設定。

---

## 目錄

1. [安裝 Chocolatey](#1-安裝-chocolatey)
2. [安裝必備軟體](#2-安裝必備軟體)
3. [Git 設定](#3-git-設定)
4. [工作列設定](#4-工作列設定)
5. [VSCode 設定](#5-vscode-設定)
6. [Chrome 設為預設瀏覽器](#6-chrome-設為預設瀏覽器)
7. [腳本完成後的手動步驟](#7-腳本完成後的手動步驟)

---

## 1. 安裝 Chocolatey

Chocolatey 是 Windows 的套件管理工具（類似 macOS 的 Homebrew），後續所有軟體都透過它來安裝。

**手動操作：**

1. 以「**系統管理員身分**」開啟 PowerShell
2. 貼上以下指令並執行：

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

3. 安裝完成後，輸入 `choco -v` 確認版本號有正確顯示

> **💡 注意：** 如果不想用 Chocolatey，也可以分別手動去各軟體官網下載安裝，見第 2 步的備用連結。

---

## 2. 安裝必備軟體

腳本會一次安裝以下 7 個軟體：

| 軟體 | Chocolatey 套件名 | 手動下載連結 |
|------|-------------------|-------------|
| Visual Studio Code | `vscode` | https://code.visualstudio.com/download |
| Google Chrome | `googlechrome` | https://www.google.com/chrome/ |
| Git | `git` | https://git-scm.com/downloads/win |
| NVM (Node 版本管理) | `nvm` | https://github.com/coreybutler/nvm-windows/releases |
| Notion | `notion` | https://www.notion.com/desktop |
| GitHub CLI | `gh` | https://cli.github.com/ |
| AntiGravity | `antigravity` | https://antigravity.google/download |

**用 Chocolatey 一鍵安裝（推薦）：**

```powershell
choco install vscode googlechrome git nvm notion gh antigravity -y --ignore-checksums
```

> **💡 備註：**
> - `-y` 代表自動同意所有提示，不需要手動按 Y
> - `--ignore-checksums` 用來避免 Chrome 等軟體因為校驗碼過時而安裝失敗
> - 如果只需要安裝其中幾個，把不需要的套件名從指令中移除即可

---

## 3. Git 設定

設定 Git 的全域使用者名稱和 Email，這樣才能正常 `git commit` 和 `git push`。

**手動操作：**

```bash
git config --global user.email "tc"
git config --global user.name "tc"
```

**驗證設定是否成功：**

```bash
git config --global user.name
# 應該輸出：tc

git config --global user.email
# 應該輸出：tc
```

> **⚠️ 注意：** 如果是剛透過 Chocolatey 裝完 Git，必須先**重新開啟終端機**（或執行以下指令重新載入 PATH），否則系統會找不到 `git` 指令：
>
> ```powershell
> Import-Module "$env:ProgramData\chocolatey\helpers\chocolateyProfile.psm1"
> Update-SessionEnvironment
> ```

---

## 4. 工作列設定

將 Windows 工作列的按鈕設為「**永不合併**」，這樣每個視窗都會獨立顯示在工作列上，方便切換。

**手動操作（PowerShell）：**

```powershell
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Value 2
Stop-Process -Name explorer -Force
```

> **💡 或者手動在 GUI 操作：**
> 1. 右鍵點擊工作列 → 工作列設定
> 2. 找到「合併工作列按鈕」→ 選擇「永不」

---

## 5. VSCode 設定

腳本會自動寫入以下三項設定到 VSCode 的 `settings.json`：

| 設定項 | 值 | 說明 |
|--------|-----|------|
| `terminal.integrated.defaultProfile.windows` | `Git Bash` | 將 VSCode 內建終端機預設為 Git Bash |
| `security.workspace.trust.enabled` | `false` | 關閉「工作區信任」彈窗，不會再問你信不信任 |
| `workbench.editor.wrapTabs` | `true` | 開啟標籤頁自動換行，開太多檔案時不會擠在同一排 |

**手動操作：**

1. 開啟 VSCode
2. 按 `Ctrl + ,` 打開設定
3. 點右上角的「**Open Settings (JSON)**」圖示（📄 小圖示）
4. 確保 JSON 裡包含以下內容：

```json
{
    "terminal.integrated.defaultProfile.windows": "Git Bash",
    "security.workspace.trust.enabled": false,
    "workbench.editor.wrapTabs": true
}
```

> **💡 settings.json 的檔案路徑：**
> `%APPDATA%\Code\User\settings.json`

---

## 6. Chrome 設為預設瀏覽器

> **⚠️ 此步驟目前無法自動化。**
> 原本腳本使用的第三方工具 (DanTup/SetDefaultBrowser) 已被原作者刪除，且微軟現在嚴格限制第三方程式更改預設瀏覽器。

**手動操作：**

1. 開啟 Chrome
2. Chrome 頂端通常會顯示「Chrome 不是您的預設瀏覽器」的提示列
3. 點擊「**設為預設**」
4. 系統會跳轉到 Windows 的「預設應用程式」設定頁面
5. 找到「網頁瀏覽器」→ 選擇「**Google Chrome**」

---

## 7. 腳本完成後的手動步驟

無論是跑完腳本還是手動設定完，以下幾件事都需要你親自操作：

### ✅ 登入 Notion

- 開啟 Notion 應用程式
- 輸入你的帳號密碼登入

### ✅ 登入 GitHub CLI

- 開啟一個**新的**終端機（確保 PATH 已更新）
- 執行以下指令並照著提示完成登入：

```bash
gh auth login
```

- 建議選擇：
  - Account: **GitHub.com**
  - Protocol: **HTTPS**
  - Authenticate: **Login with a web browser**

### ✅ 設定 Chrome 為預設瀏覽器

- 見 [第 6 步](#6-chrome-設為預設瀏覽器)

---

## 附錄：快速參考指令

如果你只是要快速複製貼上，以下是所有指令的精簡版：

```powershell
# 安裝 Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# 安裝所有軟體
choco install vscode googlechrome git nvm notion gh antigravity -y --ignore-checksums

# 重新載入環境變數
Import-Module "$env:ProgramData\chocolatey\helpers\chocolateyProfile.psm1"
Update-SessionEnvironment

# Git 設定
git config --global user.email "tc"
git config --global user.name "tc"

# 工作列永不合併
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Value 2
Stop-Process -Name explorer -Force

# 登入 GitHub
gh auth login
```
