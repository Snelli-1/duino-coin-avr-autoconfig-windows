@echo off
setlocal EnableExtensions DisableDelayedExpansion
chcp 65001 >nul

rem Hordozhato indito: mindig a BAT aktualis mappajat hasznalja rootkent.
set "ROOT_DIR=%~dp0"
set "MINER_DIR=%ROOT_DIR%Duino-Coin AVR Miner 4.3"
set "PS_SCRIPT=%ROOT_DIR%Update-DuinoPorts.ps1"
set "SETUP_FILE=%ROOT_DIR%Setup_Settings.txt"

if not exist "%PS_SCRIPT%" (
  echo HIBA: Nem talalhato: "%PS_SCRIPT%"
  pause
  exit /b 30
)
if not exist "%SETUP_FILE%" (
  echo HIBA: Nem talalhato: "%SETUP_FILE%"
  pause
  exit /b 31
)
if not exist "%MINER_DIR%\Settings.cfg" (
  echo HIBA: Nem talalhato: "%MINER_DIR%\Settings.cfg"
  echo.
  echo Elvart szerkezet:
  echo   [ROOT]\Frissit_LGT8F328P_portok.bat
  echo   [ROOT]\Update-DuinoPorts.ps1
  echo   [ROOT]\Setup_Settings.txt
  echo   [ROOT]\Duino-Coin AVR Miner 4.3\Settings.cfg
  pause
  exit /b 32
)

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%" -MinerDir "%MINER_DIR%" -SetupFile "%SETUP_FILE%" %*
set "RC=%ERRORLEVEL%"

echo.
if "%RC%"=="0" echo KESZ: A Settings.cfg dinamikusan frissult.
if not "%RC%"=="0" echo HIBA: A frissites nem sikerult. Hibakod: %RC%
pause
exit /b %RC%
