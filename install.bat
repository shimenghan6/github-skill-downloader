@echo off
setlocal enabledelayedexpansion
chcp 65001 >/dev/null 2>&1
title github-skill-downloader 安装

echo.
echo   =============================================
echo    github-skill-downloader — GitHub 离线下载
echo   =============================================
echo.

set "DIR=%USERPROFILE%\.claude\skills\github-skill-downloader"
if not exist "!DIR!" mkdir "!DIR!"

:: From local ZIP (offline)
if exist "%~dp0SKILL.md" (
    copy /Y "%~dp0SKILL.md" "!DIR!\SKILL.md" >/dev/null 2>&1
    echo   [完成] 本地 SKILL.md 已安装
) else (
    :: From GitHub (online)
    set "URL=https://raw.githubusercontent.com/shimenghan6/github-skill-downloader/master/SKILL.md"
    echo   正在从 GitHub 下载...
    curl -fsSL "!URL!" -o "!DIR!\SKILL.md"
    if !errorlevel! equ 0 (
        echo   [完成] SKILL.md 已下载安装
    ) else (
        echo   [错误] 下载失败，请检查网络
        pause
        exit /b 1
    )
)

echo.
echo   =============================================
echo    安装完成！重启 Claude Code 即可使用。
echo   =============================================
echo.

endlocal
pause
