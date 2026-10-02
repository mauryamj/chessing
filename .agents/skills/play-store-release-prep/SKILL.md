---
name: play-store-release-prep
description: Step-by-step checklist and commands for preparing a signed, Play-Store-ready release APK/AAB. Use when the user asks about publishing, release builds, signing, or Play Store submission.
---

# Skill: Play Store Release Preparation

## Pre-Flight Checklist

Before generating a release build, verify every item:

### 1. Application ID
```gradle
// android/app/build.gradle
defaultConfig {
    applicationId "io.chessing.app"  // ← must NOT be com.example.*
    minSdkVersion 21
    targetSdkVersion 34
    versionCode 1        // ← increment on every upload
    versionName "1.0.0"
}
```

### 2. Generate a Signing Keystore (one-time)
```bash
keytool -genkey -v \
  -keystore android/app/chessing-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias chessing-key
```
> Store the keystore password and alias password in a password manager. Never commit the `.jks` to git.

Add to `.gitignore`:
```
android/app/*.jks
android/app/*.keystore
android/key.properties
```

### 3. Create `android/key.properties`
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=chessing-key
storeFile=chessing-release.jks
```

### 4. Wire Signing into `build.gradle`
```gradle
// android/app/build.gradle — at top, before android {}
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('app/key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

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
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 5. Build Release AAB (preferred over APK for Play Store)
```bash
flutter build appbundle --release \
  --obfuscate \
  --split-debug-info=build/debug-info/ \
  --dart-define=GEMINI_API_KEY=""
```

### 6. Verify the Bundle
```bash
# Verify signing
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab

# Check bundle size
ls -lh build/app/outputs/bundle/release/
```

### 7. App Icon Generation
```bash
# Add flutter_launcher_icons to dev_dependencies
# Create a 1024x1024 icon at assets/icon/icon.png
# Add to pubspec.yaml:
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon.png"
  min_sdk_android: 21
  adaptive_icon_background: "#1A1A2E"
  adaptive_icon_foreground: "assets/icon/icon_foreground.png"

# Generate
dart run flutter_launcher_icons
```

### 8. Privacy Policy
A public URL is required. Options:
- GitHub Pages with a simple HTML page
- Notion public page
- Firebase Hosting static page

Add the URL in:
- Play Console → App content → Privacy policy
- The app's Settings screen (link to it)

### 9. CI/CD: Add Signing Secrets to GitHub
```
KEYSTORE_BASE64      # base64-encoded .jks: base64 -i chessing-release.jks
KEY_ALIAS            # chessing-key
KEY_PASSWORD         # your key password
STORE_PASSWORD       # your store password
GOOGLE_SERVICES_JSON # base64-encoded google-services.json
```

### 10. CI Signing Step (add to `build_apk.yml`)
```yaml
- name: Decode keystore
  run: |
    echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 --decode > android/app/chessing-release.jks

- name: Create key.properties
  run: |
    echo "storePassword=${{ secrets.STORE_PASSWORD }}" > android/key.properties
    echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
    echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties
    echo "storeFile=chessing-release.jks" >> android/key.properties

- name: Decode google-services.json
  run: |
    echo "${{ secrets.GOOGLE_SERVICES_JSON }}" | base64 --decode > android/app/google-services.json

- name: Build AAB
  run: |
    flutter build appbundle --release \
      --obfuscate \
      --split-debug-info=build/debug-info/
```

## Play Store Submission Checklist

- [ ] `applicationId` is not `com.example.*`
- [ ] `versionCode` is higher than any previous upload
- [ ] App is signed with release keystore
- [ ] Privacy policy URL is live and accessible
- [ ] At least 3 screenshots (phone form factor, 1080×1920 minimum)
- [ ] Short description (≤80 chars)
- [ ] Full description (≤4000 chars)
- [ ] Content rating questionnaire completed
- [ ] Data safety form filled (you collect: name, email via Google Sign-In, gameplay data)
- [ ] Target audience: 13+ (chess is suitable for all ages, but Google Sign-In requires 13+)

## Affected Files
- `android/app/build.gradle`
- `android/key.properties` (new, gitignored)
- `android/app/chessing-release.jks` (new, gitignored)
- `.github/workflows/build_apk.yml`
- `pubspec.yaml` (add `flutter_launcher_icons`)
