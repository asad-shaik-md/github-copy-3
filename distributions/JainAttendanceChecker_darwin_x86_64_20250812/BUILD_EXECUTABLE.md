# Building Executable Version

This guide explains how to create standalone executable versions of the Jain University Attendance Checker that can run on any computer without requiring Python installation.

## Prerequisites

### For the Computer Building the Executable:
- Python 3.7+ installed
- All project dependencies installed
- Virtual environment set up (attendance_env)

### For Target Computers (where executable will run):
- **Chrome browser must be installed**
- No Python installation required
- No additional dependencies required

## Building the Executable

### Method 1: Using Build Scripts (Recommended)

#### On macOS/Linux:
```bash
./build_executable.sh
```

#### On Windows:
```cmd
build_executable.bat
```

### Method 2: Manual Build

1. Activate virtual environment:
   ```bash
   # macOS/Linux
   source attendance_env/bin/activate
   
   # Windows
   attendance_env\Scripts\activate
   ```

2. Install PyInstaller:
   ```bash
   pip install pyinstaller
   ```

3. Build executable:
   ```bash
   pyinstaller attendance_checker.spec --clean
   ```

## Output

After successful build, you'll find:
- **macOS/Linux**: `dist/JainAttendanceChecker`
- **Windows**: `dist/JainAttendanceChecker.exe`

## Distribution

1. **Copy the entire `dist` folder** to the target computer
2. Ensure **Chrome browser is installed** on the target computer
3. Run the executable:
   - macOS/Linux: `./JainAttendanceChecker`
   - Windows: Double-click `JainAttendanceChecker.exe`

## Platform-Specific Notes

### macOS
- The executable is built for the current architecture (Intel/Apple Silicon)
- On first run, you may need to allow the app in System Preferences > Security & Privacy
- If you get "unidentified developer" warning, right-click and select "Open"

### Windows
- The executable includes all necessary DLLs
- Windows Defender might flag it initially (false positive)
- Built executable will work on Windows 10+ (64-bit)

### Linux
- Built on one Linux distribution should work on most others
- Ensure GLIBC version compatibility for older distributions
- May need to install Chrome if not already present

## File Size

Typical executable sizes:
- **macOS**: ~150-200 MB
- **Windows**: ~150-200 MB  
- **Linux**: ~150-200 MB

The large size is due to bundling Python interpreter and all dependencies.

## Troubleshooting

### Build Issues

1. **Missing modules error**:
   ```bash
   pip install --upgrade -r requirements.txt
   pip install pyinstaller
   ```

2. **Permission denied on macOS**:
   ```bash
   chmod +x build_executable.sh
   ```

3. **Chrome not found on target machine**:
   - Install Chrome browser on the target computer
   - The executable requires Chrome to function

### Runtime Issues

1. **"Chrome binary not found"**:
   - Install Chrome browser on the target machine
   - Ensure Chrome is in the system PATH

2. **Slow startup**:
   - First run is slower as it extracts bundled files
   - Subsequent runs will be faster

3. **Antivirus blocking**:
   - Add executable to antivirus whitelist
   - This is a common false positive with PyInstaller executables

## Advanced Building

### Custom Icon (Optional)
To add a custom icon, place an `.ico` file (Windows) or `.icns` file (macOS) in the project directory and update the spec file:

```python
exe = EXE(
    # ... other parameters ...
    icon='your_icon.ico',  # or 'your_icon.icns' for macOS
)
```

### Building for Different Platforms
- **Cross-compilation is not supported**
- Build on the target platform for best compatibility
- Use virtual machines or CI/CD services for multi-platform builds

## Security Note

The executable contains the source code in bytecode form. While not easily readable, it's not encrypted. Avoid including sensitive credentials in the source code.
