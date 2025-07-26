#!/bin/bash

# Security Check Script for Sona App
# This script helps identify potential security issues

echo "🔍 Checking for exposed secrets in Sona App..."
echo "============================================="

# Check for common API key patterns
echo "
📋 Checking for API keys in code..."
patterns=(
    "sk-proj-"                    # OpenAI API keys
    "AIza[0-9A-Za-z_-]{35}"      # Google API keys
    "-----BEGIN.*KEY-----"        # Private keys
    "firebase.*['\"].*['\"]"      # Firebase credentials
    "api[_-]?key.*=.*['\"]"      # Generic API keys
    "secret.*=.*['\"]"           # Secret values
    "password.*=.*['\"]"         # Passwords
)

for pattern in "${patterns[@]}"; do
    echo -n "Checking for pattern: $pattern ... "
    count=$(grep -r -E "$pattern" . \
        --include="*.dart" \
        --include="*.js" \
        --include="*.json" \
        --include="*.yaml" \
        --include="*.yml" \
        --exclude-dir=node_modules \
        --exclude-dir=.git \
        --exclude-dir=build \
        --exclude="firebase_options.dart" \
        2>/dev/null | wc -l)
    
    if [ $count -gt 0 ]; then
        echo "⚠️  Found $count occurrences"
        grep -r -E "$pattern" . \
            --include="*.dart" \
            --include="*.js" \
            --include="*.json" \
            --include="*.yaml" \
            --include="*.yml" \
            --exclude-dir=node_modules \
            --exclude-dir=.git \
            --exclude-dir=build \
            --exclude="firebase_options.dart" \
            2>/dev/null | head -5
    else
        echo "✅ Clear"
    fi
done

echo "
📋 Checking for sensitive files..."
sensitive_files=(
    ".env"
    "firebase-service-account-key.json"
    "serviceAccountKey.json"
    "google-services.json"
    "key.properties"
    "*.jks"
    "*.keystore"
)

for file_pattern in "${sensitive_files[@]}"; do
    echo -n "Looking for: $file_pattern ... "
    if find . -name "$file_pattern" -not -path "./.git/*" -not -path "./node_modules/*" 2>/dev/null | grep -q .; then
        echo "⚠️  Found"
        find . -name "$file_pattern" -not -path "./.git/*" -not -path "./node_modules/*" 2>/dev/null
    else
        echo "✅ Not found"
    fi
done

echo "
📋 Checking .gitignore files..."
if [ -f ".gitignore" ]; then
    echo "✅ Root .gitignore exists"
else
    echo "❌ Root .gitignore missing!"
fi

if [ -f "sona_app/.gitignore" ]; then
    echo "✅ Flutter app .gitignore exists"
else
    echo "❌ Flutter app .gitignore missing!"
fi

echo "
📋 Checking if we're in a git repository..."
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "✅ This is a git repository"
    
    echo "
📋 Checking for tracked sensitive files..."
    for file in ".env" "firebase-service-account-key.json" "google-services.json"; do
        if git ls-files --error-unmatch "$file" > /dev/null 2>&1; then
            echo "⚠️  $file is tracked in git! Remove with: git rm --cached $file"
        fi
    done
else
    echo "ℹ️  Not a git repository yet"
fi

echo "
============================================="
echo "✅ Security check complete!"
echo ""
echo "📌 Recommendations:"
echo "1. Ensure all sensitive files are in .gitignore"
echo "2. Use environment variables for all API keys"
echo "3. Never commit real API keys to version control"
echo "4. Rotate any exposed API keys immediately"
echo "5. Use Firebase Security Rules to protect data"