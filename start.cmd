@echo off
chcp 65001 >nul
echo 正在請求管理員權限並啟動自動化腳本...
powershell -Command "Start-Process powershell -ArgumentList '-NoExit -NoProfile -ExecutionPolicy Bypass -File \"%~dp0setup.ps1\"' -Verb RunAs"
