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
    apiKey: 'AIzaSyBtqaU2J5RR5NUs81gJ-5Axe6gi9yuFBgw',
    appId: '1:615169260208:android:29d0f785405ec084719975',
    messagingSenderId: '615169260208',
    projectId: 'multi-store-77dd2',
    storageBucket: 'multi-store-77dd2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDS_NJW0x7iN8R1okD8svdwMku6PFHS3Zc',
    appId: '1:615169260208:ios:4cf36c79ad474d2b719975',
    messagingSenderId: '615169260208',
    projectId: 'multi-store-77dd2',
    storageBucket: 'multi-store-77dd2.appspot.com',
    androidClientId: '615169260208-11gn3jijf3up3gt68eo0lgtu3vo0ma70.apps.googleusercontent.com',
    iosClientId: '615169260208-eh5l9hkbd7v8c3kvavsbfd11t1tq574g.apps.googleusercontent.com',
    iosBundleId: 'com.example.msSupplierApp',
  );
}
