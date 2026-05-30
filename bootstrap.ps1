# Windows Sandbox 一鍵初始化
# 在全新的 Sandbox 中，以系統管理員身分開啟 PowerShell，貼上以下指令即可：
# powershell -ExecutionPolicy Bypass -File bootstrap.ps1

Set-ExecutionPolicy Bypass -Scope Process -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
irm https://raw.githubusercontent.com/huanzochen/windows-sandbox-init/main/setup.ps1 | iex
