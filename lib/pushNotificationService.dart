import 'dart:developer';
import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:cpscom_admin/Features/Chat/Presentation/chat_screen.dart';
import 'package:cpscom_admin/Features/Home/Controller/group_list_controller.dart';
import 'package:cpscom_admin/Features/Home/Controller/socket_controller.dart';
import 'package:cpscom_admin/Utils/navigator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_icon_badge/flutter_app_icon_badge.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

// class PushNotificationService {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> setupInteractedMessage() async {
//     await enableIOSNotifications();
//     await registerNotificationListeners();

//     //This is for open the chat screen when tap on the notification
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       log("App was opened by a notification: ${message.data}");
//       doNavigator(route: ChatScreen(groupId: message.data['grp']), context: Get.context!);
//     });

//     // Handle notification when app is opened from a terminated state
//     FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
//       if (message != null) {
//         log("App launched from terminated state by notification: ${message.data}");
//         // Handle the notification (navigate or perform other actions)
//       }
//     });

//     FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
//       log("remoteMsgf --- > ${message!.notification}");
//       AndroidNotification? android = message.notification?.android;

//       AndroidNotificationChannel channel = androidNotificationChannel();
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);

//       flutterLocalNotificationsPlugin.show(
//         message.notification.hashCode,
//         message.notification?.title,
//         message.notification?.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             channelDescription: channel.description,
//             icon: android?.smallIcon,
//             priority: Priority.high,
//             importance: Importance.high,
//             playSound: true, // Ensures sound is played
//           ),
//           iOS: const DarwinNotificationDetails(
//             presentAlert: true,
//             presentBadge: false,
//             presentSound: true,
//           ),
//         ),
//       );
//     });
//   }

//   Future<void> enableIOSNotifications() async {
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true, // Required to display a heads-up notification
//       badge: false,
//       sound: true,
//     );
//   }

//   Future<void> registerNotificationListeners() async {
//     AndroidNotificationChannel channel = androidNotificationChannel();
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     var androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iOSSettings = const DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: false,
//       requestSoundPermission: true,
//     );
//     var initSettings = InitializationSettings(android: androidSettings, iOS: iOSSettings);
//     await flutterLocalNotificationsPlugin.initialize(initSettings,
//         onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
//       switch (notificationResponse.notificationResponseType) {
//         case NotificationResponseType.selectedNotification:
//           break;
//         case NotificationResponseType.selectedNotificationAction:
//           break;
//       }
//     });
//   }

//   // Background hand
//   AndroidNotificationChannel androidNotificationChannel() {
//     return const AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       description: 'This channel is used for important notifications.', // description
//       importance: Importance.max,
//       playSound: true,
//     );
//   }
// }

// class PushNotificationService {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   final chatController = Get.put(ChatController());
//   final socketController = Get.put(SocketController());
//   final groupListController = Get.put(GroupListController());

//   Future<void> setupInteractedMessage() async {
//     await enableIOSNotifications();
//     await registerNotificationListeners();

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       for (var test in groupListController.groupList) {
//         if (test.sId.toString() == message.data['grp']) {
//           test.unreadCount = 0;
//           groupListController.groupList.refresh();
//         }
//       }
//       chatController.timeStamps.value = DateTime.now().millisecondsSinceEpoch;
//       socketController.groupId.value = message.data['grp'];
//       log("App was opened by a notification: ${message.data}");
//       doNavigator(route: ChatScreen(groupId: message.data['grp']), context: Get.context!);
//     });

//     FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
//       if (message != null) {
//         log("App launched from terminated state by notification: ${message.data}");
//         // Handle navigation or other logic
//       }
//     });

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       log("Foreground notification: ${message.notification?.title}");
//       AndroidNotificationChannel channel = androidNotificationChannel();
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);

//       flutterLocalNotificationsPlugin.show(
//         message.notification.hashCode,
//         message.notification?.title,
//         message.notification?.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             channelDescription: channel.description,
//             priority: Priority.high,
//             importance: Importance.high,
//             playSound: true,
//           ),
//           iOS: DarwinNotificationDetails(
//             presentAlert: true,
//             presentBadge: true,
//             presentSound: true,
//           ),
//         ),
//       );
//     });
//   }

//   Future<void> enableIOSNotifications() async {
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }

//   Future<void> registerNotificationListeners() async {
//     AndroidNotificationChannel channel = androidNotificationChannel();

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iOSSettings = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//     final initSettings = InitializationSettings(android: androidSettings, iOS: iOSSettings);

//     await flutterLocalNotificationsPlugin.initialize(initSettings,
//         onDidReceiveNotificationResponse: (NotificationResponse response) {
//       log("Notification response received: ${response.payload}");
//     });
//   }

//   AndroidNotificationChannel androidNotificationChannel() {
//     return const AndroidNotificationChannel(
//       'high_importance_channel',
//       'High Importance Notifications',
//       description: 'This channel is used for important notifications.',
//       importance: Importance.max,
//       playSound: true,
//     );
//   }
// }

class PushNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final chatController = Get.put(ChatController());
  final socketController = Get.put(SocketController());
  final groupListController = Get.put(GroupListController());

  Future<void> setupInteractedMessage() async {
    await enableIOSNotifications();
    await registerNotificationListeners();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Reset notification count on app open from notification
      // resetNotificationCount();
      int ind = -1;
      for (int i = 0; i < groupListController.groupList.length; i++) {
        if (groupListController.groupList[i].sId.toString() == message.data['grp']) {
          ind = i;
          groupListController.groupList[i].unreadCount = 0;
          groupListController.groupList.refresh();
        }
      }
      chatController.timeStamps.value = DateTime.now().millisecondsSinceEpoch;
      socketController.groupId.value = message.data['grp'];
      log("App was opened by a notification: ${message.data}");
      doNavigator(
        route: ChatScreen(
          groupId: message.data['grp'],
          index: ind,
        ),
        context: Get.context!,
      );
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        log("App launched from terminated state by notification: ${message.data}");
        // Reset notification count when app is launched from a terminated state
        // resetNotificationCount();
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log("Foreground notification: ${message.notification}");
      log("jdfjdfhj ${message.data}");
      // Increment notification count for badge
      // incrementNotificationCount();

      AndroidNotificationChannel channel = androidNotificationChannel();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      flutterLocalNotificationsPlugin.show(
        message.notification.hashCode,
        message.notification?.title,
        // message.notification?.body,
        bodyMessage(message.data['msgType'].toString(), message.notification?.body ?? ""),
        // ,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            priority: Priority.high,
            importance: Importance.high,
            playSound: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: false,
            presentSound: true,
          ),
        ),
      );
    });
  }

  Future<void> enableIOSNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: false,
      sound: true,
    );
  }

  Future<void> registerNotificationListeners() async {
    AndroidNotificationChannel channel = androidNotificationChannel();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
      requestSoundPermission: true,
    );
    final initSettings = InitializationSettings(android: androidSettings, iOS: iOSSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      log("Notification response received: ${response.payload}");
    });
  }

  AndroidNotificationChannel androidNotificationChannel() {
    return const AndroidNotificationChannel(
        'high_importance_channel', 'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
        playSound: true,
        showBadge: false);
  }

  String bodyMessage(String mesageType, String body) {
    switch (mesageType) {
      case "text":
        return body;
      case "image":
        return "Image";
      case "audio":
        return "Audio";
      case "video":
        return "Video";
      case "doc":
        return "Docs";
      default:
        return body;
    }
  }
}
