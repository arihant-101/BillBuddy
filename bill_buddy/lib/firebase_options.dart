// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA6Nvoxfx8jJmqa7VX9uPjqfaeX_aaaw8Q',
    appId: '1:1014283995484:web:4007004058f987c24fd999',
    messagingSenderId: '1014283995484',
    projectId: 'billbuddy102',
    authDomain: 'billbuddy102.firebaseapp.com',
    storageBucket: 'billbuddy102.appspot.com',
    measurementId: 'G-RVNF3RC04T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBrecAtCt_x7ukQlSF8h8JmjdNGDEZ3GlI',
    appId: '1:1014283995484:android:9671482223d41df34fd999',
    messagingSenderId: '1014283995484',
    projectId: 'billbuddy102',
    storageBucket: 'billbuddy102.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAExGoFllzW-1JtR8SAM2FW7HSnDZ7xd_g',
    appId: '1:1014283995484:ios:36b961d4bd27abb14fd999',
    messagingSenderId: '1014283995484',
    projectId: 'billbuddy102',
    storageBucket: 'billbuddy102.appspot.com',
    iosBundleId: 'com.example.billBuddy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAExGoFllzW-1JtR8SAM2FW7HSnDZ7xd_g',
    appId: '1:1014283995484:ios:8a10b525d1da32da4fd999',
    messagingSenderId: '1014283995484',
    projectId: 'billbuddy102',
    storageBucket: 'billbuddy102.appspot.com',
    iosBundleId: 'com.example.billBuddy.RunnerTests',
  );
}
