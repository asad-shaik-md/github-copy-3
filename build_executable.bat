@echo off
REM Build script for Windows
REM Jain University Attendance Checker - Windows Build Script

echo Jain University Attendance Checker - Windows Build Script
echo ==========================================================

REM Activate virtual environment (Windows)
echo Activating virtual environment...
call attendance_env\Scripts\activate.bat

REM Install dependencies
echo Installing/updating dependencies...
pip install -r requirements.txt
pip install pyinstaller

REM Clean previous builds
echo Cleaning previous builds...
if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
if exist __pycache__ rmdir /s /q __pycache__

REM Build the executable
echo Building executable...
pyinstaller attendance_checker.spec --clean

REM Check if build was successful
if exist "dist\JainAttendanceChecker.exe" (
    echo.
    echo Build successful!
    echo Executable created at: dist\JainAttendanceChecker.exe
    echo.
    echo To run the executable:
    echo   dist\JainAttendanceChecker.exe
    echo.
    echo To distribute:
    echo   Copy the entire 'dist' folder to target machine
    echo   Make sure Chrome browser is installed on target machine
) else (
    echo.
    echo Build failed!
    echo Check the output above for errors
    pause
    exit /b 1
)

pause
