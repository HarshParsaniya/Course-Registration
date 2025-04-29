import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web; // <-- your Web FirebaseOptions
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      // case TargetPlatform.iOS:
      //   return ios;
      // case TargetPlatform.macOS:
      //   return macos;
      case TargetPlatform.windows:
        throw UnsupportedError('Windows platform not supported on web.');
      default:
        throw UnsupportedError('Default platform not supported.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyCNT22ZryMIT9cHPTpq5ZW1yio2QI7vuoM",
      authDomain: "fir-tutorial-89b04.firebaseapp.com",
      projectId: "fir-tutorial-89b04",
      storageBucket: "fir-tutorial-89b04.firebasestorage.app",
      messagingSenderId: "10133084455",
      appId: "1:10133084455:web:9173593bb0b0f9447df102",
      measurementId: "G-LDB2FTYVB7");

  static const FirebaseOptions android = FirebaseOptions(
      apiKey: "AIzaSyCNT22ZryMIT9cHPTpq5ZW1yio2QI7vuoM",
      projectId: "fir-tutorial-89b04",
      storageBucket: "fir-tutorial-89b04.firebasestorage.app",
      messagingSenderId: "10133084455",
      appId: "1:10133084455:web:9173593bb0b0f9447df102",

    // authDomain: "student-registration-app-123.firebaseapp.com",
    // measurementId: "G-DY7FXL60Q1"
  );

  // You can define iOS, macOS options too if needed
}
