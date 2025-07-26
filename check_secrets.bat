@echo off
setlocal enabledelayedexpansion

echo.
echo 🔍 Checking for exposed secrets in Sona App...
echo =============================================

echo.
echo 📋 Checking for API keys in code...

:: Check for OpenAI keys
echo Checking for OpenAI API keys...
findstr /s /i /r "sk-proj-" *.dart *.js *.json *.yaml 2>nul | find /c /v "" > temp.txt
set /p count=<temp.txt
if !count! gtr 0 (
    echo ⚠️  Found OpenAI API keys:
    findstr /s /i /r "sk-proj-" *.dart *.js *.json *.yaml 2>nul | more
) else (
    echo ✅ No OpenAI API keys found
)
del temp.txt

:: Check for Google API keys  
echo Checking for Google API keys...
findstr /s /i /r "AIza[0-9A-Za-z_-]*" *.dart *.js *.json *.yaml 2>nul | findstr /v "firebase_options.dart" | find /c /v "" > temp.txt
set /p count=<temp.txt
if !count! gtr 0 (
    echo ⚠️  Found Google API keys (excluding firebase_options.dart):
    findstr /s /i /r "AIza[0-9A-Za-z_-]*" *.dart *.js *.json *.yaml 2>nul | findstr /v "firebase_options.dart" | more
) else (
    echo ✅ No exposed Google API keys
)
del temp.txt

echo.
echo 📋 Checking for sensitive files...

:: Check for .env files
if exist ".env" (
    echo ⚠️  Found .env file at root
) else (
    echo ✅ No .env at root
)

if exist "sona_app\.env" (
    echo ⚠️  Found .env file in sona_app
) else (
    echo ✅ No .env in sona_app
)

:: Check for Firebase service account keys
if exist "firebase-service-account-key.json" (
    echo ⚠️  Found firebase-service-account-key.json
) else (
    echo ✅ No firebase-service-account-key.json
)

:: Check for google-services.json
if exist "sona_app\google-services.json" (
    echo ⚠️  Found google-services.json in sona_app
)

if exist "sona_app\android\app\google-services.json" (
    echo ⚠️  Found google-services.json in android app
)

echo.
echo 📋 Checking .gitignore files...

if exist ".gitignore" (
    echo ✅ Root .gitignore exists
    findstr /i ".env firebase-service-account-key" .gitignore >nul
    if !errorlevel! equ 0 (
        echo ✅ .gitignore includes security entries
    ) else (
        echo ❌ .gitignore missing security entries!
    )
) else (
    echo ❌ Root .gitignore missing!
)

if exist "sona_app\.gitignore" (
    echo ✅ Flutter app .gitignore exists
) else (
    echo ❌ Flutter app .gitignore missing!
)

echo.
echo 📋 Checking git status...
git status >nul 2>&1
if !errorlevel! equ 0 (
    echo ✅ This is a git repository
    
    echo.
    echo 📋 Checking for tracked sensitive files...
    git ls-files | findstr /i ".env firebase-service-account-key.json google-services.json" >nul 2>&1
    if !errorlevel! equ 0 (
        echo ⚠️  Sensitive files are tracked in git!
        git ls-files | findstr /i ".env firebase-service-account-key.json google-services.json"
    ) else (
        echo ✅ No sensitive files tracked
    )
) else (
    echo ℹ️  Not a git repository yet
)

echo.
echo =============================================
echo ✅ Security check complete!
echo.
echo 📌 Recommendations:
echo 1. Ensure all sensitive files are in .gitignore
echo 2. Use environment variables for all API keys
echo 3. Never commit real API keys to version control
echo 4. Rotate any exposed API keys immediately
echo 5. Use Firebase Security Rules to protect data

pause