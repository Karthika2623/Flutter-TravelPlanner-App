// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAg4XwJr1NDgODbeHme4s8lJFQ_czYtggw',
    appId: '1:745341427570:android:a203117f446474390487eb',
    messagingSenderId: '745341427570',
    projectId: 'travelplannerapp-29af6',
    storageBucket: 'travelplannerapp-29af6.firebasestorage.app',
  );
}
