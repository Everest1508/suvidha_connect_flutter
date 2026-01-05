# Android App Publishing Checklist

## ✅ Completed Items

### 1. Legal Documents
- ✅ Terms and Conditions screen (`/terms-conditions`)
- ✅ Privacy Policy screen (`/privacy-policy`)
- ✅ About Us screen (`/about-us`)
- ✅ All screens accessible from Settings and Profile screens

### 2. App Metadata
- ✅ App name: "Sahayak" (updated in AndroidManifest.xml)
- ✅ App version: 1.0.0+1 (in pubspec.yaml)
- ✅ App description: "Sahayak - A service marketplace app connecting service providers with consumers"

### 3. Permissions
The following permissions are already configured in AndroidManifest.xml:
- ✅ INTERNET
- ✅ ACCESS_FINE_LOCATION
- ✅ ACCESS_COARSE_LOCATION
- ✅ CAMERA
- ✅ READ_EXTERNAL_STORAGE
- ✅ WRITE_EXTERNAL_STORAGE

## 📋 Remaining Tasks for Publishing

### 1. App Icon and Splash Screen
- [ ] Create app icon (1024x1024 for Play Store, various sizes for Android)
- [ ] Create splash screen assets
- [ ] Update `android/app/src/main/res/mipmap-*/ic_launcher.png` files

### 2. App Signing
- [ ] Generate a keystore file for app signing
- [ ] Configure signing in `android/app/build.gradle`:
  ```gradle
  android {
      signingConfigs {
          release {
              keyAlias keystoreProperties['keyAlias']
              keyPassword keystoreProperties['keyPassword']
              storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
              storePassword keystoreProperties['storePassword']
          }
      }
      buildTypes {
          release {
              signingConfig signingConfigs.release
          }
      }
  }
  ```

### 3. Update App Information
- [ ] Update contact information in:
  - Terms & Conditions screen
  - Privacy Policy screen
  - About Us screen
- [ ] Replace placeholder contact details:
  - Email: support@suvidhaconnect.com
  - Phone: +91-XXXXXXXXXX
  - Address: [Your Company Address]

### 4. Google Play Console Requirements
- [ ] Create Google Play Developer account ($25 one-time fee)
- [ ] Prepare app listing:
  - [ ] App name (max 50 characters)
  - [ ] Short description (max 80 characters)
  - [ ] Full description (max 4000 characters)
  - [ ] Feature graphic (1024x500)
  - [ ] Screenshots (at least 2, up to 8)
    - Phone: 16:9 or 9:16, min 320px, max 3840px
    - Tablet: 16:9 or 9:16, min 320px, max 3840px
  - [ ] App icon (512x512, 32-bit PNG)
  - [ ] Promo video (optional, YouTube URL)

### 5. Content Rating
- [ ] Complete content rating questionnaire
- [ ] App is likely rated "Everyone" or "Teen" depending on content

### 6. Privacy Policy URL
- [ ] Host Privacy Policy on a publicly accessible URL
- [ ] Update Privacy Policy screen to link to hosted version
- [ ] Provide URL in Google Play Console

### 7. Data Safety Section
- [ ] Complete Data Safety form in Play Console:
  - [ ] Data collection practices
  - [ ] Data sharing practices
  - [ ] Security practices
  - [ ] Data deletion options

### 8. Target Audience
- [ ] Set target audience (age groups)
- [ ] Set content rating
- [ ] Set target countries

### 9. Pricing and Distribution
- [ ] Set app as Free or Paid
- [ ] Select countries for distribution
- [ ] Set up in-app purchases (if applicable)

### 10. Testing
- [ ] Test on multiple Android devices/versions
- [ ] Test all features thoroughly
- [ ] Test payment flows
- [ ] Test location services
- [ ] Test camera and file uploads
- [ ] Test on different screen sizes

### 11. Build Release APK/AAB
- [ ] Build release bundle (AAB) for Play Store:
  ```bash
  flutter build appbundle --release
  ```
- [ ] Or build APK for direct distribution:
  ```bash
  flutter build apk --release
  ```

### 12. ProGuard/R8 Rules (if needed)
- [ ] Add ProGuard rules if using obfuscation
- [ ] Test release build with ProGuard enabled

### 13. Firebase Configuration
- [ ] Ensure Firebase is properly configured for production
- [ ] Update `google-services.json` for production
- [ ] Test push notifications in production

### 14. API Configuration
- [ ] Ensure production API base URL is set
- [ ] Test all API endpoints
- [ ] Ensure SSL certificates are valid

### 15. Additional Considerations
- [ ] Review and update all placeholder text
- [ ] Ensure all images are optimized
- [ ] Check for any hardcoded test data
- [ ] Review error messages for user-friendliness
- [ ] Add analytics (Firebase Analytics, etc.)
- [ ] Set up crash reporting (Firebase Crashlytics)

## 📝 Notes

- The app currently uses `http://192.168.1.15:8000/api` for local development
- Remember to switch to production URL before publishing
- All legal screens are accessible from:
  - Settings screen (Legal & Support section)
  - Profile screen (menu items)

## 🔗 Useful Links

- [Google Play Console](https://play.google.com/console)
- [Flutter App Publishing Guide](https://docs.flutter.dev/deployment/android)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [Play Store Listing Best Practices](https://support.google.com/googleplay/android-developer/answer/9866151)

