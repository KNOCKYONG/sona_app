# 📱 SONA App Store Submission Guide

## 🎯 Pre-Submission Checklist

### ✅ **Completed Requirements**

#### **Core App Structure**
- ✅ Firebase integration (Auth, Firestore, Crashlytics, Analytics)
- ✅ iOS platform configuration created
- ✅ Android manifest properly configured
- ✅ Crash reporting implemented (Firebase Crashlytics)
- ✅ Privacy Policy screen created (`/privacy-policy`)
- ✅ Terms of Service screen created (`/terms-of-service`)
- ✅ Release build configuration set up
- ✅ Proper app permissions declared

#### **Platform Configurations**
- ✅ Android package ID: `com.sona.app`
- ✅ iOS bundle ID: `com.sona.app`
- ✅ App name: "SONA" (consistent across platforms)
- ✅ Privacy usage descriptions added to iOS
- ✅ Network security configurations

### ⚠️ **Required Actions Before Submission**

#### **1. Create Release Signing Keys**

**Android:**
```bash
# Generate upload keystore
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Copy key.properties.template to key.properties and fill in:
cp android/key.properties.template android/key.properties
# Edit key.properties with your actual keystore information
```

**iOS:**
- Set up Apple Developer Account
- Create App Store Connect app entry
- Configure iOS certificates and provisioning profiles in Xcode

#### **2. Update App Version Information**
```yaml
# In pubspec.yaml, update version for release
version: 1.0.0+1  # Current version
# Change to: 1.0.0+1 (for first release)
```

#### **3. Build Release Versions**
```bash
# Android AAB for Play Store
flutter build appbundle --release

# iOS for App Store (requires macOS with Xcode)
flutter build ios --release
```

#### **4. Test on Physical Devices**
- Test all major features on Android and iOS devices
- Verify crash reporting works
- Test Google Sign-In flow
- Verify Firebase data synchronization

## 📋 **App Store Listing Requirements**

### **Google Play Store**

#### **Required Assets:**
- ✅ App icon (512x512px) - Using default Flutter icon (needs custom design)
- ⚠️ Feature graphic (1024x500px) - **NEEDS CREATION**
- ⚠️ Screenshots (minimum 2, maximum 8 per device type) - **NEEDS CREATION**
- ⚠️ App description (Korean/English) - **NEEDS WRITING**

#### **Store Listing Info:**
```
App Name: SONA
Short Description: AI 페르소나 대화 매칭 앱
Full Description: [Detailed description needed]
Category: Social
Content Rating: Everyone
```

#### **Privacy Policy:**
- ✅ Privacy policy URL: Will be in-app route `/privacy-policy`
- ✅ Data safety section: Complete based on Firebase usage

### **Apple App Store**

#### **Required Assets:**
- ✅ App icon (1024x1024px) - Using default Flutter icon (needs custom design)
- ⚠️ Screenshots for iPhone (6.5", 5.5", and iPad if supported) - **NEEDS CREATION**
- ⚠️ App preview videos (optional but recommended) - **NEEDS CREATION**

#### **App Information:**
```
App Name: SONA
Subtitle: AI 페르소나 대화 매칭
Category: Social Networking
Age Rating: 4+ (Everyone)
```

#### **App Review Information:**
- ⚠️ Demo account credentials (if login required) - **PREPARE TEST ACCOUNT**
- ⚠️ Review notes explaining app functionality - **NEEDS WRITING**

## 🛡️ **Privacy & Security Compliance**

### **Data Collection Disclosure**
The app collects:
- User account information (Google Sign-In)
- Chat conversation data
- Usage analytics
- Crash reports

### **GDPR/Privacy Compliance**
- ✅ Privacy policy available in-app
- ✅ User can delete account and data
- ✅ Data encryption in transit (HTTPS)
- ✅ Data encryption at rest (Firebase default)

## 🚀 **Final Steps for Submission**

### **1. Pre-Launch Testing**
```bash
# Run Flutter tests
flutter test

# Check for code issues
flutter analyze

# Build and test release versions
flutter build appbundle --release
flutter build ios --release
```

### **2. Asset Creation (Required)**
- Create custom app icon (1024x1024)
- Design feature graphic for Google Play
- Take screenshots on multiple device sizes
- Prepare app store descriptions

### **3. Submit to Stores**

**Google Play Console:**
1. Upload AAB file
2. Complete store listing
3. Set up app pricing (Free)
4. Configure content ratings
5. Submit for review

**Apple App Store Connect:**
1. Upload IPA via Xcode or Application Loader
2. Complete app information
3. Set pricing (Free)
4. Configure age ratings
5. Submit for review

## 📞 **Support Information**

### **Contact Details for Store Listings:**
```
Developer: SONA Team
Email: support@sona-app.com
Privacy Email: privacy@sona-app.com
Website: [To be created]
```

## ⚡ **Common Issues & Solutions**

### **Google Play Store**
- **Issue**: "App not using latest API level"
  - **Solution**: Update `targetSdk` in `build.gradle.kts`

- **Issue**: "Missing privacy policy"
  - **Solution**: ✅ Already implemented in-app

### **Apple App Store**
- **Issue**: "Missing usage descriptions"
  - **Solution**: ✅ Already added to Info.plist

- **Issue**: "App Transport Security issues"
  - **Solution**: ✅ Already configured in Info.plist

## 📈 **Post-Launch Monitoring**

### **Analytics Setup**
- ✅ Firebase Analytics configured
- ✅ Crashlytics for error monitoring
- ✅ Performance monitoring enabled

### **User Feedback Channels**
- In-app feedback system (consider implementing)
- App Store reviews monitoring
- Direct email support

## 🔄 **Update Process**

For future updates:
1. Update version in `pubspec.yaml`
2. Test thoroughly
3. Build release versions
4. Update store listings if needed
5. Submit updated builds

---

**Note**: This app is ready for submission pending the creation of store assets (icons, screenshots, descriptions) and proper signing key setup.