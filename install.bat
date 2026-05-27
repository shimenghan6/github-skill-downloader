@echo off
set SKILL=github-skill-downloader
set DIR=%USERPROFILE%\.claude\skills\%SKILL%
set URL=https://raw.githubusercontent.com/shimenghan6/%SKILL%/master/SKILL.md

echo 安装 %SKILL% ...
if not exist "%DIR%" mkdir "%DIR%"
curl -fsSL "%URL%" -o "%DIR%\SKILL.md"
echo 完成。重启 Claude Code 即可使用。
pause
