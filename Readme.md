# Windows Sandbox 自動化初始化工具

這是一個用來快速初始化 Windows Server / Windows 10/11 沙盒環境的腳本。它能幫你省下手動安裝常用軟體及環境配置的時間。

## 功能列表

**全自動完成：**
- 安裝 Chocolatey 套件管理器
- 安裝必備軟體：VSCode, Google Chrome, Git, nvm, Notion, GitHub CLI
- 設定 Git 使用者名稱與信箱 (`tc`)
- 設定 Windows 工作列為「永不合併」並重啟 Explorer
- 設定 VSCode 預設終端機為 Git Bash
- 設定 VSCode 關閉 Workspace Trust 提示

**半自動輔助：**
- 自動打開 Windows「預設應用程式」設定頁面
- 自動打開 AntiGravity 下載頁面

## 使用方式

1. 將本專案資料夾複製或下載到你的 Windows Sandbox 中。
2. 對著 `setup.ps1` 點擊 **右鍵** -> 選擇 **Run with PowerShell**。
   *(或者，打開以系統管理員身分執行的 PowerShell，並執行該檔案 `.\setup.ps1`)*
3. 等待幾分鐘讓腳本跑完，中途會自動安裝所需軟體。
4. 腳本結束時，會自動彈出設定頁面與瀏覽器，請依據畫面提示完成最後的步驟：
   - 設定預設瀏覽器為 Chrome
   - 下載安裝 AntiGravity
   - 登入 Notion
   - 開啟終端機輸入 `gh auth login` 登入 GitHub
