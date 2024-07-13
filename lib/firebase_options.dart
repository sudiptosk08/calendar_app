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
// / await Firebase.initializeApp(
// /   options: DefaultFirebaseOptions.currentPlatform,
// / );
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
    apiKey: 'AIzaSyAznX_FBPjK1FLbfwpokcDV2TCfhCAsikA',
    appId: '1:130356106519:web:ca9d9b0ac6c5b29f4e5352',
    messagingSenderId: '130356106519',
    projectId: 'calendar-8aea6',
    authDomain: 'calendar-8aea6.firebaseapp.com',
    storageBucket: 'calendar-8aea6.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAquEcydL4YNubZsHkevkRKUrUfSWXNf2Y',
    appId: '1:130356106519:android:3b4cf451b6ecd4d24e5352',
    messagingSenderId: '130356106519',
    projectId: 'calendar-8aea6',
    storageBucket: 'calendar-8aea6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCvy5xDFTQz5jcmSyMFog4vXI5fdcb_DQA',
    appId: '1:130356106519:ios:44be191e6626e4754e5352',
    messagingSenderId: '130356106519',
    projectId: 'calendar-8aea6',
    storageBucket: 'calendar-8aea6.appspot.com',
    iosBundleId: 'com.example.calendarApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCvy5xDFTQz5jcmSyMFog4vXI5fdcb_DQA',
    appId: '1:130356106519:ios:44be191e6626e4754e5352',
    messagingSenderId: '130356106519',
    projectId: 'calendar-8aea6',
    storageBucket: 'calendar-8aea6.appspot.com',
    iosBundleId: 'com.example.calendarApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAznX_FBPjK1FLbfwpokcDV2TCfhCAsikA',
    appId: '1:130356106519:web:0360ab609ff0674d4e5352',
    messagingSenderId: '130356106519',
    projectId: 'calendar-8aea6',
    authDomain: 'calendar-8aea6.firebaseapp.com',
    storageBucket: 'calendar-8aea6.appspot.com',
  );
}
