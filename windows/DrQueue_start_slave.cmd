@REM ~ Put these file in %APPDATA%\DrQueue_env
cd /d "%~dp0Scripts"
call activate.bat
echo on
@REM ~ Please create and change 'set_settings.cmd' for your needs!
call "%~dp0\set_settings.cmd"
python.exe drqueue --verbose --no-ssh slave
pause