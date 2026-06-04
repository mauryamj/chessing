import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCruGFSkBbD_RU74JbOqFCGx1sV7UqfKgo',
    appId: '1:270105926493:web:placeholder',
    messagingSenderId: '270105926493',
    projectId: 'chessing-app-mauryamj',
    authDomain: 'chessing-app-mauryamj.firebaseapp.com',
    storageBucket: 'chessing-app-mauryamj.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCruGFSkBbD_RU74JbOqFCGx1sV7UqfKgo',
    appId: '1:270105926493:android:a2bc3406a96cb5297da6b4',
    messagingSenderId: '270105926493',
    projectId: 'chessing-app-mauryamj',
    storageBucket: 'chessing-app-mauryamj.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDUMDzi1kyFW9CRPoE2JQIuhcVWPtthIvI',
    appId: '1:270105926493:ios:84ace92ec4087a5b7da6b4',
    messagingSenderId: '270105926493',
    projectId: 'chessing-app-mauryamj',
    storageBucket: 'chessing-app-mauryamj.firebasestorage.app',
    iosBundleId: 'com.example.chessing',
  );
}
