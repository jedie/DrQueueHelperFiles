@REM ~ Put these file in %APPDATA%\DrQueue_env
@echo off
title %~f0
set PROMPT=-$G

set SETTINGS_FILE=base_settings.cmd
echo Read your settings from: %SETTINGS_FILE%
call %SETTINGS_FILE%

if not exist %LOCAL_SETTINGS% (
    echo @REM Your local DrQueue settings file>%LOCAL_SETTINGS%
    echo @REM Please change if for your needs!>>%LOCAL_SETTINGS%
    echo.>>%LOCAL_SETTINGS%
    echo set DRQUEUE_MASTER=192.168.0.0>>%LOCAL_SETTINGS%
)
echo on
@REM FIXME: How to use the default editor?!?
notepad.exe %LOCAL_SETTINGS%
@pause