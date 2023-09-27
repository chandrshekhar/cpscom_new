import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  RxBool isReply = false.obs;
  RxBool isMemberSuggestion = false.obs;
  var chatMap = <AsyncSnapshot>{}.obs;

  setLastChatMap(var data){
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
      if (value![value.length - 1] == '@') {
        isMemberSuggestion(true);
      } else if (value.isNotEmpty && value![value.length - 1] != '@') {
        isMemberSuggestion(false);
      } else if (value.isNotEmpty || value![value.length] != '@') {
        isMemberSuggestion(false);
      } else {
        isMemberSuggestion(false);
      }
    } else {
      isMemberSuggestion(false);
    }
  }
}
