@REM ~ Put these file in %APPDATA%\DrQueue_env

cd /d "%~dp0Scripts"

call activate.bat

echo on

python.exe drqueue --help >drqueue_help.txt
start drqueue_help.txt
pause