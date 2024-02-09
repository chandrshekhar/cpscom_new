import 'dart:developer';

import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../Utils/storage_service.dart';
import '../../Chat/Model/chat_list_model.dart';

class SocketController extends GetxController {
  IO.Socket? socket;
  List<Map<String, dynamic>> mesages = [];
  final chatController = Get.put(ChatController());

  socketConnection() {
    try {
      socket = IO.io("https://api.excellis.in", <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": true
      });
      socket!.connect();
      //log("Socket is connect status ${socket!.connected.toString()}");
      socket?.emit("joinSelf", LocalStorage().getUserId().toString());
      socket?.emit("deliver", {
        "userId": LocalStorage().getUserId().toString,
        "timestamp": DateTime.now()
      });
      socket?.on('message', (data) {
        log("All smsshgfjhsgfjshfgjhg ${data.toString()}");
        if (chatController.groupId.value == data['data']['groupId']) {
          chatController.chatList.add(ChatModel.fromJson(data['data']));
        }
      });
    } catch (e) {
      print("pandey: $e");
    }
  }
}
