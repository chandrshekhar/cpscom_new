import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Api/urls.dart';
import 'package:cpscom_admin/Commons/app_strings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  RxBool isReply = false.obs;
  RxBool isMemberSuggestion = false.obs;
  var chatMap = <AsyncSnapshot>{}.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Rx<TextEditingController> msgController = TextEditingController().obs;
  RxString replyWhom = "".obs;
  RxString replyText = ''.obs;

  setLastChatMap(var data) {
    chatMap.addAll(data);
  }

  isRelayFunction(bool isRep) {
    isReply(isRep);
  }

  Stream<QuerySnapshot> getLastMessage(
    String groupId,
  ) async* {
    try {
      yield* FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('chats')
          .orderBy('time', descending: true)
          .snapshots();
    } catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
    }
  }

  void mentionMember(String value) {
    // print("pandey -->$value");
    if (value != '') {
      if (value[value.length - 1] == '@') {
        isMemberSuggestion(true);
      } else if (value.isNotEmpty && value[value.length - 1] != '@') {
        isMemberSuggestion(false);
      } else if (value.isNotEmpty || value[value.length] != '@') {
        isMemberSuggestion(false);
      } else {
        isMemberSuggestion(false);
      }
    } else {
      isMemberSuggestion(false);
    }
  }

  // pick document
  Future<void> pickFile(String groupId, List<dynamic> chatMember) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      //PlatformFile file = result.files.first;

      List<File> files =
          result.paths.map((path) => File(path.toString())).toList();
      for (var i in files) {
        String extension = i.path.split('.').last;
        uploadImage(
            file: File(i.path),
            extension: extension,
            groupId: groupId,
            chatMemberList: chatMember);
      }
    } else {
      debugPrint("  User canceled the picker");
    }
  }

  // pick image from camera
  Future pickImageFromCamera(String groupId, List<dynamic> chatMember) async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          maxHeight: 512,
          maxWidth: 512,
          imageQuality: 75);
      if (image == null) return;
      final extension = image.path.split(".").last;
      await uploadImage(
          file: File(image.path),
          extension: extension,
          groupId: groupId,
          chatMemberList: chatMember);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        log('Failed to pick image: $e');
      }
    }
  }

  // record video
  Future pickVideoFromCamera(String groupId, List<dynamic> chatMember) async {
    try {
      final video = await ImagePicker().pickVideo(
          source: ImageSource.camera, maxDuration: const Duration(seconds: 30));
      if (video == null) return;
      final extension = video.path.split(".").last;
      await uploadImage(
          file: File(video.path),
          extension: extension,
          groupId: groupId,
          chatMemberList: chatMember);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        log('Failed to pick image: $e');
      }
    }
  }

  // pick image from gallary
  List<XFile> imageFileList = <XFile>[].obs;
  Future pickImageFromGallery(String groupId, List<dynamic> chatMember) async {
    try {
      final images = await ImagePicker().pickMultipleMedia();
      // final images = await ImagePicker()
      //     .pickMultiImage(maxHeight: 512, maxWidth: 512, imageQuality: 75);
      if (images != null) {
        imageFileList.addAll(images);

        final extension = imageFileList.first.path.split(".").last;
        for (var i in imageFileList) {
          await uploadImage(
              file: File(i.path),
              extension: extension,
              groupId: groupId,
              chatMemberList: chatMember);
        }
      } else {
        // User canceled the picker
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        log('Failed to pick image: $e');
      }
    }
  }

  // upload document function
  dynamic extType;
  Future uploadImage(
      {required File file,
      extension,
      required String groupId,
      required List<dynamic> chatMemberList,
      String profilePicture = ''}) async {
    String fileName = const Uuid().v1();
    // final ext = file.path.split('.').last;
    if (extension == 'pdf') {
      extType = "pdf";
    } else if (extension == 'jpg' ||
        extension == 'JPG' ||
        extension == 'jpeg' ||
        extension == 'png') {
      extType = "img";
    } else if (extension == 'doc' || extension == 'docx') {
      extType = "doc";
    } else if (extension == 'gif') {
      extType = "gif";
    }
    // } else if (extension == 'mp4' ||
    //     extension == 'avi' ||
    //     extension == 'MST' ||
    //     extension == 'M2TS' ||
    //     extension == 'mov' ||
    //     extension == 'TS' ||
    //     extension == 'QT' ||
    //     extension == 'wmv' ||
    //     extension == 'nkv' ||
    //     extension == 'avi' ||
    //     extension == 'm4p' ||
    //     extension == 'm4v' ||
    //     extension == '3gp' ||
    //     extension == 'mxf' ||
    //     extension == 'svi' ||
    //     extension == 'amv')
    else {
      extType = "mp4";
    }
    int status = 1;
    try {
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('chats')
          .doc(fileName)
          .set({
        "sendBy": _auth.currentUser!.displayName,
        "sendById": _auth.currentUser!.uid,
        "message": "",
        'profile_picture': profilePicture,
        "type": extType,
        "isSeen": false,
        "time": DateTime.now().millisecondsSinceEpoch,
        "members": chatMemberList.toSet().toList(),
      });
      // Update last msg time with group time to show latest messaged group on top on the groups list
      await FirebaseProvider.firestore
          .collection('groups')
          .doc(groupId)
          .update({"time": DateTime.now().millisecondsSinceEpoch});

      var ref = FirebaseStorage.instance
          .ref()
          .child('cpscom_admin_images')
          .child("$fileName.$extension");
      var uploadTask = await ref.putFile(file).catchError((error) async {
        await _firestore
            .collection('groups')
            .doc(groupId)
            .collection('chats')
            .doc(fileName)
            .delete();
        status = 0;
      });
      if (status == 1) {
        String imageUrl = await uploadTask.ref.getDownloadURL();
        await _firestore
            .collection('groups')
            .doc(groupId)
            .collection('chats')
            .doc(fileName)
            .update({"message": imageUrl});
      }
    } catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
    }
  }

  // onsend message
  Future<void> onSendMessages(String groupId, String msg, String profilePicture,
      String senderName, List<dynamic> membersList) async {
    if (msg.trim().isNotEmpty) {
      msgController.value.clear();
      Map<String, dynamic> chatData = {};
      Map<String, dynamic> reply = {};
      try {
        if (isReply.value == true) {
          reply = {
            "replyWhom": replyWhom.value,
            'message': replyText.value,
            'type': 'reply',
          };

          chatData = {
            'sendBy': FirebaseProvider.auth.currentUser!.displayName,
            'sendById': FirebaseProvider.auth.currentUser!.uid,
            'profile_picture': profilePicture,
            'message': msg,
            'read': DateTime.now().millisecondsSinceEpoch,
            'type': 'text',
            'reply': reply,
            'time': DateTime.now().millisecondsSinceEpoch,
            "isSeen": false,
            "members": membersList.toSet().toList(),
          };
          isRelayFunction(false);
        } else {
          chatData = {
            'sendBy': FirebaseProvider.auth.currentUser!.displayName,
            'sendById': FirebaseProvider.auth.currentUser!.uid,
            'profile_picture': profilePicture,
            'message': msg,
            'read': DateTime.now().millisecondsSinceEpoch,
            'type': 'text',
            'time': DateTime.now().millisecondsSinceEpoch,
            "isSeen": false,
            "members": membersList.toSet().toList(),
          };
          isRelayFunction(false);
        }
        await FirebaseProvider.firestore
            .collection('groups')
            .doc(groupId)
            .collection('chats')
            .add(chatData)
            .then((value) {
          sendPushNotification(senderName, msg, membersList);
        });

        // Update last msg time with group time to show latest messaged group on top on the groups list
        await FirebaseProvider.firestore
            .collection('groups')
            .doc(groupId)
            .update({"time": DateTime.now().millisecondsSinceEpoch});
      } catch (e) {
        isRelayFunction(false);
        if (kDebugMode) {
          log(e.toString());
        }
      }
    }
  }

  Future<void> sendPushNotification(
      String senderName, String msg, List<dynamic> membersList) async {
    for (var i = 0; i < membersList.length; i++) {
      print(membersList.length);
      // notification will sent to all the users of the group except current user.
      String token = "";

      if (membersList[i]['uid'] != _auth.currentUser!.uid) {
        // membersList.removeAt(i);
        DocumentSnapshot<Map<String, dynamic>> ref = await FirebaseFirestore
            .instance
            .collection("users")
            .doc(membersList[i]['uid'])
            .get();
        token = ref['pushToken'];
        log("test token $token");
      }

      try {
        final body = {
          "priority": "high",
          "to": token,
          "data": <String, dynamic>{"title": senderName, "body": msg},
          "notification": <String, dynamic>{"title": senderName, "body": msg}
        };
        var response = await post(Uri.parse(Urls.sendPushNotificationUrl),
            headers: <String, String>{
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: AppStrings.serverKey
            },
            body: jsonEncode(body));

        if (kDebugMode) {
          log('status code send notification - ${response.statusCode}');
          log('body send notification -  ${response.body}');
        }
      } catch (e) {
        if (kDebugMode) {
          log(e.toString());
        }
      }
    }
  }
}
