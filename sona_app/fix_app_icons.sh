#!/bin/bash

echo "🎨 Fixing App Icons - Removing Alpha Channel"
echo "==========================================="

# Icon path
ICON_PATH="assets/icons/app_icon.png"
ICON_IOS_PATH="assets/icons/app_icon_ios.png"

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "❌ ImageMagick not found. Installing..."
    if command -v brew &> /dev/null; then
        brew install imagemagick
    else
        echo "Please install ImageMagick manually:"
        echo "brew install imagemagick"
        exit 1
    fi
fi

# Check if sips is available (macOS built-in tool)
if command -v sips &> /dev/null; then
    echo "✅ Using sips (macOS built-in tool)"
    
    # Create iOS icon without alpha channel
    if [ -f "$ICON_PATH" ]; then
        echo "📱 Processing icon: $ICON_PATH"
        
        # Remove alpha channel and create iOS version
        sips -s format png "$ICON_PATH" --out temp_icon.png
        sips -s formatOptions 100 temp_icon.png --out "$ICON_IOS_PATH"
        
        # Alternative method: flatten against white background
        # This ensures no transparency
        sips -s format jpeg "$ICON_PATH" --out temp_icon.jpg
        sips -s format png temp_icon.jpg --out "$ICON_IOS_PATH"
        
        # Clean up temp files
        rm -f temp_icon.png temp_icon.jpg
        
        echo "✅ Created iOS icon without alpha channel: $ICON_IOS_PATH"
    else
        echo "❌ Icon not found at: $ICON_PATH"
    fi
    
elif command -v convert &> /dev/null; then
    echo "✅ Using ImageMagick"
    
    if [ -f "$ICON_PATH" ]; then
        echo "📱 Processing icon: $ICON_PATH"
        
        # Remove alpha channel by flattening against white background
        convert "$ICON_PATH" -background white -alpha remove -alpha off "$ICON_IOS_PATH"
        
        echo "✅ Created iOS icon without alpha channel: $ICON_IOS_PATH"
    else
        echo "❌ Icon not found at: $ICON_PATH"
    fi
else
    echo "❌ No image processing tool available"
    exit 1
fi

# Update flutter_launcher_icons configuration
echo ""
echo "📝 Creating flutter_launcher_icons configuration..."

cat > flutter_launcher_icons.yaml << EOF
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icons/app_icon.png"
  image_path_ios: "assets/icons/app_icon_ios.png"
  
  # iOS specific settings
  remove_alpha_ios: true
  
  # Android specific settings
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/icons/app_icon.png"
  
  # Web
  web:
    generate: false
EOF

echo "✅ Configuration created: flutter_launcher_icons.yaml"

# Run flutter_launcher_icons
echo ""
echo "🔄 Generating app icons..."

# Check if Flutter is in PATH
FLUTTER_PATH="/Users/nohdol/project/flutter/bin/flutter"
if [ ! -f "$FLUTTER_PATH" ]; then
    FLUTTER_PATH="/Users/nohdol/flutter/bin/flutter"
fi

if [ -f "$FLUTTER_PATH" ]; then
    echo "Using Flutter at: $FLUTTER_PATH"
    $FLUTTER_PATH pub get
    $FLUTTER_PATH pub run flutter_launcher_icons
else
    echo "⚠️ Flutter not found. Please run manually:"
    echo "flutter pub get"
    echo "flutter pub run flutter_launcher_icons"
fi

echo ""
echo "✅ Icon fix completed!"
echo ""
echo "📋 Next steps:"
echo "1. Clean Xcode build: Cmd+Shift+K"
echo "2. Create new Archive: Product > Archive"
echo "3. Upload to TestFlight"
echo ""
echo "⚠️ Make sure the icon has:"
echo "  - No transparency (alpha channel removed)"
echo "  - White or solid background"
echo "  - 1024x1024 resolution for App Store"