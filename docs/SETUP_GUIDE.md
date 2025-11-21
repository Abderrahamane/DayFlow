# 🚀 DayFlow Setup Guide

This guide will help you set up the DayFlow project on your local machine, whether you're a beginner or experienced developer.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation Steps](#installation-steps)
- [Firebase Configuration](#firebase-configuration)
- [Running the App](#running-the-app)
- [Common Issues](#common-issues)
- [Development Workflow](#development-workflow)

---

## Prerequisites

Before you begin, make sure you have the following installed on your computer:

### Required Software

1. **Flutter SDK** (version 3.0.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Follow the installation guide for your operating system (Windows, macOS, or Linux)

2. **Android Studio** or **VS Code**
   - Android Studio: https://developer.android.com/studio
   - VS Code: https://code.visualstudio.com/
   - For VS Code, install Flutter and Dart extensions

3. **Git**
   - Download from: https://git-scm.com/downloads
   - For cloning the repository

4. **A Device or Emulator**
   - Android Device: Enable USB debugging
   - iOS Device: Requires macOS and Xcode
   - Android Emulator: Set up in Android Studio
   - iOS Simulator: Set up in Xcode (macOS only)

### Verify Installation

Open a terminal/command prompt and run:

```bash
# Check Flutter installation
flutter doctor

# You should see checkmarks for:
# ✓ Flutter
# ✓ Android toolchain
# ✓ Connected device (or emulator)
```

If you see any issues, follow the instructions provided by `flutter doctor`.

---

## Installation Steps

### Step 1: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/Abderrahamane/DayFlow.git

# Navigate to the project directory
cd DayFlow
```

### Step 2: Install Dependencies

```bash
# Get all Flutter packages
flutter pub get
```

This command will download all the packages listed in `pubspec.yaml`:
- `provider` - State management
- `firebase_core`, `firebase_auth`, `cloud_firestore` - Firebase integration
- `google_sign_in` - Google authentication
- `mixpanel_flutter` - Analytics
- `flutter_localizations` - Multi-language support
- `intl` - Internationalization
- `shared_preferences` - Local storage
- `fl_chart` - Charts and graphs
- `url_launcher` - Open URLs/email
- `country_flags` - Flag icons

**Expected output:**
```
Running "flutter pub get" in DayFlow...
Resolving dependencies... 
+ provider 6.1.1
+ firebase_core 3.6.0
+ firebase_auth 5.3.1
...
Got dependencies!
```

### Step 3: Verify Installation

```bash
# Check for any issues
flutter doctor -v

# Analyze the project
flutter analyze
```

---

## Firebase Configuration

DayFlow uses Firebase for authentication and database. You need to set up your own Firebase project.

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Enter project name: "DayFlow" (or your preferred name)
4. Disable Google Analytics (optional)
5. Click "Create Project"

### Step 2: Add Android App

1. In Firebase Console, click "Add App" → Android icon
2. Enter Android package name: `com.yourcompany.dayflow`
   - Find it in `android/app/build.gradle` → `applicationId`
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`

### Step 3: Add iOS App (if developing for iOS)

1. In Firebase Console, click "Add App" → iOS icon
2. Enter iOS bundle ID: `com.yourcompany.dayflow`
   - Find it in Xcode or `ios/Runner.xcodeproj`
3. Download `GoogleService-Info.plist`
4. Place it in: `ios/Runner/GoogleService-Info.plist`

### Step 4: Enable Authentication Methods

1. In Firebase Console, go to "Authentication" → "Sign-in method"
2. Enable **Email/Password**:
   - Click "Email/Password"
   - Toggle "Enable"
   - Save
3. Enable **Google**:
   - Click "Google"
   - Toggle "Enable"
   - Enter project support email
   - Save

### Step 5: Create Firestore Database

1. In Firebase Console, go to "Firestore Database"
2. Click "Create Database"
3. Start in **test mode** (for development)
   - Note: Change to production rules before deployment
4. Choose Cloud Firestore location (closest to your users)
5. Click "Enable"

### Step 6: Set Up Firestore Security Rules

In Firestore console, go to "Rules" tab and paste:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

Click "Publish" to save rules.

### Step 7: Update Firebase Configuration

The app should automatically use your Firebase configuration through the files you downloaded. If needed, regenerate configuration:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

---

## Mixpanel Configuration (Optional)

If you want to use analytics:

### Step 1: Create Mixpanel Account

1. Go to [Mixpanel](https://mixpanel.com/)
2. Sign up for free account
3. Create a new project: "DayFlow"
4. Copy your Project Token

### Step 2: Add Token to App

Open `lib/main.dart` and find line ~36:

```dart
await analyticsProvider.initialize('YOUR_MIXPANEL_TOKEN_HERE');
```

Replace `'YOUR_MIXPANEL_TOKEN_HERE'` with your actual token:

```dart
await analyticsProvider.initialize('abc123yourtokenhere');
```

**Note**: If you don't want analytics, you can skip this step. The app will work without Mixpanel.

---

## Running the App

### Option 1: Using Command Line

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run in release mode (faster, no debug tools)
flutter run --release
```

### Option 2: Using VS Code

1. Open project in VS Code
2. Open any `.dart` file
3. Press `F5` or click "Run" → "Start Debugging"
4. Select target device from bottom bar

### Option 3: Using Android Studio

1. Open project in Android Studio
2. Wait for indexing to complete
3. Select target device from device dropdown
4. Click green "Run" button (or press Shift+F10)

### Expected Behavior

1. **First Launch**:
   - App builds (may take 2-5 minutes first time)
   - App installs on device
   - Welcome screen appears
   - You can sign up or log in

2. **Subsequent Launches**:
   - Much faster (30 seconds or less)
   - If logged in, goes directly to home

---

## Common Issues

### Issue 1: "Gradle build failed"

**Symptom**: Android build fails with Gradle errors

**Solution**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue 2: "CocoaPods not installed" (macOS/iOS)

**Symptom**: iOS build fails with CocoaPods error

**Solution**:
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
flutter run
```

### Issue 3: "Firebase error: No such module"

**Symptom**: Firebase not found or configuration error

**Solution**:
1. Verify `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) is in correct location
2. Run `flutter clean` and `flutter pub get`
3. Rebuild the app

### Issue 4: "MissingPluginException"

**Symptom**: Plugin not found errors

**Solution**:
```bash
flutter clean
flutter pub get
# Completely stop the app and restart
flutter run
```

### Issue 5: Hot Reload Not Working

**Symptom**: Changes don't appear after saving file

**Solution**:
- Press `r` in terminal to hot reload manually
- Press `R` for hot restart
- Or use VS Code/Android Studio hot reload buttons

### Issue 6: "Mixpanel not initialized"

**Symptom**: Analytics errors in console

**Solution**:
- Add your Mixpanel token in `main.dart`
- Or remove Mixpanel tracking code if not using analytics

---

## Development Workflow

### Making Changes

1. **Create a Feature Branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Your Changes**:
   - Edit files in `lib/` directory
   - Save files
   - Hot reload to see changes: Press `r` in terminal

3. **Test Your Changes**:
   - Manually test all affected features
   - Check on different screen sizes
   - Test offline behavior

4. **Commit Your Changes**:
   ```bash
   git add .
   git commit -m "Description of your changes"
   git push origin feature/your-feature-name
   ```

5. **Create Pull Request**:
   - Go to GitHub repository
   - Click "Pull Requests" → "New Pull Request"
   - Add description and request review

### Code Style

Follow Flutter's style guide:
- Use `camelCase` for variables and methods
- Use `PascalCase` for classes
- Use `snake_case` for file names
- Add comments for complex logic
- Format code: `flutter format .`

### Testing

```bash
# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# Analyze code
flutter analyze
```

---

## Building for Production

### Android APK

```bash
# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (for Play Store)

```bash
# Build app bundle
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS App (macOS only)

```bash
# Build iOS app
flutter build ios --release

# Then open Xcode to archive and upload
open ios/Runner.xcworkspace
```

---

## Environment-Specific Configuration

### Development Environment

Create `.env.development`:
```
API_URL=http://localhost:5000
MIXPANEL_TOKEN=dev_token
ENABLE_ANALYTICS=false
```

### Production Environment

Create `.env.production`:
```
API_URL=https://api.dayflow.com
MIXPANEL_TOKEN=prod_token
ENABLE_ANALYTICS=true
```

**Note**: Add `.env.*` to `.gitignore` to keep secrets safe.

---

## Useful Commands

### Flutter

```bash
# Clean build files
flutter clean

# Get dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated

# Format all Dart files
flutter format .

# Analyze code for issues
flutter analyze

# Run tests
flutter test

# Generate documentation
dartdoc
```

### Git

```bash
# Check status
git status

# View changes
git diff

# Create branch
git checkout -b branch-name

# Switch branch
git checkout branch-name

# Pull latest changes
git pull origin main

# Push changes
git push origin branch-name
```

---

## Project Structure Quick Reference

```
DayFlow/
├── android/              # Android-specific files
├── ios/                  # iOS-specific files
├── lib/                  # Main Dart code
│   ├── main.dart         # Entry point
│   ├── models/           # Data models
│   ├── providers/        # State management
│   ├── services/         # External APIs
│   ├── pages/            # Screens
│   ├── widgets/          # Reusable UI
│   ├── utils/            # Helpers
│   └── theme/            # Styling
├── test/                 # Unit tests
├── docs/                 # Documentation
├── pubspec.yaml          # Dependencies
└── README.md             # Overview
```

---

## Resources

### Official Documentation
- Flutter: https://flutter.dev/docs
- Firebase: https://firebase.google.com/docs
- Dart: https://dart.dev/guides

### Community
- Flutter Community: https://flutter.dev/community
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter
- GitHub Issues: Report bugs in the repository

### Learning
- Flutter Codelabs: https://flutter.dev/docs/codelabs
- Flutter Widget of the Week: https://www.youtube.com/playlist?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG
- Provider Documentation: https://pub.dev/packages/provider

---

## Next Steps

After setup is complete:

1. ✅ Verify the app runs on your device
2. ✅ Create a test account and log in
3. ✅ Explore all features (tasks, habits, notes)
4. ✅ Read the architecture documentation (`docs/ARCHITECTURE.md`)
5. ✅ Review the code structure (`docs/FILE_STRUCTURE.md`)
6. ✅ Try making a small change (e.g., change a color)
7. ✅ Follow the development workflow
8. ✅ Join the team discussions

---

## Getting Help

If you're stuck:

1. Check this setup guide again
2. Read the error message carefully
3. Search for the error on Google or Stack Overflow
4. Check the GitHub Issues page
5. Ask in the team chat
6. Contact the team lead: Abderrahmane

---

## Summary Checklist

Before you start developing, make sure:

- [ ] Flutter SDK installed and working (`flutter doctor`)
- [ ] Project cloned and dependencies installed
- [ ] Firebase project created and configured
- [ ] Android app added to Firebase (if developing for Android)
- [ ] iOS app added to Firebase (if developing for iOS)
- [ ] Firestore database created
- [ ] Authentication methods enabled
- [ ] App runs successfully on device/emulator
- [ ] You can create an account and log in
- [ ] You understand the project structure
- [ ] You've read the documentation

**Happy coding! 🚀**
