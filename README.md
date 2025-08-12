# Jain University Attendance Checker

A simple Python script that automates the process of checking attendance on the Jain University student portal.

## Features

- Automated Chrome browser setup with ChromeDriver management
- Manual login support (waits for user to complete login and CAPTCHA)
- Automatic attendance data extraction for all subjects
- Detailed attendance percentage calculations
- Color-coded attendance status (Good/Warning/Critical)

## Requirements

- Python 3.7+
- Chrome browser
- Internet connection

## Installation

1. Clone or download this repository
2. Create a virtual environment (recommended):
   ```bash
   python -m venv attendance_env
   source attendance_env/bin/activate  # On Windows: attendance_env\Scripts\activate
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Usage

Simply run the main script:

```bash
python attendance_checker.py
```

The script will:
1. Open Chrome browser and navigate to the login page
2. Wait for you to manually complete login (including CAPTCHA)
3. Automatically extract attendance data for all subjects
4. Display detailed attendance statistics

## Configuration

You can modify settings in `config.py`:
- URLs for login and attendance pages
- Timeout values
- Attendance percentage thresholds
- XPath selectors for web elements

## Files

- `attendance_checker.py` - Main script with all functionality
- `config.py` - Configuration settings
- `requirements.txt` - Python dependencies
- `.gitignore` - Git ignore rules

## Standalone Executable Version

For users who don't want to install Python, we provide standalone executable versions:

### Building Executable (For Developers)
```bash
# Build executable
./build_executable.sh

# Create distribution package
./create_distribution.sh
```

### Using Pre-built Executable (For End Users)
1. Download the distribution package for your platform
2. Extract the zip file
3. Install Chrome browser (if not already installed)
4. Run the executable:
   - **macOS/Linux**: `./JainAttendanceChecker` or `./run.sh`
   - **Windows**: `JainAttendanceChecker.exe` or `run.bat`

**Benefits of Executable Version:**
- ✅ No Python installation required
- ✅ No dependency management needed
- ✅ Works on any computer with Chrome
- ✅ Portable - just copy and run

See `BUILD_EXECUTABLE.md` for detailed instructions.

## Troubleshooting

- Ensure Chrome browser is installed and up to date
- If ChromeDriver issues occur, the script will automatically try to resolve them
- Make sure you have stable internet connection
- Verify the URLs in config.py are correct for your institution
