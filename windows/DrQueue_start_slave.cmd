@echo off
@REM ~ Put these file in %APPDATA%\DrQueue_env
title %~f0
set PROMPT=-$G
cd /d "%~dp0"

call Scripts\activate.bat
call base_settings.cmd

echo on
python.exe Scripts\drqueue slave --verbose --no-ssh
@pause