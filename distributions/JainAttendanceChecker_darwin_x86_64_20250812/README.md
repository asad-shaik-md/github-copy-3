# Distribution Package for Jain University Attendance Checker

## What's in this package?

This package contains a standalone executable version of the Jain University Attendance Checker that can run on any computer without requiring Python installation.

### Files included:
- `JainAttendanceChecker` (or `JainAttendanceChecker.exe` on Windows) - The main executable
- `README_DISTRIBUTION.md` - This file
- `REQUIREMENTS.md` - System requirements

## Quick Start

### Prerequisites (Target Computer):
1. **Chrome browser must be installed** - Download from https://www.google.com/chrome/
2. **Internet connection** - Required to access Jain University portal
3. **No Python installation needed** - Everything is bundled in the executable

### Running the application:

#### On macOS/Linux:
1. Open Terminal
2. Navigate to the folder containing the executable
3. Run: `./JainAttendanceChecker`

#### On Windows:
1. Double-click `JainAttendanceChecker.exe`
2. Or run from Command Prompt: `JainAttendanceChecker.exe`

## How it works

1. **Launch**: The program opens Chrome browser automatically
2. **Manual Login**: You'll need to manually:
   - Enter your College ID
   - Enter your Date of Birth  
   - Solve the CAPTCHA
   - Click Login
3. **Automatic Processing**: Once logged in, the program automatically:
   - Navigates to attendance page
   - Extracts attendance data for all subjects
   - Calculates percentages
   - Shows detailed results

## Features

- ✅ **Fully automated** - No need to manually navigate through pages
- ✅ **Standalone** - Works without Python installation
- ✅ **Cross-platform** - Works on Windows, macOS, and Linux
- ✅ **Real-time results** - Shows attendance percentage for each subject
- ✅ **Color-coded status** - Green/Yellow/Red based on attendance levels
- ✅ **Detailed breakdown** - Shows conducted vs attended classes

## Attendance Status Levels

- 🟢 **Good (75%+)**: Attendance is sufficient
- 🟡 **Warning (65-74%)**: Needs attention
- 🔴 **Critical (<65%)**: Urgent action required

## Troubleshooting

### "Chrome not found" error:
- Install Chrome browser from https://www.google.com/chrome/
- Restart the application

### "Permission denied" error (macOS):
1. Right-click the executable → Open
2. Or run: `chmod +x JainAttendanceChecker`

### Antivirus blocking (Windows):
- Add the executable to antivirus whitelist
- This is a common false positive with packaged Python applications

### Slow startup:
- First run is slower as it extracts bundled files
- Subsequent runs will be faster

## File Size
- Typical size: ~150-200 MB
- Large size is due to bundled Python interpreter and all dependencies

## Security & Privacy

- ✅ **Local processing** - All data processing happens on your computer
- ✅ **No data collection** - No personal information is stored or transmitted
- ✅ **Read-only access** - Only reads attendance data, makes no changes
- ✅ **Standard web access** - Uses same login process as browser

## Support

For issues or questions:
1. Ensure Chrome browser is installed and updated
2. Check internet connection
3. Try running from terminal/command prompt for error details

## Technical Details

- Built with: PyInstaller
- Browser: Selenium WebDriver with Chrome
- Platform: Universal (Windows/macOS/Linux)
- Dependencies: All bundled (no external requirements)

---

**Note**: This application automates the manual process of checking attendance on the Jain University portal. You still need to manually complete the login process (including CAPTCHA) for security reasons.
