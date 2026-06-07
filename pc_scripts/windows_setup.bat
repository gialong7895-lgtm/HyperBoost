@echo off
title HyperBoost Windows Setup
echo ============================================
echo  HyperBoost Ultimate v5.0 - Windows Setup
echo ============================================
echo.
echo [1] Checking Git...
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Git...
    winget install --id Git.Git -e
)
echo [2] Checking ADB...
where adb >nul 2>&1
if %errorlevel% neq 0 (
    echo Downloading Platform Tools...
    powershell -Command "Invoke-WebRequest -Uri 'https://dl.google.com/android/repository/platform-tools-latest-windows.zip' -OutFile 'platform-tools.zip'"
    powershell -Command "Expand-Archive -Path 'platform-tools.zip' -DestinationPath '.' -Force"
    set PATH=%PATH%;%cd%\platform-tools
)
echo [3] Starting HyperBoost...
"C:\Program Files\Git\bin\bash.exe" -c "cd '%cd%' && bash setup.sh"
pause