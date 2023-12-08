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
     //  throw UnsupportedError("DeafultFirebase option has not be confug");
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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
    apiKey: 'AIzaSyALDdPTyjaE6qad-Uc-hslCrR2PfknvhWE',
    appId: '1:985033228014:web:b48e1ab07d656c29b93dff',
    messagingSenderId: '985033228014',
    projectId: 'cpscom-aea2f',
    authDomain: 'cpscom-aea2f.firebaseapp.com',
    storageBucket: 'cpscom-aea2f.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCo5IGoy8C9xhexGxkOO4i69xzsV11OSAY',
    appId: '1:985033228014:android:eea627ee03a8e6d2b93dff',
    messagingSenderId: '985033228014',
    projectId: 'cpscom-aea2f',
    storageBucket: 'cpscom-aea2f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAFj8TKoqubHiHqa2Q0NaIt4wnBpr2K7gg',
    appId: '1:985033228014:ios:4cb538ff518d8e09b93dff',
    messagingSenderId: '985033228014',
    projectId: 'cpscom-aea2f',
    storageBucket: 'cpscom-aea2f.appspot.com',
    iosClientId: '985033228014-s1tomr1pu3nq8ta76fki0pf495garjhs.apps.googleusercontent.com',
    iosBundleId: 'us.csic.cpscomc.ios',
  );

  // static const FirebaseOptions macos = FirebaseOptions(
  //   apiKey: 'AIzaSyAFj8TKoqubHiHqa2Q0NaIt4wnBpr2K7gg',
  //   appId: '1:985033228014:ios:527657c51795697eb93dff',
  //   messagingSenderId: '985033228014',
  //   projectId: 'cpscom-aea2f',
  //   storageBucket: 'cpscom-aea2f.appspot.com',
  //   iosClientId: '985033228014-m2eks9vv3q58al9r2q23ogkp3civh00m.apps.googleusercontent.com',
  //   iosBundleId: 'com.app.cpscomAdmin',
  // );
}
