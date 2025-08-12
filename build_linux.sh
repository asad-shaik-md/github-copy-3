#!/bin/bash
"""
Linux Build Script for Jain University Attendance Checker
Run this script on a Linux machine to build the executable
"""

echo "Jain University Attendance Checker - Linux Build Script"
echo "======================================================="

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ ERROR: Python3 is not installed"
    echo "Install Python3:"
    echo "  Ubuntu/Debian: sudo apt update && sudo apt install python3 python3-pip python3-venv"
    echo "  CentOS/RHEL: sudo yum install python3 python3-pip"
    echo "  Fedora: sudo dnf install python3 python3-pip"
    exit 1
fi

# Check if pip is installed
if ! command -v pip3 &> /dev/null; then
    echo "❌ ERROR: pip3 is not installed"
    echo "Install pip3:"
    echo "  Ubuntu/Debian: sudo apt install python3-pip"
    echo "  CentOS/RHEL: sudo yum install python3-pip"
    exit 1
fi

# Check if Git is installed
if ! command -v git &> /dev/null; then
    echo "❌ ERROR: Git is not installed"
    echo "Install Git:"
    echo "  Ubuntu/Debian: sudo apt install git"
    echo "  CentOS/RHEL: sudo yum install git"
    echo "  Fedora: sudo dnf install git"
    exit 1
fi

# Check if Chrome is installed
if command -v google-chrome &> /dev/null; then
    echo "✅ Chrome found: $(which google-chrome)"
elif command -v chrome &> /dev/null; then
    echo "✅ Chrome found: $(which chrome)"
elif command -v chromium &> /dev/null; then
    echo "✅ Chromium found: $(which chromium)"
else
    echo "⚠️  WARNING: Chrome browser not found!"
    echo "Install Chrome:"
    echo "  Ubuntu/Debian:"
    echo "    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -"
    echo "    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list"
    echo "    sudo apt update && sudo apt install google-chrome-stable"
    echo ""
    echo "  CentOS/RHEL/Fedora:"
    echo "    sudo dnf install google-chrome-stable"
    echo ""
    echo "Press Enter to continue anyway..."
    read
fi

echo ""
echo "Setting up build environment..."
echo "=============================="

# Create virtual environment
echo "📦 Creating virtual environment..."
python3 -m venv attendance_env_linux
if [ $? -ne 0 ]; then
    echo "❌ ERROR: Failed to create virtual environment"
    echo "Try installing python3-venv:"
    echo "  Ubuntu/Debian: sudo apt install python3-venv"
    exit 1
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source attendance_env_linux/bin/activate

# Upgrade pip
echo "⬆️  Upgrading pip..."
python -m pip install --upgrade pip

# Install dependencies
echo "📋 Installing dependencies..."
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "❌ ERROR: Failed to install dependencies"
    echo "Make sure requirements.txt exists and contains valid packages"
    exit 1
fi

# Install PyInstaller
echo "🔨 Installing PyInstaller..."
pip install pyinstaller
if [ $? -ne 0 ]; then
    echo "❌ ERROR: Failed to install PyInstaller"
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf build/ dist/ __pycache__/

# Build the executable
echo ""
echo "Building Linux executable..."
echo "==========================="
pyinstaller attendance_checker.spec --clean
if [ $? -ne 0 ]; then
    echo "❌ ERROR: Build failed!"
    echo "Check the output above for errors"
    exit 1
fi

# Check if build was successful
if [ -f "dist/JainAttendanceChecker" ]; then
    echo ""
    echo "✅ Build successful!"
    echo "=================="
    
    # Get file size
    EXEC_SIZE=$(ls -lh dist/JainAttendanceChecker | awk '{print $5}')
    echo "Executable created: dist/JainAttendanceChecker"
    echo "File size: $EXEC_SIZE"
    echo ""
    
    # Verify architecture
    EXEC_ARCH=$(file dist/JainAttendanceChecker | grep -o 'x86-64\|x86_64\|aarch64')
    echo "Architecture: $EXEC_ARCH"
    
    # Create distribution package
    echo "📦 Creating distribution package..."
    DATE=$(date +"%Y%m%d")
    PACKAGE_NAME="JainAttendanceChecker_linux_x86_64_${DATE}"
    DIST_DIR="distributions/${PACKAGE_NAME}"
    
    mkdir -p "${DIST_DIR}"
    
    # Copy files
    cp "dist/JainAttendanceChecker" "${DIST_DIR}/"
    chmod +x "${DIST_DIR}/JainAttendanceChecker"
    
    cp "README_DISTRIBUTION.md" "${DIST_DIR}/README.md" 2>/dev/null || echo "README_DISTRIBUTION.md not found"
    cp "REQUIREMENTS.md" "${DIST_DIR}/" 2>/dev/null || echo "REQUIREMENTS.md not found"
    cp "BUILD_EXECUTABLE.md" "${DIST_DIR}/" 2>/dev/null || echo "BUILD_EXECUTABLE.md not found"
    cp "WINDOWS_BUILD_OPTIONS.md" "${DIST_DIR}/" 2>/dev/null || echo "WINDOWS_BUILD_OPTIONS.md not found"
    
    # Create Linux-specific run script
    cat > "${DIST_DIR}/run.sh" << 'EOF'
#!/bin/bash
echo "Starting Jain University Attendance Checker (Linux)..."
echo "====================================================="

# Check if Chrome is installed
if ! command -v google-chrome &> /dev/null && ! command -v chrome &> /dev/null && ! command -v chromium &> /dev/null; then
    echo "⚠️  Chrome browser not found!"
    echo "Install Chrome:"
    echo "  Ubuntu/Debian: sudo apt install google-chrome-stable"
    echo "  CentOS/RHEL: sudo yum install google-chrome-stable"
    echo "  Fedora: sudo dnf install google-chrome-stable"
    echo ""
    echo "Press Enter to continue anyway..."
    read
fi

# Make executable if needed
chmod +x ./JainAttendanceChecker

# Run the application
./JainAttendanceChecker

echo "Program finished. Press Enter to close..."
read
EOF
    chmod +x "${DIST_DIR}/run.sh"
    
    # Create version info
    cat > "${DIST_DIR}/VERSION.txt" << EOF
Jain University Attendance Checker - Linux Build
================================================

Build Information:
- Version: 1.0.0
- Build Date: $(date)
- Platform: Linux (x86_64)
- Architecture: x86_64
- Built on: $(hostname)
- Distribution: $(lsb_release -ds 2>/dev/null || cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2 || echo "Unknown")

Compatibility:
✅ Ubuntu 20.04+ (64-bit)
✅ Debian 10+ (64-bit)
✅ CentOS 8+ (64-bit)
✅ Fedora 30+ (64-bit)
✅ Most modern Linux distributions
❌ Very old distributions (GLIBC compatibility issues)
❌ 32-bit systems

Package Contents:
- JainAttendanceChecker (main executable)
- README.md (user guide)
- REQUIREMENTS.md (system requirements)
- run.sh (launcher script)
- VERSION.txt (this file)

Prerequisites:
- Google Chrome browser
- Internet connection
- No Python installation needed (standalone)
EOF
    
    # Create zip package
    echo "📦 Creating zip package..."
    cd distributions
    zip -r "${PACKAGE_NAME}.zip" "${PACKAGE_NAME}/" > /dev/null 2>&1
    cd ..
    
    ZIP_SIZE=$(ls -lh "distributions/${PACKAGE_NAME}.zip" | awk '{print $5}')
    
    echo ""
    echo "🎉 Distribution package created!"
    echo "==============================="
    echo "Package Name: ${PACKAGE_NAME}"
    echo "Executable Size: ${EXEC_SIZE}"
    echo "Zip Package Size: ${ZIP_SIZE}"
    echo "Location: distributions/${PACKAGE_NAME}/"
    echo "Zip File: distributions/${PACKAGE_NAME}.zip"
    echo ""
    echo "📋 Package Contents:"
    echo "   ├── JainAttendanceChecker (executable)"
    echo "   ├── README.md (user guide)"
    echo "   ├── REQUIREMENTS.md (system requirements)"
    echo "   ├── run.sh (launcher script)"
    echo "   └── VERSION.txt (version information)"
    echo ""
    echo "🚀 Ready for distribution!"
    echo "========================="
    echo "To test:"
    echo "  cd distributions/${PACKAGE_NAME}/"
    echo "  ./run.sh"
    echo ""
    echo "To distribute:"
    echo "  Share the zip file: distributions/${PACKAGE_NAME}.zip"
    echo "  Recipients just need to extract and run!"
    echo ""
    
else
    echo ""
    echo "❌ Build failed!"
    echo "==============="
    echo "The executable was not created. Check the output above for errors."
    exit 1
fi

# Deactivate virtual environment
deactivate

echo "🎯 Linux build complete!"
