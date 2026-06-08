@echo off
title HyperBoost Ultimate v1.1 - Windows Auto Setup
color 0A
setlocal enabledelayedexpansion

:: =====================================================================
:: HYPERBOOST ULTIMATE v1.1 - WINDOWS AUTO SETUP
:: Tự động cài: Git, Python, ADB, và chạy HyperBoost
:: =====================================================================

echo.
echo ╔══════════════════════════════════════════════════════════╗
echo ║                                                          ║
echo ║    ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗ ██████╗      ║
echo ║    ██║  ██║╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██╔══██╗     ║
echo ║    ███████║ ╚████╔╝ ██████╔╝█████╗  ██████╔╝██████╔╝     ║
echo ║    ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══╝  ██╔══██╗██╔══██╝     ║
echo ║    ██║  ██║   ██║   ██║     ███████╗██║  ██║██████╔╝     ║
echo ║    ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚══════╝╚═╝  ╚═╝╚═════╝      ║
echo ║                                                          ║
echo ║              ULTIMATE EDITION v1.1                        ║
echo ║     Auto Setup: Git + Python + ADB + HyperBoost           ║
echo ╚══════════════════════════════════════════════════════════╝
echo.

:: ==================== KIỂM TRA QUYỀN ADMIN ====================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Can quyen Administrator de cai dat!
    echo [!] Dang yeu cau quyen Admin...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
echo [✓] Dang chay voi quyen Administrator
echo.

:: ==================== SET BIẾN ====================
set "GIT_URL=https://github.com/git-for-windows/git/releases/download/v2.54.0.windows.1/Git-2.54.0-64-bit.exe"
set "PYTHON_URL=https://www.python.org/ftp/python/3.14.5/python-3.14.5-amd64.exe"
set "ADB_URL=https://a.x8top.net/v2106xm/2018/9/11/minimal-adb-and-fastboot.zip"
set "TEMP_DIR=%TEMP%\HyperBoost_Setup"
set "GIT_INSTALLER=%TEMP_DIR%\Git-Installer.exe"
set "PYTHON_INSTALLER=%TEMP_DIR%\Python-Installer.exe"
set "ADB_ZIP=%TEMP_DIR%\adb.zip"
set "ADB_DIR=C:\HyperBoost_ADB"
set "HYPERBOOST_DIR=%USERPROFILE%\HyperBoost"

:: Tạo thư mục tạm
mkdir "%TEMP_DIR%" 2>nul
mkdir "%ADB_DIR%" 2>nul

echo ╔══════════════════════════════════════════════════════════╗
echo ║           BAT DAU CAI DAT HYPERBOOST v1.1               ║
echo ╚══════════════════════════════════════════════════════════╝
echo.

:: ==================== 1. CÀI GIT ====================
echo ┌──────────────────────────────────────────────────────────┐
echo │ [1/5] KIEM TRA & CAI DAT GIT                            │
echo └──────────────────────────────────────────────────────────┘
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Git chua duoc cai dat. Dang tai...
    echo [!] URL: %GIT_URL%
    echo.
    echo [*] Dang tai Git for Windows...
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%GIT_URL%' -OutFile '%GIT_INSTALLER%' -UseBasicParsing}"
    
    if exist "%GIT_INSTALLER%" (
        echo [✓] Tai Git thanh cong!
        echo [*] Dang cai dat Git...
        start /wait "" "%GIT_INSTALLER%" /VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS="icons,ext\ext\shellhere,ext\ext\guihere,gitlfs,assoc,assoc_sh"
        echo [✓] Cai dat Git thanh cong!
    ) else (
        echo [✗] Loi tai Git!
    )
) else (
    echo [✓] Git da duoc cai dat!
    git --version
)
echo.

:: ==================== 2. CÀI PYTHON ====================
echo ┌──────────────────────────────────────────────────────────┐
echo │ [2/5] KIEM TRA & CAI DAT PYTHON                         │
echo └──────────────────────────────────────────────────────────┘
where python >nul 2>&1
if %errorlevel% neq 0 (
    where python3 >nul 2>&1
    if %errorlevel% neq 0 (
        echo [!] Python chua duoc cai dat. Dang tai...
        echo [!] URL: %PYTHON_URL%
        echo.
        echo [*] Dang tai Python...
        powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%PYTHON_URL%' -OutFile '%PYTHON_INSTALLER%' -UseBasicParsing}"
        
        if exist "%PYTHON_INSTALLER%" (
            echo [✓] Tai Python thanh cong!
            echo [*] Dang cai dat Python (co the mat vai phut)...
            start /wait "" "%PYTHON_INSTALLER%" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
            echo [✓] Cai dat Python thanh cong!
            
            :: Refresh PATH
            call :RefreshEnv
        ) else (
            echo [✗] Loi tai Python!
        )
    ) else (
        echo [✓] Python3 da duoc cai dat!
        python3 --version
    )
) else (
    echo [✓] Python da duoc cai dat!
    python --version
)
echo.

:: ==================== 3. CÀI ADB ====================
echo ┌──────────────────────────────────────────────────────────┐
echo │ [3/5] KIEM TRA & CAI DAT ADB                            │
echo └──────────────────────────────────────────────────────────┘
where adb >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] ADB chua duoc cai dat. Dang tai...
    echo [!] URL: %ADB_URL%
    echo.
    echo [*] Dang tai Minimal ADB and Fastboot...
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%ADB_URL%' -OutFile '%ADB_ZIP%' -UseBasicParsing}"
    
    if exist "%ADB_ZIP%" (
        echo [✓] Tai ADB thanh cong!
        echo [*] Dang giai nen vao %ADB_DIR%...
        powershell -Command "Expand-Archive -Path '%ADB_ZIP%' -DestinationPath '%ADB_DIR%' -Force"
        
        :: Copy file vào thư mục gốc
        if exist "%ADB_DIR%\minimal*" (
            for /d %%d in ("%ADB_DIR%\minimal*") do (
                xcopy /E /Y "%%d\*" "%ADB_DIR%\" >nul 2>&1
            )
        )
        
        :: Thêm vào PATH
        echo [*] Dang them ADB vao PATH...
        setx PATH "%PATH%;%ADB_DIR%" /M >nul 2>&1
        
        echo [✓] Cai dat ADB thanh cong!
    ) else (
        echo [✗] Loi tai ADB!
    )
) else (
    echo [✓] ADB da duoc cai dat!
    adb version 2>nul | find "Android"
)
echo.

:: ==================== 4. CÀI PYTHON MODULES ====================
echo ┌──────────────────────────────────────────────────────────┐
echo │ [4/5] CAI DAT PYTHON MODULES                            │
echo └──────────────────────────────────────────────────────────┘
echo [*] Dang cai dat Python modules...
python -m pip install --upgrade pip --quiet 2>nul
python -m pip install requests psutil colorama tqdm --quiet 2>nul
echo [✓] Python modules da san sang!
echo.

:: ==================== 5. CLONE & CHẠY HYPERBOOST ====================
echo ┌──────────────────────────────────────────────────────────┐
echo │ [5/5] TAI & CHAY HYPERBOOST                             │
echo └──────────────────────────────────────────────────────────┘

:: Tìm Git Bash
set "GIT_BASH="
if exist "C:\Program Files\Git\bin\bash.exe" set "GIT_BASH=C:\Program Files\Git\bin\bash.exe"
if exist "C:\Program Files (x86)\Git\bin\bash.exe" set "GIT_BASH=C:\Program Files (x86)\Git\bin\bash.exe"

if "%GIT_BASH%"=="" (
    echo [✗] Khong tim thay Git Bash!
    echo [!] Hay chay thu cong: bash setup.sh
    pause
    exit /b 1
)

:: Clone repo nếu chưa có
if not exist "%HYPERBOOST_DIR%" (
    echo [*] Dang tai HyperBoost tu GitHub...
    git clone https://github.com/gialong7895-lgtm/HyperBoost.git "%HYPERBOOST_DIR%" 2>nul
    
    if exist "%HYPERBOOST_DIR%" (
        echo [✓] Tai HyperBoost thanh cong!
    ) else (
        echo [✗] Loi tai HyperBoost! Kiem tra ket noi mang.
        pause
        exit /b 1
    )
) else (
    echo [✓] HyperBoost da ton tai!
    echo [*] Dang cap nhat...
    cd /d "%HYPERBOOST_DIR%"
    git pull 2>nul
)

echo.
echo ╔══════════════════════════════════════════════════════════╗
echo ║     ✓ CAI DAT HOAN TAT! DANG CHAY HYPERBOOST...        ║
echo ╚══════════════════════════════════════════════════════════╝
echo.
echo [*] Dang khoi dong HyperBoost Ultimate v1.1...
echo.

:: Chạy HyperBoost
cd /d "%HYPERBOOST_DIR%"
"%GIT_BASH%" -c "cd \"%HYPERBOOST_DIR%\" && bash setup.sh"

pause
exit /b 0

:: ==================== HÀM REFRESH ENVIRONMENT ====================
:RefreshEnv
    echo [*] Dang cap nhat bien moi truong...
    :: Gửi thông báo cập nhật environment
    powershell -Command "& {[Environment]::SetEnvironmentVariable('PATH', [Environment]::GetEnvironmentVariable('PATH', 'Machine'), 'Machine')}"
    :: Không thể reload hoàn toàn trong script, yêu cầu restart
    echo [!] Vui long khoi dong lai CMD sau khi cai dat hoan tat.
goto :eof