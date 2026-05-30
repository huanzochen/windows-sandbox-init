# Windows Sandbox 自動化初始化工具

這是一個用來快速初始化 Windows Server / Windows 10/11 沙盒環境的腳本。它能幫你省下手動安裝常用軟體及環境配置的時間。

## 🚀 快速開始（複製貼上這一行就好）

以**系統管理員身分**開啟 PowerShell，貼上以下指令：

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; irm https://raw.githubusercontent.com/huanzochen/windows-sandbox-init/main/setup.ps1 | iex
```

> 不需要事先安裝任何東西，PowerShell 是 Windows 內建的。

## 功能列表

**全自動完成：**
- 安裝 Chocolatey 套件管理器
- 安裝必備軟體：VSCode, Google Chrome, Git, NVM, Notion, GitHub CLI, AntiGravity
- 設定 Git 使用者名稱與信箱 (`tc`)
- 設定 Windows 工作列為「永不合併」並重啟 Explorer
- 設定 VSCode 預設終端機為 Git Bash
- 設定 VSCode 關閉 Workspace Trust 提示
- 設定 VSCode 標籤頁自動換行

**腳本完成後需手動操作：**
- 設定 Chrome 為預設瀏覽器（開啟 Chrome 後點擊「設為預設」）
- 登入 Notion
- 登入 GitHub（開啟新終端機輸入 `gh auth login`）

## 使用方式

### 方式一：遠端一鍵執行（推薦）

適用於透過 browser 連線的遠端 Sandbox，不需要 Git clone。

1. 開啟 Edge，進入本頁面 `github.com/huanzochen/windows-sandbox-init`
2. 複製上方的 PowerShell 指令
3. 以系統管理員身分開啟 PowerShell，貼上執行

### 方式二：本地執行

適用於已經把專案 clone 到本地的情況。

1. 直接點擊兩下 `start.cmd`
2. 它會自動獲取管理員權限並執行 `setup.ps1`

## 手動設定指南

如果腳本無法執行，請參考 [manual-setup-guide.md](./manual-setup-guide.md) 逐步手動完成設定。
