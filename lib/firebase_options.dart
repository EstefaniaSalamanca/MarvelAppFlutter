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
    apiKey: 'AIzaSyAHD3cXSJJw5PKfH0DW5XrMX6C-_16nT_4',
    appId: '1:1088041884070:web:e0921cbec9a38b8cf9d767',
    messagingSenderId: '1088041884070',
    projectId: 'marvelapp-flutter-project',
    authDomain: 'marvelapp-flutter-project.firebaseapp.com',
    databaseURL: 'https://marvelapp-flutter-project-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'marvelapp-flutter-project.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAU116gc5F22p1D0XmCz1otECD-maEL2pA',
    appId: '1:1088041884070:android:05c9af44fa3aed3af9d767',
    messagingSenderId: '1088041884070',
    projectId: 'marvelapp-flutter-project',
    databaseURL: 'https://marvelapp-flutter-project-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'marvelapp-flutter-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD97Ht_HcwFUv99r3-1wjaLN3M2ihHVOKI',
    appId: '1:1088041884070:ios:9d0560850608265ef9d767',
    messagingSenderId: '1088041884070',
    projectId: 'marvelapp-flutter-project',
    databaseURL: 'https://marvelapp-flutter-project-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'marvelapp-flutter-project.appspot.com',
    iosClientId: '1088041884070-8ovn4d5ulc12vvpsha4bu2vfvufqq203.apps.googleusercontent.com',
    iosBundleId: 'es-fanita.marvelapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD97Ht_HcwFUv99r3-1wjaLN3M2ihHVOKI',
    appId: '1:1088041884070:ios:44c2574234f92cdaf9d767',
    messagingSenderId: '1088041884070',
    projectId: 'marvelapp-flutter-project',
    databaseURL: 'https://marvelapp-flutter-project-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'marvelapp-flutter-project.appspot.com',
    iosClientId: '1088041884070-jkoscko3am1s7plvaf646u8b64lta5qo.apps.googleusercontent.com',
    iosBundleId: 'es-fanita.marvelapp.RunnerTests',
  );
}
