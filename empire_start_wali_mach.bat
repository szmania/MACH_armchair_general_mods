@echo Off
setlocal enabledelayedexpansion


SET empire_dir=%~dp0
SET "package_script_path=%userprofile%\AppData\Roaming\The Creative Assembly\Empire\scripts\user.empire_script.txt"

SET log_file_path=!empire_dir!empire_start_wali_mach.log

echo Deleting log file "!log_file_path!" >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" > !log_file_path!

for /f "tokens=*" %%G in ('dir /b /a:d "!empire_dir!data\campaigns\*"') DO (call :campaign_scripting %%G)

if not exist "VDM_Start.bat" (
    echo Preparing to start WALI >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!

    echo Changing directory to ./data/WALI >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
    cd /d "%~dp0\data\WALI"

    echo Launching WALI >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
    start launch.bat 2>&1

    echo Changing directory to Empire directory "%~dp0" >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
    cd /d "%~dp0"
) else (
 	echo No need to start WALI because VadAntS Disease Mod is installed >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
)

SET process_name=
if exist Imperial.Splendour.exe (
    echo Starting Imperial Splendour Launcher "Imperial.Splendour.exe" >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
    start Imperial.Splendour.exe > output.log
    SET exe_name=Imperial.Splendour.exe
    SET process_name=javaw.exe
) else if exist ACW\\ACW3.exe (
    echo Starting ACW Brother vs. Brother Launcher "ACW\\ACW3.exe" >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
    start ACW\\ACW3.exe > output.log
    SET exe_name=ACW3.exe
    SET process_name=ACW3.exe
) else if exist "data\\DME\\DME Platinum.exe" (
    echo Starting Darth Mod Empire Platinum Launcher "data\\DME\\DME Platinum.exe" >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
    start "data\\DME\\DME Platinum.exe" > output.log
    SET exe_name="data\\DME\\DME Platinum.exe"
    SET process_name="DME Platinum.exe"
) else if exist "VDM_Start.bat" (
    echo Starting VadAntS Disease Mod Launcher "VDM_Start.bat" >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
    start VDM_Start.bat > output.log
    SET exe_name=VDM_Start.bat
    SET process_name=Empire.exe
) else (
	echo Starting Empire Total War "Empire.exe" >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
	start Empire.exe > output.log
	SET exe_name=Empire.exe
	SET process_name=Empire.exe
)


echo Checking if "!exe_name!" is still running. If not, kill WALI. >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!

ping -n 5 127.0.0.1 > nul

:STILLRUNNING

cd /d "%~dp0"

ping -n 5 127.0.0.1 > nul

tasklist /FI "IMAGENAME eq !process_name!" | find /i "!process_name!"
IF NOT ERRORLEVEL 1 (GOTO STILLRUNNING) 
IF ERRORLEVEL 1 (GOTO NOTRUNNING)


:NOTRUNNING
echo "!exe_name!" is no longer running. Shutting down WALI and cleaning up Machiavelli's Mods >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!

for /f "tokens=*" %%G in ('dir /b /a:d "!empire_dir!data\campaigns\*"') DO (call :campaign_scripting_restore %%G)

echo Killing WALI processes. >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
TASKKILL /F /IM launch.bat /IM Launcher_ETW.exe /IM "WALI_Engine.exe" /IM "WALI_Engine.exe *32"

echo Successfully finished. >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!

echo Deleting file "!empire_dir!_" >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
del "!empire_dir!_"

TASKKILL /F /IM "cmd.exe"
pause
exit





REM FUNCTION SECTION

:campaign_scripting
SETLOCAL
SET campaign_dir=%~nx1
SET scripting_lua="!empire_dir!data\campaigns\%campaign_dir%\scripting.lua"
SET scripting_lua_backup="!empire_dir!data\campaigns\%campaign_dir%\scripting.lua.bak"

echo Preparing campaign directory "%campaign_dir%" for MACH Mods >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!

set "process=y"
if "%campaign_dir%"=="episodic_1" (
                                      echo This is not a compatible campaign directory "%campaign_dir%" for MACH Mods >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
                                      exit /b
                                  )
if "%campaign_dir%"=="episodic_3" (
                                      echo This is not a compatible campaign directory "%campaign_dir%" for MACH Mods >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
                                      exit /b
                                  )
if "%campaign_dir%"=="episodic_5" (
                                      echo This is not a compatible campaign directory "%campaign_dir%" for MACH Mods >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
                                      exit /b
                                  )


echo Preparing %scripting_lua% >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!

echo Backing up scripting.lua files for "%campaign_dir%" >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
copy %scripting_lua_backup% %scripting_lua%
copy %scripting_lua% %scripting_lua_backup%
del /f %scripting_lua%

echo Adding MACH mod to scripting.lua files for "%campaign_dir%" >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
echo --START Machiavelli's Mods > %scripting_lua%
echo mach = require "WALI/mach" >> %scripting_lua%
echo mach_lib = require "WALI/mach_lib" >> %scripting_lua%
echo mach_lib.create_mach_lua_log() >> %scripting_lua%
echo mach_lib.update_mach_lua_log("Finished creating MACH log.") >> %scripting_lua%
echo function error_catch_function() >> %scripting_lua%
echo mach.initialize_mach() >> %scripting_lua%
echo --END Machiavelli's Mods >> %scripting_lua%
echo.>> %scripting_lua%
type "!empire_dir!\data\campaigns\main\scripting.lua.bak" >> %scripting_lua%

echo.>> %scripting_lua%
echo --START Machiavelli's Mods >> %scripting_lua%
echo end >> %scripting_lua%
echo val,err = pcall(error_catch_function) >> %scripting_lua%
echo mach_lib.update_mach_lua_log(err.."\n") >> %scripting_lua%
echo --END Machiavelli's Mods >> %scripting_lua%

echo Finished preparing campaign directory "%campaign_dir%" for MACH Mods >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!

ENDLOCAL
exit /b



:campaign_scripting_restore
SETLOCAL
SET campaign_dir=%~nx1
SET scripting_lua="!empire_dir!data\campaigns\%campaign_dir%\scripting.lua"
SET scripting_lua_backup="!empire_dir!data\campaigns\%campaign_dir%\scripting.lua.bak"

set "process=y"
if "%campaign_dir%"=="episodic_1" (
    echo This is not a compatible campaign directory "%campaign_dir%" for MACH Mods >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
    exit /b
)
if "%campaign_dir%"=="episodic_3" (
    echo This is not a compatible campaign directory "%campaign_dir%" for MACH Mods >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
    exit /b
)
if "%campaign_dir%"=="episodic_5" (
  echo This is not a compatible campaign directory "%campaign_dir%" for MACH Mods >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
  exit /b
)


echo Restoring %scripting_lua% >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
echo Restoring backup scripting.lua files in "%campaign_dir%". >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!
del /f %scripting_lua%
rename %scripting_lua_backup% scripting.lua
echo Finished restoring backup scripting.lua files in "%campaign_dir%". >"!empire_dir!_" && type "!empire_dir!_" && type "!empire_dir!_" >> !log_file_path!

ENDLOCAL
exit /b
