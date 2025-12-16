# Google Calendar Integration Setup

This document explains how to set up Google Calendar integration for the Supreme Steam booking app.

## Features Implemented

1. **Vehicle Type Selection**: Users can choose from Sedan, SUV, Truck, or Van/Minivan
2. **Date & Time Booking**: Interactive calendar to select appointment date and available time slots
3. **Google Calendar Integration**:
   - Sign in with Google account
   - Check real-time availability from your Google Calendar
   - Automatically create bookings in Google Calendar

## How to Set Up Google Calendar Integration

### Step 1: Create a Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the Google Calendar API:
   - Go to "APIs & Services" > "Library"
   - Search for "Google Calendar API"
   - Click "Enable"

### Step 2: Configure OAuth Consent Screen

1. Go to "APIs & Services" > "OAuth consent screen"
2. Choose "External" user type
3. Fill in the required information:
   - App name: Supreme Steam Detail
   - User support email: Your email
   - Developer contact: Your email
4. Add scopes:
   - `https://www.googleapis.com/auth/calendar.readonly`
   - `https://www.googleapis.com/auth/calendar.events`

### Step 3: Create OAuth 2.0 Credentials

#### For iOS:
1. Go to "APIs & Services" > "Credentials"
2. Click "Create Credentials" > "OAuth client ID"
3. Select "iOS" as application type
4. Enter your bundle identifier (e.g., `com.supremesteam.app`)
5. Download the credentials

Add the following to your `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
        </array>
    </dict>
</array>
```

#### For Android:
1. Create credentials for "Android" application type
2. Add SHA-1 fingerprint:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
3. Enter package name (e.g., `com.supremesteam.app`)

### Step 4: Update iOS Configuration

Update `ios/Runner/Info.plist` with Google Sign-In configuration:

```xml
<!-- Add after existing keys -->
<key>GIDClientID</key>
<string>YOUR-IOS-CLIENT-ID.apps.googleusercontent.com</string>
```

### Step 5: Test the Integration

1. Run the app on a real device or simulator
2. Navigate to the booking screen
3. Click "Sign in with Google"
4. Grant calendar permissions
5. Enter your Calendar ID (usually your Gmail address or calendar ID from Google Calendar settings)
6. Select a date and the app will show available time slots based on your calendar

## Using the App Without Google Calendar

The app works in "demo mode" without Google Calendar integration:
- All time slots from 8 AM to 6 PM are shown as available
- Bookings create a local confirmation but don't sync to calendar
- Perfect for testing the UI and flow

## Calendar ID

To find your Calendar ID:
1. Open [Google Calendar](https://calendar.google.com)
2. Click on the calendar you want to use (left sidebar)
3. Click the three dots > "Settings and sharing"
4. Scroll down to "Integrate calendar"
5. Copy the "Calendar ID" (usually looks like: `your-email@gmail.com` or `abc123@group.calendar.google.com`)

## Important Notes

- **iOS Simulator**: Google Sign-In may have limitations on iOS Simulator. Test on a real device for best results.
- **Privacy**: The app only reads calendar events to check availability and creates new events for bookings. It never modifies or deletes existing events.
- **Permissions**: Users must grant calendar access permissions when signing in.

## Troubleshooting

### "Sign in failed" error
- Verify OAuth credentials are correctly configured
- Check that the bundle identifier/package name matches your OAuth configuration
- Ensure Google Calendar API is enabled in your Google Cloud project

### "No available slots" shown
- Verify the Calendar ID is correct
- Check that you have access to the calendar
- Ensure the calendar has some free time slots

### Build errors on iOS
- Run `cd ios && pod install` to ensure all dependencies are installed
- Clean build: `flutter clean && flutter pub get`
- Restart Xcode if necessary

## Support

For issues or questions, please check:
- [Google Sign-In Flutter Plugin](https://pub.dev/packages/google_sign_in)
- [Google APIs Flutter Plugin](https://pub.dev/packages/googleapis)
- [Google Cloud Console](https://console.cloud.google.com/)
