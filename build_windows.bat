@echo off
REM Windows Build Script for Jain University Attendance Checker
REM Run this script on a Windows machine to build the executable

echo Jain University Attendance Checker - Windows Build Script
echo ==========================================================

REM Check if Python is installed
python --version >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python from: https://www.python.org/downloads/
    echo Make sure to check "Add Python to PATH" during installation
    pause
    exit /b 1
)

REM Check if Git is installed
git --version >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: Git is not installed or not in PATH
    echo Please install Git from: https://git-scm.com/download/win
    pause
    exit /b 1
)

REM Check if Chrome is installed
if exist "C:\Program Files\Google\Chrome\Application\chrome.exe" (
    echo Chrome found: C:\Program Files\Google\Chrome\Application\chrome.exe
) else if exist "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" (
    echo Chrome found: C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
) else (
    echo WARNING: Chrome browser not found!
    echo Please install Chrome from: https://www.google.com/chrome/
    echo Press any key to continue anyway...
    pause
)

echo.
echo Setting up build environment...
echo ==============================

REM Create virtual environment
echo Creating virtual environment...
python -m venv attendance_env_windows
if %errorlevel% neq 0 (
    echo ERROR: Failed to create virtual environment
    pause
    exit /b 1
)

REM Activate virtual environment
echo Activating virtual environment...
call attendance_env_windows\Scripts\activate.bat

REM Upgrade pip
echo Upgrading pip...
python -m pip install --upgrade pip

REM Install dependencies
echo Installing dependencies...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo ERROR: Failed to install dependencies
    pause
    exit /b 1
)

REM Install PyInstaller
echo Installing PyInstaller...
pip install pyinstaller
if %errorlevel% neq 0 (
    echo ERROR: Failed to install PyInstaller
    pause
    exit /b 1
)

REM Clean previous builds
echo Cleaning previous builds...
if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
if exist __pycache__ rmdir /s /q __pycache__

REM Build the executable
echo Building Windows executable...
echo =============================
pyinstaller attendance_checker.spec --clean
if %errorlevel% neq 0 (
    echo ERROR: Build failed!
    echo Check the output above for errors
    pause
    exit /b 1
)

REM Check if build was successful
if exist "dist\JainAttendanceChecker.exe" (
    echo.
    echo Build successful!
    echo ================
    
    REM Get file size
    for %%A in ("dist\JainAttendanceChecker.exe") do (
        set size=%%~zA
        set /a sizeMB=!size!/1024/1024
    )
    
    echo Executable created: dist\JainAttendanceChecker.exe
    echo File size: %sizeMB% MB (approximately)
    echo.
    
    REM Create distribution package
    echo Creating distribution package...
    set "date=%date:~-4%%date:~4,2%%date:~7,2%"
    set "packageName=JainAttendanceChecker_windows_amd64_%date%"
    set "distDir=distributions\%packageName%"
    
    if not exist distributions mkdir distributions
    if exist "%distDir%" rmdir /s /q "%distDir%"
    mkdir "%distDir%"
    
    REM Copy files
    copy "dist\JainAttendanceChecker.exe" "%distDir%\"
    copy "README_DISTRIBUTION.md" "%distDir%\README.md"
    if exist "REQUIREMENTS.md" copy "REQUIREMENTS.md" "%distDir%\"
    if exist "BUILD_EXECUTABLE.md" copy "BUILD_EXECUTABLE.md" "%distDir%\"
    if exist "WINDOWS_BUILD_OPTIONS.md" copy "WINDOWS_BUILD_OPTIONS.md" "%distDir%\"
    
    REM Create Windows-specific run script
    (
        echo @echo off
        echo echo Starting Jain University Attendance Checker...
        echo echo ==============================================
        echo.
        echo REM Check if Chrome is installed
        echo where chrome ^>nul 2^>nul
        echo if %%errorlevel%% neq 0 ^(
        echo     echo Warning: Chrome browser may not be installed!
        echo     echo Please install Chrome from: https://www.google.com/chrome/
        echo     echo Press any key to continue anyway...
        echo     pause
        echo ^)
        echo.
        echo REM Run the application
        echo JainAttendanceChecker.exe
        echo.
        echo echo Program finished. Press any key to close...
        echo pause
    ) > "%distDir%\run.bat"
    
    REM Create version info
    (
        echo Jain University Attendance Checker - Windows Build
        echo ==================================================
        echo.
        echo Build Information:
        echo - Version: 1.0.0
        echo - Build Date: %date% %time%
        echo - Platform: Windows ^(amd64^)
        echo - Architecture: x86_64
        echo - Built on: %COMPUTERNAME%
        echo.
        echo Compatibility:
        echo ✅ Windows 10 ^(64-bit^)
        echo ✅ Windows 11 ^(64-bit^)
        echo ❌ Windows 7/8 ^(not supported^)
        echo ❌ 32-bit Windows ^(not supported^)
        echo.
        echo Package Contents:
        echo - JainAttendanceChecker.exe ^(main executable^)
        echo - README.md ^(user guide^)
        echo - REQUIREMENTS.md ^(system requirements^)
        echo - run.bat ^(launcher script^)
        echo - VERSION.txt ^(this file^)
    ) > "%distDir%\VERSION.txt"
    
    echo.
    echo Distribution package created!
    echo ============================
    echo Package: %packageName%
    echo Location: %distDir%\
    echo.
    echo Contents:
    echo   ├── JainAttendanceChecker.exe
    echo   ├── README.md
    echo   ├── REQUIREMENTS.md
    echo   ├── run.bat
    echo   └── VERSION.txt
    echo.
    echo Ready for distribution!
    echo.
    echo To test the executable:
    echo   cd "%distDir%"
    echo   run.bat
    echo.
    echo To distribute:
    echo   1. Zip the "%distDir%" folder
    echo   2. Share the zip file
    echo   3. Recipients just need to extract and run!
    
) else (
    echo.
    echo Build failed!
    echo =============
    echo The executable was not created. Check the output above for errors.
)

echo.
echo Press any key to exit...
pause

REM Deactivate virtual environment
call deactivate
