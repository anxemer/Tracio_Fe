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
    apiKey: 'AIzaSyAEY_OhiAm57r4YxgFpyDDqnse2uI3cOoQ',
    appId: '1:985147212411:web:9973e187e157fe5f6658de',
    messagingSenderId: '985147212411',
    projectId: 'tracio-cbd26',
    authDomain: 'tracio-cbd26.firebaseapp.com',
    storageBucket: 'tracio-cbd26.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCYc6dN2b76GAnNms-evEHyqgK6d2yG7P0',
    appId: '1:985147212411:android:adef72010af0e5246658de',
    messagingSenderId: '985147212411',
    projectId: 'tracio-cbd26',
    storageBucket: 'tracio-cbd26.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBNnY8lq_NZw0qcMPXojsteOKEku9PGebk',
    appId: '1:985147212411:ios:621bf6d678d285146658de',
    messagingSenderId: '985147212411',
    projectId: 'tracio-cbd26',
    storageBucket: 'tracio-cbd26.firebasestorage.app',
    iosClientId: '985147212411-u1m2ajdf45vubl25f1chi1acagqdbq0q.apps.googleusercontent.com',
    iosBundleId: 'com.example.tracioFe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBNnY8lq_NZw0qcMPXojsteOKEku9PGebk',
    appId: '1:985147212411:ios:621bf6d678d285146658de',
    messagingSenderId: '985147212411',
    projectId: 'tracio-cbd26',
    storageBucket: 'tracio-cbd26.firebasestorage.app',
    iosClientId: '985147212411-u1m2ajdf45vubl25f1chi1acagqdbq0q.apps.googleusercontent.com',
    iosBundleId: 'com.example.tracioFe',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAEY_OhiAm57r4YxgFpyDDqnse2uI3cOoQ',
    appId: '1:985147212411:web:73a3b3a0472323c96658de',
    messagingSenderId: '985147212411',
    projectId: 'tracio-cbd26',
    authDomain: 'tracio-cbd26.firebaseapp.com',
    storageBucket: 'tracio-cbd26.firebasestorage.app',
  );

}