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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB03-4_K1hBfa6XG5ZnWpYOYX-3v8jDNuQ',
    appId: '1:1069074406208:android:ae55b4d56a6d1b31c538a5',
    messagingSenderId: '1069074406208',
    projectId: 'demoapplication-f2e12',
    databaseURL: 'https://demoapplication-f2e12-default-rtdb.firebaseio.com',
    storageBucket: 'demoapplication-f2e12.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFZ9KvOva4TG9LpuA04VGxC41Ho0vTVTw',
    appId: '1:1069074406208:ios:bb68ee317a5ac126c538a5',
    messagingSenderId: '1069074406208',
    projectId: 'demoapplication-f2e12',
    databaseURL: 'https://demoapplication-f2e12-default-rtdb.firebaseio.com',
    storageBucket: 'demoapplication-f2e12.appspot.com',
    androidClientId: '1069074406208-48r1vks6hku1g0s162st69cmc25erodc.apps.googleusercontent.com',
    iosClientId: '1069074406208-88vc6o76qin3noleo9b271v8oothfism.apps.googleusercontent.com',
    iosBundleId: 'com.applify.flutter.library',
  );
}
