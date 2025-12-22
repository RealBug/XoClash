#!/bin/bash

# Script to generate application icons
# Run: bash scripts/generate_icons.sh

FLUTTER_CMD="flutter"
if command -v fvm &> /dev/null; then
    FLUTTER_CMD="fvm flutter"
fi

echo "Installing dependencies..."
$FLUTTER_CMD pub get

echo ""
echo "Generating icons for iOS, macOS and Android..."
$FLUTTER_CMD pub run flutter_launcher_icons

echo ""
echo "✅ Icons generated successfully!"
echo "To see changes on iOS, you may need to:"
echo "1. Clean the build: $FLUTTER_CMD clean"
echo "2. Rebuild the app: $FLUTTER_CMD build ios"
echo "3. Or simply restart the app from Xcode"






