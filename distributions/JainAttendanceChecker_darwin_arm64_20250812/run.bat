@echo off
echo Starting Jain University Attendance Checker...
echo ==============================================

REM Check if Chrome is installed
where chrome >nul 2>nul
if %errorlevel% neq 0 (
    echo Warning: Chrome browser may not be installed!
    echo Please install Chrome from: https://www.google.com/chrome/
    echo Press any key to continue anyway...
    pause
)

REM Run the application
JainAttendanceChecker.exe

echo Program finished. Press any key to close...
pause
