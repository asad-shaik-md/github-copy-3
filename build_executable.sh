#!/bin/bash
"""
Build script for creating executable versions of Jain Attendance Checker
This script creates standalone executables for different platforms
"""

echo "Jain University Attendance Checker - Build Script"
echo "================================================="

# Activate virtual environment
echo "Activating virtual environment..."
source attendance_env/bin/activate

# Ensure all dependencies are installed
echo "Installing/updating dependencies..."
pip install -r requirements.txt
pip install pyinstaller

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf build/ dist/ __pycache__/

# Build the executable
echo "Building executable..."
pyinstaller attendance_checker.spec --clean

# Check if build was successful
if [ -d "dist" ] && [ -f "dist/JainAttendanceChecker" ]; then
    echo ""
    echo "✅ Build successful!"
    echo "Executable created at: dist/JainAttendanceChecker"
    echo ""
    echo "File size:"
    ls -lh dist/JainAttendanceChecker
    echo ""
    echo "To run the executable:"
    echo "  ./dist/JainAttendanceChecker"
    echo ""
    echo "To distribute:"
    echo "  Copy the entire 'dist' folder to target machine"
    echo "  Make sure Chrome browser is installed on target machine"
else
    echo ""
    echo "❌ Build failed!"
    echo "Check the output above for errors"
    exit 1
fi
