import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ChatController extends GetxController {
  RxBool isReply = false.obs;
  RxBool isMemberSuggestion = false.obs;
  var chatMap = <AsyncSnapshot>{}.obs;

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

  String getAsyncString(String videoUrl) {
    RxString thumbnail = "".obs;
    Future.delayed(const Duration(milliseconds: 300)).then((value) async {
      thumbnail.value = await generateThumbnail(videoUrl);
    });
    return thumbnail.value;
  }

  Future<String> generateThumbnail(String videoUrl) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight:
          64, 
      quality: 75,
    );
    print("path--${(await getTemporaryDirectory()).path}");
    return fileName!;
  }
}
