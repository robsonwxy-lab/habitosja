import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBwSNVfp1VYA4eE0_cNNeOwDsAaYQoBa1Q',
    appId: '1:155855769355:web:b6a796f5233503424ddc0e',
    messagingSenderId: '155855769355',
    projectId: 'habitoja-app',
    authDomain: 'habitoja-app.firebaseapp.com',
    storageBucket: 'habitoja-app.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCPGMLav0SNAYyH6e3NQtrjMXBr0HYUVbI',
    appId: '1:155855769355:android:d0852a6e8af9c0c34ddc0e',
    messagingSenderId: '155855769355',
    projectId: 'habitoja-app',
    storageBucket: 'habitoja-app.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBovIrqE9VmEi2kDN1PnD9-f0pvlfpD6VI',
    appId: '1:155855769355:ios:41593f0c9226f5894ddc0e',
    messagingSenderId: '155855769355',
    projectId: 'habitoja-app',
    storageBucket: 'habitoja-app.firebasestorage.app',
    iosBundleId: 'com.example.habitosja',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBovIrqE9VmEi2kDN1PnD9-f0pvlfpD6VI',
    appId: '1:155855769355:ios:41593f0c9226f5894ddc0e',
    messagingSenderId: '155855769355',
    projectId: 'habitoja-app',
    storageBucket: 'habitoja-app.firebasestorage.app',
    iosBundleId: 'com.example.habitosja',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBwSNVfp1VYA4eE0_cNNeOwDsAaYQoBa1Q',
    appId: '1:155855769355:web:da7464748ee4b7d64ddc0e',
    messagingSenderId: '155855769355',
    projectId: 'habitoja-app',
    authDomain: 'habitoja-app.firebaseapp.com',
    storageBucket: 'habitoja-app.firebasestorage.app',
  );
  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyDemoLinuxKey123456789',
    appId: '1:123456789:web:abcdef123456',
    messagingSenderId: '123456789',
    projectId: 'seu-projeto-id',
    authDomain: 'seu-projeto-id.firebaseapp.com',
    storageBucket: 'seu-projeto-id.appspot.com',
    measurementId: 'G-ABCDEF1234',
  );
}
