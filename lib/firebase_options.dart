// File generated manually - Replace with your Firebase project configuration
// Get these values from: Firebase Console > Project Settings > Your apps

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDV_wr0yPIRk13YoIRvG2ChQ3yL7NvEAYY',
    appId: '1:1007589703352:android:2bc8d4784b3f4fabe37e4d',
    messagingSenderId: '1007589703352',
    projectId: 'supreme-steam',
    storageBucket: 'supreme-steam.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDKwv6a---m47lBMVrLqiUqNT0xAQULUy8',
    appId: '1:1007589703352:ios:66cc6aa8839a263fe37e4d',
    messagingSenderId: '1007589703352',
    projectId: 'supreme-steam',
    storageBucket: 'supreme-steam.firebasestorage.app',
    iosBundleId: 'com.bya.supremeSteam',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDKwv6a---m47lBMVrLqiUqNT0xAQULUy8',
    appId: '1:1007589703352:ios:66cc6aa8839a263fe37e4d',
    messagingSenderId: '1007589703352',
    projectId: 'supreme-steam',
    storageBucket: 'supreme-steam.firebasestorage.app',
    iosBundleId: 'com.bya.supremeSteam',
  );
}
