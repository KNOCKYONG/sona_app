# Security Setup Guide for Sona App

## Overview
This guide helps you properly secure sensitive information in your Firebase Flutter application.

## Current Security Status

### ✅ Already Secured
1. **OpenAI API Key**: Properly loaded from environment variables
2. **Firebase Options**: Public-facing keys (safe to commit)
3. **.env file**: Already exists with API configuration

### ⚠️ Files to Keep Secure
1. `firebase-service-account-key.json` - Contains private keys for server-side operations
2. `.env` files - Contains API keys and secrets
3. `google-services.json` - Contains project configuration (semi-sensitive)

## Setup Instructions

### 1. Initialize Git Repository (if not already done)
Since this project is not yet a git repository, you should initialize it:

```bash
cd C:\Users\yong\sonaapp
git init
```

### 2. Verify .gitignore
A comprehensive `.gitignore` file has been created that excludes:
- All `.env` files (except `.env.example`)
- Firebase service account keys
- Build artifacts
- IDE files
- Temporary files

### 3. Environment Variables Setup

#### For Development:
1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   cp sona_app/.env.example sona_app/.env
   ```

2. Edit the `.env` files with your actual API keys

#### For Production:
- Use your hosting platform's environment variable management
- Never commit real API keys to version control

### 4. Remove Sensitive Files from Git (if already tracked)
If you've already committed sensitive files, run these commands:

```bash
# Remove firebase service account key
git rm --cached firebase-service-account-key.json
git rm --cached sona_app/google-services.json

# Remove .env files
git rm --cached .env
git rm --cached sona_app/.env

# Commit the removal
git commit -m "Remove sensitive files from tracking"
```

### 5. Firebase Service Account Key
The `firebase-service-account-key.json` file should be:
1. Downloaded from Firebase Console > Project Settings > Service Accounts
2. Placed in the project root
3. **Never committed to version control**
4. Shared securely with team members (use password managers or secure file sharing)

### 6. Google Services Configuration
The `google-services.json` file in Android and `GoogleService-Info.plist` for iOS:
- Contains project identifiers
- Generally safe but recommended to exclude from public repos
- Required for Firebase to work in the app

## Best Practices

### API Key Management
1. **Development**: Use `.env` files locally
2. **CI/CD**: Use GitHub Secrets, GitLab CI variables, etc.
3. **Production**: Use platform-specific environment variables (Heroku, Vercel, etc.)

### Sharing with Team
1. Share `.env.example` files in the repository
2. Share actual keys through secure channels:
   - Password managers (1Password, LastPass)
   - Encrypted files
   - Secure messaging
3. Never share keys via:
   - Email
   - Slack/Discord public channels
   - Git commits

### Regular Security Audits
1. Rotate API keys periodically
2. Review Firebase Security Rules
3. Monitor API usage for anomalies
4. Use Firebase App Check for additional security

## Firebase Security Rules
Ensure your Firebase Security Rules are properly configured:

### Firestore Rules Example:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Only authenticated users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Personas can be read by authenticated users
    match /personas/{personaId} {
      allow read: if request.auth != null;
    }
  }
}
```

### Storage Rules Example:
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Verification Checklist
- [ ] `.gitignore` file is in place
- [ ] `.env` files are not tracked in git
- [ ] Firebase service account key is not in version control
- [ ] API keys are loaded from environment variables
- [ ] Firebase Security Rules are configured
- [ ] Team members know how to securely obtain API keys
- [ ] Production environment variables are configured

## Troubleshooting

### "API key not found" errors
1. Ensure `.env` file exists in the correct location
2. Check that `flutter_dotenv` is properly initialized in `main.dart`
3. Restart the Flutter app after changing `.env` files

### Firebase authentication issues
1. Verify `google-services.json` is in the correct location
2. Check Firebase project configuration
3. Ensure Firebase is initialized in the app

## Additional Resources
- [Firebase Security Checklist](https://firebase.google.com/docs/projects/checklist)
- [Flutter Environment Variables](https://pub.dev/packages/flutter_dotenv)
- [Git Security Best Practices](https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage)