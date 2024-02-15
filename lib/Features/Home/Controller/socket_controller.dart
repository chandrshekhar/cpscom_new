import 'dart:developer';

import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:cpscom_admin/Features/Home/Controller/group_list_controller.dart';
import 'package:cpscom_admin/Features/Home/Model/group_list_model.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../Utils/storage_service.dart';
import '../../Chat/Model/chat_list_model.dart';

class SocketController extends GetxController {
  IO.Socket? socket;
  List<Map<String, dynamic>> mesages = [];
  final chatController = Get.put(ChatController());
  final groupListController = Get.put(GroupListController());

  socketConnection() {
    try {
      socket = IO.io("https://api.excellis.in", <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": true
      });
      socket!.connect();
      //log("Socket is connect status ${socket!.connected.toString()}");
      socket?.emit("joinSelf", LocalStorage().getUserId().toString());
      // socket?.emit("deliver", {
      //   "userId": LocalStorage().getUserId().toString(),
      //   "timestamp": DateTime.now().toString(),
      // });
      socket?.on('message', (data) {
        log("All smsshgfjhsgfjshfgjhg ${data['data']}");
        var ownId = LocalStorage().getUserId();
        List<String> reciverId = List<String>.from(data['data']
            ['allRecipients']); // Creating a copy of the original list
        reciverId.removeWhere(
            (id) => id == ownId); // Remove the user id from the new list
        socket?.emit("deliver", {
          "msgId": data['data']['_id'],
          "userId": LocalStorage().getUserId().toString(),
          "timestamp": DateTime.now().toString(),
          "receiverId": reciverId
        });
        for (int i = 0; i < groupListController.groupList.length; i++) {
          if (data['data']['groupId'] == groupListController.groupList[i].sId) {
            groupListController.groupList[i].lastMessage = LastMessage(
              sId: data['data']['_id'],
              groupId: data['data']['groupId'],
              senderId: data['data']['senderId'],
              senderName: data['data']['senderName'],
              message: data['data']['message'],
              messageType: data['data']['messageType'],
              forwarded: data['data']['forwarded'],
              timestamp: data['data']['timestamp'],
              createdAt: data['data']['createdAt'],
            );
          }
        }
        groupListController.groupList.sort((a, b) =>
            DateTime.parse(b.lastMessage!.timestamp.toString()).compareTo(
                DateTime.parse(a.lastMessage!.timestamp.toString())));
        groupListController.groupList.refresh();
        if (chatController.groupId.value == data['data']['groupId']) {
          chatController.chatList.add(ChatModel.fromJson(data['data']));
          chatController.chatList.refresh();
          socket?.emit("read", {
            "msgId": data['data']['_id'],
            "userId": LocalStorage().getUserId().toString(),
            "timestamp": DateTime.now().toString(),
            "receiverId": reciverId
          });
        }
      });
    } catch (e) {
      print("pandey: $e");
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    socketConnection();
  }
}
