# Firebase Authentication Setup Guide

This guide will help you set up Firebase Authentication with Google and Apple Sign-In for the Supreme Steam app.

## Prerequisites

1. A Firebase project (create one at [Firebase Console](https://console.firebase.google.com))
2. Flutter CLI installed
3. FlutterFire CLI installed

## Step 1: Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

## Step 2: Configure Firebase

Run this command in your project root:

```bash
flutterfire configure
```

This will:
- Create a Firebase project (or use an existing one)
- Register your iOS and Android apps
- Download the configuration files
- Generate `firebase_options.dart`

## Step 3: Enable Authentication Methods in Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Go to **Authentication** → **Sign-in method**
4. Enable **Google** sign-in
5. Enable **Apple** sign-in (for iOS only)

## Step 4: Configure Google Sign-In

### For Android:
1. The SHA-1 key should be automatically added by FlutterFire CLI
2. If not, get your SHA-1:
   ```bash
   cd android
   ./gradlew signingReport
   ```
3. Add the SHA-1 to Firebase Console → Project Settings → Your Android app

### For iOS:
1. Add the reversed client ID to `ios/Runner/Info.plist`:
   - Get it from `GoogleService-Info.plist` (REVERSED_CLIENT_ID)
   - Add this to Info.plist:
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleTypeRole</key>
       <string>Editor</string>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>YOUR_REVERSED_CLIENT_ID</string>
       </array>
     </dict>
   </array>
   ```

## Step 5: Configure Apple Sign-In (iOS only)

### In Firebase Console:
1. Go to Authentication → Sign-in method → Apple
2. Enable it
3. Configure Services ID (optional for web)

### In Xcode:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select your project → Runner → Signing & Capabilities
3. Click **+ Capability**
4. Add **Sign in with Apple**

### In Apple Developer Portal:
1. Go to [Apple Developer](https://developer.apple.com/account)
2. Certificates, Identifiers & Profiles → Identifiers
3. Select your App ID
4. Enable **Sign in with Apple**
5. Save

## Step 6: Update iOS Info.plist

Add to `ios/Runner/Info.plist`:

```xml
<key>NSAppleEventsUsageDescription</key>
<string>This app needs to sign in with Apple</string>
```

## Step 7: Test the App

```bash
flutter run
```

## Features Implemented

- ✅ Google Sign-In
- ✅ Apple Sign-In (iOS/macOS only)
- ✅ Guest mode (continue without login)
- ✅ User profile with logout
- ✅ Automatic authentication state management
- ✅ Modern login UI with gradients

## Troubleshooting

### Google Sign-In Issues:
- Make sure SHA-1 is correctly added in Firebase Console
- Check that `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are in the correct locations
- Verify package name matches in Firebase Console

### Apple Sign-In Issues:
- Apple Sign-In only works on iOS 13+ and macOS 10.15+
- Make sure capability is added in Xcode
- Check Bundle ID matches in Apple Developer Portal

### Firebase Initialization Error:
If you see "Firebase initialization error", run:
```bash
flutterfire configure
```

## Security Notes

- Never commit `google-services.json` or `GoogleService-Info.plist` to public repositories
- Add them to `.gitignore` if needed (they're safe for private repos)
- Use Firebase security rules to protect user data

## Next Steps

1. Set up Firebase Firestore for user data (optional)
2. Add password reset functionality
3. Implement email/password authentication
4. Add user profile management
5. Set up push notifications

## Support

For more information:
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev)
- [Google Sign-In Package](https://pub.dev/packages/google_sign_in)
- [Sign in with Apple Package](https://pub.dev/packages/sign_in_with_apple)
