import 'package:firebase_core/firebase_core.dart';
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
      // case TargetPlatform.iOS:
      //   return ios;
      // case TargetPlatform.macOS:
      //   return macos;
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
    apiKey: 'AIzaSyDIA_Pvr5vfCoROp0G24AcLLQRMpQwRWYI',
    appId: '1:262232334190:android:6b6e6e8ced7fb0a014ab7f',
    databaseURL: "https://masarisalik2-default-rtdb.firebaseio.com",
    messagingSenderId: '262232334190',
    projectId: 'masarisalik2',
    storageBucket: 'masarisalik2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDIA_Pvr5vfCoROp0G24AcLLQRMpQwRWYI',
    appId: '1:262232334190:android:6b6e6e8ced7fb0a014ab7f',
    databaseURL: "https://masarisalik2-default-rtdb.firebaseio.com",
    messagingSenderId: '262232334190',
    projectId: 'masarisalik2',
    storageBucket: 'masarisalik2.appspot.com',
  );
}
