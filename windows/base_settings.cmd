@REM ~ Put these file in %APPDATA%\DrQueue_env
echo -------------------------------------------------------------
set DRQUEUE_POOL="DrQueue pool 1"

set DRQUEUE_MASTER=192.168.0.0
set SHARE_NAME=DrQueue
set SHARE_DRIVE=Q:

set DRQUEUE_ROOT=%SHARE_DRIVE%\
set IPYTHONDIR=%DRQUEUE_ROOT%\ipython

set LOCAL_SETTINGS=%APPDATA%\DrQueue_settings.cmd
if exist %LOCAL_SETTINGS% (
    echo.
    echo Load you local settings file from:
    echo %LOCAL_SETTINGS%
    call %LOCAL_SETTINGS%
) else (
    echo Info: No local settings file exist:
    echo %LOCAL_SETTINGS%
)
echo.
echo DRQUEUE_POOL...: %DRQUEUE_POOL%
echo DRQUEUE_MASTER.: %DRQUEUE_MASTER%
echo SHARE_NAME.....: %SHARE_NAME%
echo SHARE_DRIVE....: %SHARE_DRIVE%
echo DRQUEUE_ROOT...: %DRQUEUE_ROOT%
echo IPYTHONDIR.....: %IPYTHONDIR%
echo -------------------------------------------------------------