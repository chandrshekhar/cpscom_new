import 'dart:developer';
import 'package:cpscom_admin/Commons/app_strings.dart';
import 'package:cpscom_admin/Utils/dismis_keyboard.dart';
import 'package:cpscom_admin/global_bloc.dart';
import 'package:cpscom_admin/pushNotificationService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'Commons/theme.dart';
import 'Features/Splash/Presentation/splash_screen.dart';
import 'Utils/app_preference.dart';
import 'firebase_options.dart';

late final FirebaseApp firebaseApp;
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  if (kDebugMode) {
    log("Handling a background message messageID: ${message.messageId}");
    log("Handling a background message data: ${message.data.toString()}");
    log("Handling a background message notification: ${message.notification!.title}");
  }
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  log('User granted permission: ${settings.authorizationStatus}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // Status bar configuration
  await Firebase.initializeApp();
  firebaseConfig();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light));

  // Initialize Firebase to App
  // firebaseApp = await Firebase.initializeApp(
  //   name: AppStrings.appNameInFirebase,
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // const firebaseConfig = {
  //   "apiKey": "AIzaSyALDdPTyjaE6qad-Uc-hslCrR2PfknvhWE",
  //   "authDomain": "cpscom-aea2f.firebaseapp.com",
  //   "projectId": "cpscom-aea2f",
  //   "storageBucket": "cpscom-aea2f.appspot.com",
  //   "messagingSenderId": "985033228014",
  //   "appId": "1:985033228014:web:b48e1ab07d656c29b93dff"
  // };
  // firebaseConfig() async{
  //   await PushNotificationService().setupInteractedMessage();
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //   firebaseApp = await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );

  //   RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  //   String? fcmToken = await FirebaseMessaging.instance.getToken();

  //   AppPreference().saveFirebaseToken(token: fcmToken??"");

  // }
  //   firebaseApp = await Firebase.initializeApp(
  //       name: AppStrings.appNameInFirebase,
  //       options: DefaultFirebaseOptions.currentPlatform);

  // if (Platform.isIOS || Platform.isAndroid) {
  //   // Request Permission for Push Notification
  //   requestPermission();
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //   await FirebaseMessaging.instance.setAutoInitEnabled(true);
  //   LocalNotificationService.initialize();
  // }
  // Main Function to run the application
  runApp(const MyApp());
  // To Prevent Screenshot in app
  // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //   if (Platform.isAndroid) {
  //     await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  //   }
  // });
}

// Future<void> setFirebaseToken(String? token) async {
//   await FirebaseMessaging.instance.requestPermission();
//   if (token != null) {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .update({'pushToken': token});
//     await FirebaseFirestore.instance
//         .collection('group')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .update({'pushToken': token});
//     // .then((value) => print("setFirebaseToken then"))
//     // .onError((error, stackTrace) => print("setFirebaseToken $stackTrace"));
//   }
// }

firebaseConfig() async {
  await PushNotificationService().setupInteractedMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // RemoteMessage? initialMessage =
  //     await FirebaseMessaging.instance.getInitialMessage();

  String? fcmToken = await FirebaseMessaging.instance.getToken();
  // setFirebaseToken(fcmToken);
  AppPreference().saveFirebaseToken(token: fcmToken ?? "");
  await FirebaseMessaging.instance.requestPermission();

  log("FCM->$fcmToken");
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  // void initState() {
  //   super.initState();
  //   //1: This method only call when app is terminated
  //   FirebaseMessaging.instance.getInitialMessage().then((message) {
  //     if (kDebugMode) {
  //       log('This method only call when app is terminated pandey');
  //       log('Initial Message - ${FirebaseMessaging.instance.getInitialMessage()}');
  //     }
  //     if (message != null) {
  //       if (kDebugMode) {
  //         log('Got New Notification');
  //       }
  //     }
  //   });
  //   //2: This method only call when app is in foreground or app must be opened
  //   FirebaseMessaging.onMessage.listen((message) {
  //     if (kDebugMode) {
  //       log('This method only call when app is in foreground or app must be opened');
  //     }
  //     if (message.notification != null) {
  //       if (kDebugMode) {
  //         log('Notification Title - ${message.notification!.title}');
  //         log('Notification Body - ${message.notification!.body}');
  //         log("Notification Data - ${message.data}");
  //       }
  //       // LocalNotificationService.createDisplayNotification(message);
  //     }
  //   });
  //   //3: This method only call when app is in background and not terminated
  //   FirebaseMessaging.onMessageOpenedApp.listen((message) {
  //     if (kDebugMode) {
  //       log('This method only call when app is in background and not terminated');
  //     }
  //     if (message.notification != null) {
  //       if (kDebugMode) {
  //         log('Notification Title - ${message.notification!.title}');
  //         log('Notification Body - ${message.notification!.body}');
  //         log("Notification Data - ${message.data}");
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return DismissKeyBoard(
      child: GlobalBloc(
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          theme: AppTheme.lightTheme,
          themeMode: ThemeMode.light,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
