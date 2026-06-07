@echo off
echo ============================================
echo  HyperBoost - ADB Driver Installer
echo ============================================
echo.
echo Downloading Google USB Driver...
powershell -Command "Invoke-WebRequest -Uri 'https://dl.google.com/android/repository/usb_driver_r13-windows.zip' -OutFile 'usb_driver.zip'"
echo Extracting...
powershell -Command "Expand-Archive -Path 'usb_driver.zip' -DestinationPath '.' -Force"
echo.
echo Please install driver from Device Manager
echo Driver location: %cd%\usb_driver
pause