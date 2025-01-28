import 'dart:developer';
import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:cpscom_admin/Features/Chat/Presentation/chat_screen.dart';
import 'package:cpscom_admin/Features/Home/Controller/group_list_controller.dart';
import 'package:cpscom_admin/Features/Home/Controller/socket_controller.dart';
import 'package:cpscom_admin/Utils/navigator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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
      int ind = -1;
      for (int i = 0; i < groupListController.groupList.length; i++) {
        if (groupListController.groupList[i].sId.toString() == message.data['grp']) {
          ind = i;
          groupListController.groupList[i].unreadCount = 0;
          groupListController.groupList.refresh();
        }
      }
      chatController.timeStamps.value = DateTime.now().millisecondsSinceEpoch;
      chatController.groupId.value = message.data['grp'];
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
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log("Foreground notification: ${message.notification}");
      log("Message data: ${message.data}");

      AndroidNotificationChannel channel = androidNotificationChannel();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
final String title = message.data['title'] ?? 'Default Title';
  final String body = message.data['body'] ?? 'Default Body';
      if (Platform.isAndroid) {
        flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          title,
          bodyMessage(message.data['msgType'].toString(), body),
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              priority: Priority.high,
              importance: Importance.high,
              playSound: true,
            ),
          ),
        );
      } else if (Platform.isIOS) {
        final attachment = await _downloadAndAttachImage(message.data['imageUrl']);
        flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification?.title,
          bodyMessage(message.data['msgType'].toString(), body),
          NotificationDetails(
            iOS: DarwinNotificationDetails(
              attachments: attachment != null ? [attachment] : null,
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
        );
      }
    });
  }

  Future<void> enableIOSNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
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
      requestBadgePermission: true,
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

  String bodyMessage(String messageType, String body) {
    switch (messageType) {
      case "text":
        return body;
      case "image":
        return "Image 🏞️ ";
      case "audio":
        return "Audio 🎵";
      case "video":
        return "Video 🎬";
      case "doc":
        return "Docs 📄";
      default:
        return body;
    }
  }

  Future<DarwinNotificationAttachment?> _downloadAndAttachImage(String? imageUrl) async {
    if (imageUrl == null || imageUrl.isEmpty) return null;

    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/image.jpg';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return DarwinNotificationAttachment(filePath);
      }
    } catch (e) {
      log("Error downloading image for notification: $e");
    }
    return null;
  }
}

