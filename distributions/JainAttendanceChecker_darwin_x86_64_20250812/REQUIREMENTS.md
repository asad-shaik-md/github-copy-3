# System Requirements for Jain University Attendance Checker

## Minimum Requirements

### Operating System
- **Windows**: Windows 10 (64-bit) or later
- **macOS**: macOS 10.13 High Sierra or later
- **Linux**: Most modern distributions (Ubuntu 18.04+, CentOS 7+, etc.)

### Hardware
- **RAM**: 2 GB minimum, 4 GB recommended
- **Storage**: 500 MB free space
- **CPU**: Any modern processor (x86_64/AMD64)

### Software Dependencies

#### Required (Must Install):
1. **Google Chrome Browser**
   - Download: https://www.google.com/chrome/
   - Version: Latest stable version recommended
   - **Critical**: The application will not work without Chrome

#### Automatic (Handled by Application):
- ChromeDriver (automatically managed)
- Python interpreter (bundled)
- All Python libraries (bundled)

### Network Requirements
- **Internet connection** - Required for:
  - Accessing Jain University portal
  - Downloading ChromeDriver (first run only)
  - Loading web pages during operation

### Permissions

#### Windows:
- May require allowing through Windows Defender/Firewall
- Administrator privileges not required for normal operation

#### macOS:
- May require allowing in System Preferences > Security & Privacy
- Gatekeeper warning on first run (normal for unsigned applications)

#### Linux:
- Execute permissions on the file (`chmod +x JainAttendanceChecker`)
- No root privileges required

## Platform-Specific Notes

### Windows 10/11
- ✅ Fully supported
- ⚠️ Windows Defender may flag as unknown application (false positive)
- 💡 Run from Command Prompt to see detailed error messages

### macOS
- ✅ Supports both Intel and Apple Silicon (M1/M2) Macs
- ⚠️ First run may show "unidentified developer" warning
- 💡 Right-click → Open to bypass Gatekeeper warning

### Linux
- ✅ Most distributions supported
- ⚠️ May need to install Chrome separately: `sudo apt install google-chrome-stable`
- 💡 Check GLIBC version compatibility for older distributions

## Performance Expectations

### Startup Time
- **First run**: 10-15 seconds (extracts bundled files)
- **Subsequent runs**: 3-5 seconds

### Memory Usage
- **Typical**: 200-400 MB RAM
- **Peak**: Up to 500 MB during Chrome operation

### Storage Usage
- **Executable**: ~150-200 MB
- **Temporary files**: ~50-100 MB (automatically cleaned)
- **ChromeDriver cache**: ~20-50 MB (one-time download)

## Compatibility Testing

### Tested Configurations
- ✅ Windows 10 (64-bit) + Chrome 120+
- ✅ Windows 11 (64-bit) + Chrome 120+
- ✅ macOS Monterey (Intel) + Chrome 120+
- ✅ macOS Ventura (Apple Silicon) + Chrome 120+
- ✅ Ubuntu 22.04 LTS + Chrome 120+

### Known Issues
- ❌ Windows 7/8: Not supported (Python 3.12 requirement)
- ❌ 32-bit systems: Not supported
- ❌ Very old Linux distributions: May have GLIBC compatibility issues

## Troubleshooting System Issues

### Chrome Installation Issues
```bash
# Windows (via Chocolatey)
choco install googlechrome

# macOS (via Homebrew)
brew install --cask google-chrome

# Ubuntu/Debian
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo apt update
sudo apt install google-chrome-stable
```

### Permission Issues
```bash
# macOS/Linux: Make executable
chmod +x JainAttendanceChecker

# macOS: Allow unidentified developer
spctl --add JainAttendanceChecker
```

### Path Issues
- Ensure the executable is in a folder with read/write permissions
- Avoid running from system directories or protected folders

## Security Considerations

### Antivirus Software
- **False positives**: Common with PyInstaller executables
- **Solution**: Add to whitelist or exclude folder
- **Safe to ignore**: These are false alarms

### Firewall Settings
- **Outbound connections**: Allow Chrome to access internet
- **No inbound connections**: Application doesn't accept incoming connections

### Data Privacy
- **Local only**: All processing happens on your computer
- **No data transmission**: Only standard web requests to Jain University
- **No storage**: No personal data is stored permanently

---

**Note**: If you encounter system-specific issues not covered here, try running the executable from terminal/command prompt to see detailed error messages.
