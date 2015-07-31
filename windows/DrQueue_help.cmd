@echo off
@REM ~ Put these file in %APPDATA%\DrQueue_env
title %~f0
set PROMPT=-$G
cd /d "%~dp0"

call Scripts\activate.bat

echo on
python.exe drqueue --help >drqueue_help.txt
start drqueue_help.txt
pause