@echo off
@REM ~ Put these file in %APPDATA%\DrQueue_env
title %~f0
set PROMPT=-$G
cd /d "%~dp0"

call Scripts\activate.bat
call set_settings.cmd

python "src\drqueueipython\setup.py" create_drqueue_dirs --basepath=%DRQUEUE_ROOT%
pause
