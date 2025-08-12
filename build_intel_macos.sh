#!/bin/bash
"""
Build Intel macOS executable on Apple Silicon Mac
This uses Rosetta 2 to create x86_64 compatible executable
"""

echo "Building Intel macOS Executable on Apple Silicon"
echo "==============================================="

# Check if we're on Apple Silicon
ARCH=$(uname -m)
if [ "$ARCH" != "arm64" ]; then
    echo "❌ This script is designed for Apple Silicon Macs"
    echo "Current architecture: $ARCH"
    exit 1
fi

# Check if Rosetta 2 is installed
if ! arch -x86_64 /usr/bin/true 2>/dev/null; then
    echo "❌ Rosetta 2 not installed!"
    echo "Please install Rosetta 2 first:"
    echo "  softwareupdate --install-rosetta"
    exit 1
fi

echo "✅ Apple Silicon detected with Rosetta 2 available"

# Create Intel-specific virtual environment
INTEL_ENV="attendance_env_intel"
echo "🔧 Creating Intel-specific virtual environment..."

# Remove existing Intel env if it exists
if [ -d "$INTEL_ENV" ]; then
    echo "🧹 Removing existing Intel environment..."
    rm -rf "$INTEL_ENV"
fi

# Create new Intel environment using x86_64 Python
echo "📦 Creating Intel virtual environment..."
arch -x86_64 /usr/bin/python3 -m venv "$INTEL_ENV"

# Activate and install dependencies
echo "📋 Installing dependencies for Intel architecture..."
source "$INTEL_ENV/bin/activate"

# Verify we're using Intel Python
PYTHON_ARCH=$(arch -x86_64 python -c "import platform; print(platform.machine())")
echo "Python architecture: $PYTHON_ARCH"

if [ "$PYTHON_ARCH" != "x86_64" ]; then
    echo "❌ Failed to create Intel Python environment"
    exit 1
fi

# Install dependencies
arch -x86_64 pip install --upgrade pip
arch -x86_64 pip install -r requirements.txt
arch -x86_64 pip install pyinstaller

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf build/ dist/ __pycache__/

# Build Intel executable
echo "🔨 Building Intel executable..."
arch -x86_64 pyinstaller attendance_checker.spec --clean

# Check if build was successful
if [ -f "dist/JainAttendanceChecker" ]; then
    # Verify architecture of built executable
    EXEC_ARCH=$(file dist/JainAttendanceChecker | grep -o 'x86_64\|arm64')
    echo ""
    echo "✅ Intel build successful!"
    echo "Executable architecture: $EXEC_ARCH"
    
    if [ "$EXEC_ARCH" = "x86_64" ]; then
        echo "✅ Verified: Intel-compatible executable created"
        
        # Create Intel distribution
        echo "📦 Creating Intel distribution package..."
        DATE=$(date +"%Y%m%d")
        PACKAGE_NAME="JainAttendanceChecker_darwin_x86_64_${DATE}"
        DIST_DIR="distributions/${PACKAGE_NAME}"
        
        mkdir -p "${DIST_DIR}"
        
        # Copy files
        cp "dist/JainAttendanceChecker" "${DIST_DIR}/"
        cp "README_DISTRIBUTION.md" "${DIST_DIR}/README.md"
        cp "REQUIREMENTS.md" "${DIST_DIR}/"
        cp "BUILD_EXECUTABLE.md" "${DIST_DIR}/"
        cp "MULTI_PLATFORM_BUILD.md" "${DIST_DIR}/"
        
        # Create Intel-specific run script
        cat > "${DIST_DIR}/run.sh" << 'EOF'
#!/bin/bash
echo "Starting Jain University Attendance Checker (Intel macOS)..."
echo "=========================================================="

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
Jain University Attendance Checker - Intel macOS Build
======================================================

Build Information:
- Version: 1.0.0
- Build Date: $(date)
- Platform: macOS (Intel x86_64)
- Architecture: x86_64
- Compatibility: Intel Macs, Apple Silicon Macs (via Rosetta)
- Build Method: Cross-compilation using Rosetta 2

Package Contents:
- JainAttendanceChecker (Intel executable)
- README.md (user guide)
- REQUIREMENTS.md (system requirements)
- BUILD_EXECUTABLE.md (build instructions)
- MULTI_PLATFORM_BUILD.md (platform guide)
- run.sh (launcher script)
- VERSION.txt (this file)

Compatibility:
✅ Intel Macs (native)
✅ Apple Silicon Macs (via Rosetta 2)
❌ Windows
❌ Linux
EOF
        
        # Create zip package
        cd distributions
        zip -r "${PACKAGE_NAME}.zip" "${PACKAGE_NAME}/" > /dev/null 2>&1
        cd ..
        
        EXEC_SIZE=$(ls -lh "${DIST_DIR}/JainAttendanceChecker" | awk '{print $5}')
        ZIP_SIZE=$(ls -lh "distributions/${PACKAGE_NAME}.zip" | awk '{print $5}')
        
        echo ""
        echo "🎉 Intel macOS distribution created!"
        echo ""
        echo "📊 Package Information:"
        echo "   Package Name: ${PACKAGE_NAME}"
        echo "   Executable Size: ${EXEC_SIZE}"
        echo "   Zip Package Size: ${ZIP_SIZE}"
        echo "   Location: distributions/${PACKAGE_NAME}/"
        echo "   Zip File: distributions/${PACKAGE_NAME}.zip"
        echo ""
        echo "💡 This build will work on:"
        echo "   ✅ All Intel Macs"
        echo "   ✅ Apple Silicon Macs (via Rosetta 2)"
        echo ""
    else
        echo "❌ Build failed: Executable is $EXEC_ARCH instead of x86_64"
        exit 1
    fi
else
    echo "❌ Build failed: Executable not found"
    exit 1
fi

# Deactivate environment
deactivate

echo "🎯 Intel macOS build complete!"
echo "   Now you have executables for both:"
echo "   - Apple Silicon: JainAttendanceChecker_darwin_arm64_*"
echo "   - Intel: JainAttendanceChecker_darwin_x86_64_*"
