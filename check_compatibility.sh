#!/bin/bash
"""
Platform Compatibility Checker
Helps users determine which executable version they need
"""

echo "🔍 Jain Attendance Checker - Platform Compatibility Check"
echo "========================================================"

# Detect operating system
OS=$(uname -s)
ARCH=$(uname -m)

echo "📋 System Information:"
echo "   Operating System: $OS"
echo "   Architecture: $ARCH"
echo ""

case "$OS" in
    "Darwin")
        echo "🍎 macOS Detected"
        
        # Get macOS version
        MACOS_VERSION=$(sw_vers -productVersion)
        echo "   macOS Version: $MACOS_VERSION"
        
        case "$ARCH" in
            "arm64")
                echo "   Processor: Apple Silicon (M1/M2/M3)"
                echo ""
                echo "✅ RECOMMENDED DOWNLOAD:"
                echo "   📦 JainAttendanceChecker_darwin_arm64_*.zip"
                echo ""
                echo "💡 Alternative Option:"
                echo "   📦 JainAttendanceChecker_darwin_x86_64_*.zip (runs via Rosetta 2)"
                ;;
            "x86_64")
                echo "   Processor: Intel"
                echo ""
                echo "✅ RECOMMENDED DOWNLOAD:"
                echo "   📦 JainAttendanceChecker_darwin_x86_64_*.zip"
                echo ""
                echo "❌ NOT COMPATIBLE:"
                echo "   📦 JainAttendanceChecker_darwin_arm64_*.zip"
                ;;
            *)
                echo "   Processor: Unknown ($ARCH)"
                echo ""
                echo "⚠️  Unknown architecture - try both macOS versions"
                ;;
        esac
        
        # Check if Rosetta 2 is available (for Apple Silicon)
        if [ "$ARCH" = "arm64" ]; then
            if arch -x86_64 /usr/bin/true 2>/dev/null; then
                echo ""
                echo "✅ Rosetta 2 is installed - Intel apps will work"
            else
                echo ""
                echo "⚠️  Rosetta 2 not detected - only ARM64 apps will work"
            fi
        fi
        ;;
        
    "Linux")
        echo "🐧 Linux Detected"
        
        # Try to get distribution info
        if command -v lsb_release &> /dev/null; then
            DISTRO=$(lsb_release -ds)
            echo "   Distribution: $DISTRO"
        elif [ -f /etc/os-release ]; then
            DISTRO=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
            echo "   Distribution: $DISTRO"
        fi
        
        case "$ARCH" in
            "x86_64")
                echo "   Architecture: 64-bit Intel/AMD"
                echo ""
                echo "✅ RECOMMENDED DOWNLOAD:"
                echo "   📦 JainAttendanceChecker_linux_x86_64_*.zip"
                echo ""
                echo "❌ NOT COMPATIBLE:"
                echo "   📦 Any macOS or Windows versions"
                ;;
            "aarch64"|"arm64")
                echo "   Architecture: ARM64"
                echo ""
                echo "⚠️  ARM64 Linux build not currently available"
                echo "   You may need to build from source"
                ;;
            *)
                echo "   Architecture: $ARCH (may not be supported)"
                echo ""
                echo "⚠️  Uncommon architecture - may need to build from source"
                ;;
        esac
        ;;
        
    "MINGW"*|"CYGWIN"*|"MSYS"*)
        echo "🪟 Windows Detected (via $OS)"
        echo ""
        echo "✅ RECOMMENDED DOWNLOAD:"
        echo "   📦 JainAttendanceChecker_windows_amd64_*.zip"
        echo ""
        echo "❌ NOT COMPATIBLE:"
        echo "   📦 Any macOS or Linux versions"
        ;;
        
    *)
        echo "❓ Unknown Operating System: $OS"
        echo ""
        echo "⚠️  Platform not recognized"
        echo "   Try the build for your closest platform or build from source"
        ;;
esac

echo ""
echo "🔧 Prerequisites for ALL platforms:"
echo "   ✅ Google Chrome browser must be installed"
echo "   ✅ Internet connection required"
echo "   ✅ No Python installation needed (standalone executable)"

echo ""
echo "📥 Download locations:"
echo "   • GitHub Releases: <repository-url>/releases"
echo "   • Direct link: Check with the developer"

echo ""
echo "❓ Need help? Check the README.md or REQUIREMENTS.md files"
