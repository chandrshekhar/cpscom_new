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

void requestPermissions() async {
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
  runApp(const MyApp());
}

firebaseConfig() async {
  requestPermissions();
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
