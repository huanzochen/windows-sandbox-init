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
2. 直接點擊兩下 `start.cmd`。
   *(它會自動獲取管理員權限，並繞過 PowerShell 的執行限制，去執行 `setup.ps1`)*
3. 等待幾分鐘讓腳本跑完，中途會自動安裝所需軟體、下載並設定相關環境。
4. 腳本結束時，請依據畫面提示完成最後的手動步驟：
   - 如果 AntiGravity 尚未安裝，請至暫存資料夾手動執行。
   - 登入 Notion
   - 登入 GitHub (打開終端機輸入 `gh auth login`)
