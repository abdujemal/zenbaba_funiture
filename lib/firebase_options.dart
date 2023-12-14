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
    apiKey: 'AIzaSyDbK_yIGsgV4sojW96R2TJekmghbuhe7UU',
    appId: '1:367227212802:web:fe547126046a75cffe431b',
    messagingSenderId: '367227212802',
    projectId: 'osman-furniture-project',
    authDomain: 'osman-furniture-project.firebaseapp.com',
    databaseURL: 'https://osman-furniture-project-default-rtdb.firebaseio.com',
    storageBucket: 'osman-furniture-project.appspot.com',
    measurementId: 'G-KYFM649G52',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlVFAkXn78Uk9VE3ckp5NSM0qhcGPCIvk',
    appId: '1:367227212802:android:ff2ca3b5b5349f77fe431b',
    messagingSenderId: '367227212802',
    projectId: 'osman-furniture-project',
    databaseURL: 'https://osman-furniture-project-default-rtdb.firebaseio.com',
    storageBucket: 'osman-furniture-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAw8CREkRc7agevYionxLFhx_qJbL3vSP4',
    appId: '1:367227212802:ios:5f78d2b31fc07177fe431b',
    messagingSenderId: '367227212802',
    projectId: 'osman-furniture-project',
    databaseURL: 'https://osman-furniture-project-default-rtdb.firebaseio.com',
    storageBucket: 'osman-furniture-project.appspot.com',
    androidClientId: '367227212802-irca8si5bukgu31033k3tr79cm72slti.apps.googleusercontent.com',
    iosClientId: '367227212802-h0tr4t30g0kq2qkcr320thshp90rmqnf.apps.googleusercontent.com',
    iosBundleId: 'com.example.zenbabaFuniture',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAw8CREkRc7agevYionxLFhx_qJbL3vSP4',
    appId: '1:367227212802:ios:d3a3ef75d092ab58fe431b',
    messagingSenderId: '367227212802',
    projectId: 'osman-furniture-project',
    databaseURL: 'https://osman-furniture-project-default-rtdb.firebaseio.com',
    storageBucket: 'osman-furniture-project.appspot.com',
    androidClientId: '367227212802-irca8si5bukgu31033k3tr79cm72slti.apps.googleusercontent.com',
    iosClientId: '367227212802-40fq6f0fc0g1uul7qurobumbdjoj1uu6.apps.googleusercontent.com',
    iosBundleId: 'com.example.zenbabaFuniture.RunnerTests',
  );
}
