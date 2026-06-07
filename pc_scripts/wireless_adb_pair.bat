@echo off
echo HyperBoost - Wireless ADB Pairing
echo Make sure USB debugging is enabled
echo.
set /p IP="Enter device IP:Port (e.g., 192.168.1.10:5555): "
adb connect %IP%
adb devices
pause