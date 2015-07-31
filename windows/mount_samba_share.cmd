@REM ~ Put these file in %APPDATA%\DrQueue_env
@echo off
title %~f0
set PROMPT=-$G

call base_settings.cmd

set SHARE=\\%DRQUEUE_MASTER%\%SHARE_NAME%

ping %DRQUEUE_MASTER% -n 1
if NOT "%errorlevel%"=="0" (
    call:error_msg "ping %DRQUEUE_MASTER% failed" %errorlevel% "%~0"
)
echo.
echo Ping, ok.
echo.
echo Try to access: %SHARE%
dir %SHARE% >NUL
if NOT "%errorlevel%"=="0" (
    call:error_msg "access %SHARE% failed" %errorlevel% "%~0"
)
echo Access, ok.
echo.

echo mount samba share:
if exist %SHARE_DRIVE%\ (
    echo destination %SHARE_DRIVE% already exist!
    echo unmount?
    echo on
    net use %SHARE_DRIVE% /delete
    @echo off
)
echo on
net use %SHARE_DRIVE% %SHARE% /PERSISTENT:YES
@echo off
if NOT "%errorlevel%"=="0" (
    call:error_msg "mounting failed :(" %errorlevel% "%~0"
)
explorer %SHARE_DRIVE%
pause
goto:eof

:error_msg
    echo.
    echo Error: %1
    echo (Errorlevel: %2)
    echo.
    echo Maybe change your settings!
    echo.
    pause
    exit
goto:eof