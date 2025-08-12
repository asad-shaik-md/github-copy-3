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
