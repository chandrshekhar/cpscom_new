import 'dart:developer';

import 'package:cpscom_admin/Api/urls.dart';
import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:cpscom_admin/Features/Home/Controller/group_list_controller.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../Utils/storage_service.dart';
import '../../Chat/Model/chat_list_model.dart';
import '../Model/group_list_model.dart';

class SocketController extends GetxController {
  IO.Socket? socket;
  List<Map<String, dynamic>> mesages = [];
  final chatController = Get.put(ChatController());
  final groupListController = Get.put(GroupListController());

  socketConnection() {
    try {
      String userId = LocalStorage().getUserId().toString();
      socket = IO.io(
          ApiPath.socketUrl,
          //"https://crazy-sitting-duck.loca.lt",
          <String, dynamic>{
            "transports": ["websocket"],
            "autoConnect": true,
            //"query": {"id": "cK-Pqmh1ib9vJsHnAAD4"},
          });
      socket!.on('connect', (_) {
        print('Connected');
        // Access socket ID
        String socketId = socket!.id ?? "";
        print('Socket ID: $socketId');
      });
      socket?.connect();
      socket?.emit("joinSelf", userId);
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
          "timestamp": DateTime.now().millisecondsSinceEpoch,
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
              // forwarded: data['data']['forwarded'],
              timestamp: data['data']['timestamp'],
              createdAt: data['data']['createdAt'],
            );
          }
        }
        groupListController.groupList.refresh();

        groupListController.groupList.sort((a, b) {
          // Extracting the timestamps
          final aTimestamp = a.lastMessage?.timestamp;
          final bTimestamp = b.lastMessage?.timestamp;

          // Check for nulls and compare timestamps
          if (bTimestamp != null && aTimestamp != null) {
            // Parsing timestamps and comparing
            return DateTime.parse(bTimestamp.toString()).compareTo(
              DateTime.parse(aTimestamp.toString()),
            );
          } else if (bTimestamp != null) {
            // If a's timestamp is null, consider b greater
            return 1;
          } else if (aTimestamp != null) {
            // If b's timestamp is null, consider a greater
            return -1;
          } else {
            // If both timestamps are null, they are considered equal
            return 0;
          }
        });
        groupListController.groupList.refresh();
        if (chatController.groupId.value == data['data']['groupId']) {
          chatController.chatList.add(ChatModel.fromJson(data['data']));
          for (var element in chatController.chatList) {
            log("Main chat data ${element.readBy!.length}");
          }
          chatController.chatList.refresh();
          socket?.emit("read", {
            "msgId": data['data']['_id'],
            "userId": LocalStorage().getUserId().toString(),
            "timestamp": DateTime.now().millisecondsSinceEpoch,
            "receiverId": reciverId
          });
        }
      });
      socket?.on("deliver", (data) {
        log("yteyrubfnmdfb ${data['deliveredTo']}");
        if (data['deliverData'] == null) {
          log("if pront");
          for (int i = 0; i < chatController.chatList.length; i++) {
            if (chatController.chatList[i].sId == data['msgId'].toString()) {
              for (var element in (data['deliveredTo'] as List)) {
                if (chatController.chatList[i].deliveredTo!.length !=
                    chatController.chatList[i].allRecipients!.length) {
                  if (chatController.chatList[i].deliveredTo!
                      .every((e) => e.user != element['user']['_id'])) {
                    chatController.chatList[i].deliveredTo!
                        .add(ChatDeliveredTo(user: element['user']['_id']));
                    chatController.chatList.refresh();
                  }
                }
              }
              chatController.chatList.refresh();
            }
          }
        } else {
          log("elese pront");
          for (int i = 0; i < chatController.chatList.length; i++) {
            if (chatController.chatList[i].deliveredTo?.length !=
                chatController.chatList[i].allRecipients?.length) {
              chatController.chatList[i].deliveredTo!.add(ChatDeliveredTo(
                  user: data['deliverData']['user'],
                  timestamp: data['deliverData']['timestamp'].toString()));
            }

            chatController.chatList.refresh();
          }

          // for (int i = 0; i < chatController.chatList.length; i++) {
          //   log("chat list loop");
          //   //  List deliverToIds = [];
          //   for (var j = 0;
          //       j < chatController.chatList[i].deliveredTo!.length;
          //       j++) {
          //     // deliverToIds.add(chatController.chatList[i].deliveredTo![j].user);
          //     if (chatController.chatList[i].deliveredTo![j].user.toString()
          //        !=data['deliverData']['user'].toString()) {
          //       chatController.chatList[i].deliveredTo!.add(ChatDeliveredTo(
          //           user: data['deliverData']['user'],
          //           timestamp: data['deliverData']['timestamp'].toString()));
          //       chatController.chatList.refresh();
          //     }
          //   }
          // }
        }
      });
      socket?.on("newgroup", (data) {
        log("Create group socket data ${data.toString()}");
        groupListController.getGroupList(isLoadingShow: false);
      });
      socket?.on("updated", (data) {
        log("Update group socket data ${data.toString()}");
        groupListController.getGroupList(isLoadingShow: false);
      });
    } catch (e) {
      log("pandey: $e");
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    socketConnection();
  }
}
