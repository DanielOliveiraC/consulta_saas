import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions have not been configured for this platform - '
      'you can reconfigure this by running the FlutterFire CLI again.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyASJTKc_uF-uT6tupEqkY1JV2Fic3OyXz4',
    appId: '1:676743833800:web:9920d0ad1968da8be9ddfd',
    messagingSenderId: '676743833800',
    projectId: 'saas-consultas',
    authDomain: 'saas-consultas.firebaseapp.com',
    storageBucket: 'saas-consultas.firebasestorage.app',
    measurementId: 'G-S5SJKDGTPT',
  );
}
