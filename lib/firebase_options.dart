// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDt3emIKnv74fVJqKuwZxl7yu-eOp_EMdo',
    appId: '1:250508347403:web:4cd19dde4b49affc495f0e',
    messagingSenderId: '250508347403',
    projectId: 'charging-station-57b89',
    authDomain: 'charging-station-57b89.firebaseapp.com',
    storageBucket: 'charging-station-57b89.appspot.com',
    measurementId: 'G-Q9JX9HW6ED',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1U6S-lrHTBMttmnlAhKBhvuVOAJMGpgE',
    appId: '1:250508347403:android:b342e01fe5431f35495f0e',
    messagingSenderId: '250508347403',
    projectId: 'charging-station-57b89',
    storageBucket: 'charging-station-57b89.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDK_u-nsr-UGOdsWl6zFvi_7WJJBaLcOWg',
    appId: '1:250508347403:ios:aa13460b120af77b495f0e',
    messagingSenderId: '250508347403',
    projectId: 'charging-station-57b89',
    storageBucket: 'charging-station-57b89.appspot.com',
    iosBundleId: 'com.example.ownerEv',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDK_u-nsr-UGOdsWl6zFvi_7WJJBaLcOWg',
    appId: '1:250508347403:ios:aa13460b120af77b495f0e',
    messagingSenderId: '250508347403',
    projectId: 'charging-station-57b89',
    storageBucket: 'charging-station-57b89.appspot.com',
    iosBundleId: 'com.example.ownerEv',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDt3emIKnv74fVJqKuwZxl7yu-eOp_EMdo',
    appId: '1:250508347403:web:20da29d8391b37e2495f0e',
    messagingSenderId: '250508347403',
    projectId: 'charging-station-57b89',
    authDomain: 'charging-station-57b89.firebaseapp.com',
    storageBucket: 'charging-station-57b89.appspot.com',
    measurementId: 'G-Q2NSKZVF05',
  );
}