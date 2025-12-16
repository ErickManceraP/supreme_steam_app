# How to Get Your Firebase Configuration Values

## Step 1: Go to Firebase Console

1. Visit [Firebase Console](https://console.firebase.google.com)
2. Select your "Supreme Steam" project

## Step 2: Get Configuration for Each Platform

### For Android:

1. In Firebase Console, click the **gear icon** ⚙️ next to "Project Overview"
2. Click **"Project settings"**
3. Scroll down to **"Your apps"** section
4. Click on your **Android app** (the one with Android icon)
5. In the **"SDK setup and configuration"** section, select **"Config"** (not "CDN")
6. You'll see a JSON object with these values:

```json
{
  "apiKey": "AIza...",
  "appId": "1:123456789:android:abc123...",
  "messagingSenderId": "123456789",
  "projectId": "your-project-id",
  "storageBucket": "your-project-id.appspot.com"
}
```

**Copy these values** and replace them in `lib/firebase_options.dart` under `FirebaseOptions android = FirebaseOptions(...)`

### For iOS:

1. Still in **Project settings** → **Your apps**
2. Click on your **iOS app** (the one with Apple icon)
3. In the **"SDK setup and configuration"** section, select **"Config"**
4. You'll see a JSON object similar to Android:

```json
{
  "apiKey": "AIza...",
  "appId": "1:123456789:ios:xyz789...",
  "messagingSenderId": "123456789",
  "projectId": "your-project-id",
  "storageBucket": "your-project-id.appspot.com",
  "iosBundleId": "com.bya.supremeSteam"
}
```

**Copy these values** and replace them in `lib/firebase_options.dart` under `FirebaseOptions ios = FirebaseOptions(...)`

### For macOS:

If you registered a macOS app, repeat the same steps as iOS. Otherwise, you can use the same iOS config.

## Step 3: Update firebase_options.dart

Open `lib/firebase_options.dart` and replace all the placeholder values:

**Before:**
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',  // ← Replace this
  appId: 'YOUR_ANDROID_APP_ID',    // ← Replace this
  // ...
);
```

**After:**
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyD1234567890abcdefghijklmnop',  // ← Your actual key
  appId: '1:123456789:android:abc123def456',     // ← Your actual app ID
  // ...
);
```

## Step 4: Update Info.plist with REVERSED_CLIENT_ID

1. After downloading `GoogleService-Info.plist` from Firebase Console (iOS app setup)
2. Open it in a text editor
3. Find this key:
```xml
<key>REVERSED_CLIENT_ID</key>
<string>com.googleusercontent.apps.123456789-abc123xyz</string>
```

4. Copy the string value (e.g., `com.googleusercontent.apps.123456789-abc123xyz`)
5. Open `ios/Runner/Info.plist`
6. Find line 55 and replace `YOUR-REVERSED-CLIENT-ID`:

**Before:**
```xml
<string>com.googleusercontent.apps.YOUR-REVERSED-CLIENT-ID</string>
```

**After:**
```xml
<string>com.googleusercontent.apps.123456789-abc123xyz</string>
```

## Step 5: Place Config Files

Make sure these files are in the correct locations:

- `GoogleService-Info.plist` → `ios/Runner/GoogleService-Info.plist`
- `google-services.json` → `android/app/google-services.json`

## Step 6: Configure Apple Sign-In (Optional but Recommended)

### In Xcode:
1. Open `ios/Runner.xcworkspace` in Xcode (NOT .xcodeproj)
2. Select your project in the left sidebar
3. Select the "Runner" target
4. Go to **"Signing & Capabilities"** tab
5. Click **"+ Capability"** button
6. Add **"Sign in with Apple"**

### In Apple Developer Portal:
1. Go to [Apple Developer](https://developer.apple.com/account)
2. Navigate to **Certificates, Identifiers & Profiles**
3. Click **Identifiers**
4. Select your app's Bundle ID (com.example.supremeSteam)
5. Check the box for **"Sign in with Apple"**
6. Click **Save**

## Step 7: Test Your Setup

Run the app:
```bash
flutter run
```

If you see any Firebase errors, check that:
- All API keys are correctly copied
- Config files are in the right locations
- Bundle ID matches in Firebase Console and Xcode
- You've enabled Google and Apple sign-in in Firebase Console

## Troubleshooting

### "Firebase initialization error"
- Check that `firebase_options.dart` has correct values (no placeholders like "YOUR_API_KEY")
- Make sure you replaced ALL placeholder values

### "Google Sign-In failed"
- Check that `google-services.json` is in `android/app/` folder
- Check that `GoogleService-Info.plist` is in `ios/Runner/` folder
- Verify REVERSED_CLIENT_ID in Info.plist matches the one in GoogleService-Info.plist

### "Apple Sign-In failed"
- Make sure you added the capability in Xcode
- Check that your Bundle ID has "Sign in with Apple" enabled in Apple Developer Portal
- Apple Sign-In only works on iOS 13+ and macOS 10.15+

## Quick Checklist

- [ ] Created Firebase project in console
- [ ] Registered Android app in Firebase
- [ ] Registered iOS app in Firebase
- [ ] Downloaded google-services.json and placed in android/app/
- [ ] Downloaded GoogleService-Info.plist and placed in ios/Runner/
- [ ] Updated firebase_options.dart with real API keys and app IDs
- [ ] Updated Info.plist with REVERSED_CLIENT_ID
- [ ] Enabled Google sign-in in Firebase Console
- [ ] Enabled Apple sign-in in Firebase Console
- [ ] Added "Sign in with Apple" capability in Xcode
- [ ] Enabled "Sign in with Apple" for Bundle ID in Apple Developer Portal
- [ ] Tested the app with `flutter run`
