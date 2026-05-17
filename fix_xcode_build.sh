#!/bin/bash

echo "🔧 Fixing Xcode PIF Transfer Session Error"
echo "========================================"

# Kill any running Xcode processes
echo "1. Killing Xcode processes..."
killall Xcode 2>/dev/null || echo "   No Xcode processes running"
killall Simulator 2>/dev/null || echo "   No Simulator processes running"

# Clear Xcode caches and derived data
echo "2. Clearing Xcode caches..."
rm -rf ~/Library/Developer/Xcode/DerivedData
rm -rf ~/Library/Caches/com.apple.dt.Xcode
rm -rf ~/Library/Caches/org.carthage.CarthageKit

# Clean Flutter build artifacts
echo "3. Cleaning Flutter build artifacts..."
rm -rf build
rm -rf ios/build
rm -rf android/build

# Clean iOS Pods
echo "4. Cleaning iOS Pods..."
cd ios
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks
cd ..

# Clean Flutter dependencies
echo "5. Cleaning Flutter dependencies..."
flutter clean 2>/dev/null || echo "   Flutter clean failed (Flutter not in PATH)"

# Reset iOS project settings
echo "6. Resetting iOS project settings..."
cd ios
rm -rf Runner.xcworkspace/xcuserdata
rm -rf Runner.xcodeproj/xcuserdata
rm -rf Runner.xcodeproj/project.xcworkspace/xcuserdata
cd ..

echo "✅ Cleanup complete!"
echo ""
echo "Next steps:"
echo "1. Open Xcode: open ios/Runner.xcworkspace"
echo "2. Product → Clean Build Folder (Cmd+Shift+K)"
echo "3. Close Xcode"
echo "4. Run: flutter pub get"
echo "5. Run: cd ios && pod install && cd .."
echo "6. Run: flutter run"
echo ""
echo "If still having issues, try:"
echo "- Restart your Mac"
echo "- Update Xcode to latest version"
echo "- Check iOS deployment target compatibility"

