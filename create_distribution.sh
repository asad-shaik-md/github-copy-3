#!/bin/bash
"""
Distribution Package Creator for Jain University Attendance Checker
Creates a complete distribution package ready for sharing
"""

echo "Creating Distribution Package..."
echo "================================"

# Get current date for package naming
DATE=$(date +"%Y%m%d")
PLATFORM=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Package name
PACKAGE_NAME="JainAttendanceChecker_${PLATFORM}_${ARCH}_${DATE}"

# Create distribution directory
DIST_DIR="distributions/${PACKAGE_NAME}"
mkdir -p "${DIST_DIR}"

echo "📦 Creating package: ${PACKAGE_NAME}"

# Check if executable exists
if [ ! -f "dist/JainAttendanceChecker" ]; then
    echo "❌ Executable not found! Please run build_executable.sh first."
    exit 1
fi

# Copy executable
echo "📋 Copying executable..."
cp "dist/JainAttendanceChecker" "${DIST_DIR}/"

# Copy documentation
echo "📋 Copying documentation..."
cp "README_DISTRIBUTION.md" "${DIST_DIR}/README.md"
cp "REQUIREMENTS.md" "${DIST_DIR}/"
cp "BUILD_EXECUTABLE.md" "${DIST_DIR}/"

# Create a simple run script
echo "📋 Creating run script..."
cat > "${DIST_DIR}/run.sh" << 'EOF'
#!/bin/bash
# Simple run script for Jain Attendance Checker

echo "Starting Jain University Attendance Checker..."
echo "=============================================="

# Check if Chrome is installed
if ! command -v google-chrome &> /dev/null && ! command -v chrome &> /dev/null && ! command -v chromium &> /dev/null; then
    echo "⚠️  Chrome browser not found!"
    echo "Please install Chrome from: https://www.google.com/chrome/"
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

# Create Windows batch file
echo "📋 Creating Windows run script..."
cat > "${DIST_DIR}/run.bat" << 'EOF'
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
EOF

# Create version info
echo "📋 Creating version info..."
cat > "${DIST_DIR}/VERSION.txt" << EOF
Jain University Attendance Checker
==================================

Build Information:
- Version: 1.0.0
- Build Date: $(date)
- Platform: ${PLATFORM}
- Architecture: ${ARCH}
- Python Version: $(python --version 2>/dev/null || echo "Bundled")
- Package Type: Standalone Executable

Package Contents:
- JainAttendanceChecker (executable)
- README.md (user guide)
- REQUIREMENTS.md (system requirements)
- BUILD_EXECUTABLE.md (build instructions)
- run.sh (Linux/macOS launcher)
- run.bat (Windows launcher)
- VERSION.txt (this file)

Installation:
1. Extract this package to any folder
2. Install Chrome browser if not already installed
3. Run the executable or use the launcher scripts

Support:
- Ensure Chrome browser is installed
- Check REQUIREMENTS.md for system requirements
- Run from terminal for detailed error messages
EOF

# Create zip package
echo "📦 Creating zip package..."
cd distributions
zip -r "${PACKAGE_NAME}.zip" "${PACKAGE_NAME}/" > /dev/null 2>&1

# Calculate file sizes
EXEC_SIZE=$(ls -lh "${PACKAGE_NAME}/JainAttendanceChecker" | awk '{print $5}')
ZIP_SIZE=$(ls -lh "${PACKAGE_NAME}.zip" | awk '{print $5}')

echo ""
echo "✅ Distribution package created successfully!"
echo ""
echo "📊 Package Information:"
echo "   Package Name: ${PACKAGE_NAME}"
echo "   Executable Size: ${EXEC_SIZE}"
echo "   Zip Package Size: ${ZIP_SIZE}"
echo "   Location: distributions/${PACKAGE_NAME}/"
echo "   Zip File: distributions/${PACKAGE_NAME}.zip"
echo ""
echo "📋 Package Contents:"
echo "   ├── JainAttendanceChecker (executable)"
echo "   ├── README.md (user guide)"
echo "   ├── REQUIREMENTS.md (system requirements)"
echo "   ├── BUILD_EXECUTABLE.md (build instructions)"
echo "   ├── run.sh (launcher for macOS/Linux)"
echo "   ├── run.bat (launcher for Windows)"
echo "   └── VERSION.txt (version information)"
echo ""
echo "🚀 Ready for distribution!"
echo "   Share the zip file: distributions/${PACKAGE_NAME}.zip"
echo "   Recipients just need to extract and run!"
echo ""

cd ..
