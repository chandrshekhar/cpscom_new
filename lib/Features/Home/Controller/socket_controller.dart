import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cpscom_admin/Api/urls.dart';
import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:cpscom_admin/Features/Home/Controller/group_list_controller.dart';
import 'package:flutter/material.dart';
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
  RxBool isConnected = true.obs; // Observable for connection state
  final connectivity = Connectivity(); // Connectivity instance
  RxString groupId = "".obs;

  socketConnection() {
    try {
      print("Socket initializing...");
      String userId = LocalStorage().getUserId().toString();
      socket = IO.io(
          ApiPath.socketUrl,
          //"https://crazy-sitting-duck.loca.lt",
          <String, dynamic>{
            "transports": ["websocket"],
            "autoConnect": false,
            "reconnection": true,
            "reconnectionAttempts": 10,
            "reconnectionDelay": 5000,
            "timeout": 20000
            //"query": {"id": "cK-Pqmh1ib9vJsHnAAD4"},
          });

      socket!.on('connect', (_) {
        print('Socket connected');
        String socketId = socket!.id ?? "";
        print('Socket ID: $socketId');
        socket?.emit("joinSelf", userId);
        isConnected.value = true; // Mark as connected
      });
      // socket?.connect();
      // Listen for disconnection
      socket!.on('disconnect', (reason) {
        print('Socket disconnected: $reason');
        isConnected.value = false; // Mark as disconnected
      });
      socket!.on('error', (data) {
        print('Socket error: $data');
        isConnected.value = false; // Mark as disconnected
      });

      // Listen for reconnection attempts
      socket!.on('reconnect_attempt', (attempt) {
        print('Socket reconnecting... Attempt: $attempt');
      });

      //Message received
      socket?.on('message', (data) {
        log("All smsshgfjhsgfjshfgjhg ${data['data']}");
        if (data['data']['messageType'] == "removed") {
          groupListController.getGroupList(isLoadingShow: false);
        }
        var ownId = LocalStorage().getUserId();
        List<String> reciverId = List<String>.from(
            data['data']['allRecipients']); // Creating a copy of the original list
        reciverId.removeWhere((id) => id == ownId); // Remove the user id from the new list
        socket?.emit("deliver", {
          "msgId": data['data']['_id'],
          "userId": LocalStorage().getUserId().toString(),
          "timestamp": DateTime.now().millisecondsSinceEpoch,
          "receiverId": reciverId
        });

        for (int i = 0; i < groupListController.groupList.length; i++) {
          if (data['data']['groupId'] == groupListController.groupList[i].sId) {
            groupListController.groupList[i].unreadCount =
                groupListController.groupList[i].unreadCount! + 1;
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

      //Deliver message listing
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
        }
      });

      //Seen message listing
      socket?.on("read", (data) {
        log("jhghhg  $data");
        if (data['msgId'] != null) {
          for (int i = 0; i < chatController.chatList.length; i++) {
            if (chatController.chatList[i].sId == data['msgId'].toString()) {
              chatController.chatList[i].readBy =
                  (data['readData'] as List).map((e) => ChatReadBy.fromJson(e)).toList();
              chatController.chatList.refresh();
            }
          }
        } else {
          log("elffese pront");

          for (int i = 0; i < chatController.chatList.length; i++) {
            if (chatController.chatList[i].readBy?.length !=
                chatController.groupModel.value.currentUsers?.length) {
              chatController.chatList[i].readBy!.add(ChatReadBy(
                  user: User(
                    sId: data['readData']['user'],
                  ),
                  timestamp: data['readData']['timestamp'].toString()));
            }

            chatController.chatList.refresh();
          }
        }
      });

      //New group craete
      socket?.on("newgroup", (data) {
        log("Create group socket data ${data.toString()}");
        groupListController.getGroupList(isLoadingShow: false);
      });

      //Update group changes
      socket?.on("updated", (data) {
        log("Update group socket data ${data.toString()}");
        groupListController.getGroupList(isLoadingShow: false);
      });

      socket?.on("delete-Group", (data) {
        log("Update group socket data ${data.toString()}");
        groupListController.getGroupList(isLoadingShow: false);
      });

      //Add or remove user from group
      socket?.on("addremoveuser2", (data) {
        log("Add remove user fromm group socket data ${data.toString()}");
        groupListController.getGroupList(isLoadingShow: false);
      });

      //Error handling
      socket?.onError((data) {
        print('Socket Error: $data');
      });
    } catch (e) {
      log("Socket connection error: $e");
    }
  }

  void reconnectSocket() {
    if (socket != null && !(socket?.connected ?? false)) {
      print('Attempting to reconnect socket...');
      socket?.connect();
    }
  }

  void monitorConnectivity(bool isFirstTime) {
    connectivity.onConnectivityChanged.listen((result) {
      if (!isFirstTime) {
        if (result.contains(ConnectivityResult.mobile) ||
            result.contains(ConnectivityResult.wifi) ||
            result.contains(ConnectivityResult.ethernet)) {
          Get.snackbar(
            "Online",
            "Your internet connected",
            backgroundColor: Colors.green,
          );
          reconnectSocket(); // Reconnect socket when internet is back
          groupListController.getGroupList(isLoadingShow: false);
          chatController.getAllChatByGroupId(groupId: groupId.value, isShowLoading: false);
        } else {
          print('No internet connection');
          Get.snackbar(
            "Offline",
            "Your internet disconnected",
            backgroundColor: Colors.red,
          );
        }
      } else {
        isFirstTime = false;
      }
    });
  }

  socketInitialization() {
    monitorConnectivity(true);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    socketInitialization();
  }

  @override
  void onClose() {
    socket?.disconnect();
    socket?.dispose();
    super.onClose();
  }
}
