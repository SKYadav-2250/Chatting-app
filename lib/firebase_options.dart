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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD8-s_1V_bxlMuomsJ8106uRGbOSW2Isu0',
    appId: '1:734499076822:android:7c829cc23273776933e777',
    messagingSenderId: '734499076822',
    projectId: 'flutter-project-55b71',
    databaseURL: 'https://flutter-project-55b71-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-project-55b71.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBh4yurbh2ka0xKxCzY4zGbm04DhND_L4k',
    appId: '1:734499076822:ios:3fe4c22b1f01b00b33e777',
    messagingSenderId: '734499076822',
    projectId: 'flutter-project-55b71',
    databaseURL: 'https://flutter-project-55b71-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-project-55b71.firebasestorage.app',
    androidClientId: '734499076822-jht21n1i9nls2otjjphgp3q2r3hl0a5s.apps.googleusercontent.com',
    iosClientId: '734499076822-g4sb6s897bm23hgrqvo2rnm3ciik3dcm.apps.googleusercontent.com',
    iosBundleId: 'com.example.chattingApp',
  );

}