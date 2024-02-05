import 'package:cpscom_admin/Features/Home/Model/group_list_model.dart';
import 'package:cpscom_admin/Features/Home/Repository/group_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final GroupRepo _groupRepo = GroupRepo();
  RxBool isReply = false.obs;
  RxBool isMemberSuggestion = false.obs;
  var chatMap = <AsyncSnapshot>{}.obs;
  var groupModel = GroupModel().obs;

  isRelayFunction(bool isRep) {
    isReply(isRep);
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

  // String getAsyncString(String videoUrl) {
  //   RxString thumbnail = "".obs;
  //   Future.delayed(const Duration(milliseconds: 300)).then((value) async {
  //     thumbnail.value = await generateThumbnail(videoUrl);
  //   });
  //   return thumbnail.value;
  // }

  // Future<String> generateThumbnail(String videoUrl) async {
  //   final fileName = await VideoThumbnail.thumbnailFile(
  //     video: videoUrl,
  //     thumbnailPath: (await getTemporaryDirectory()).path,
  //     imageFormat: ImageFormat.WEBP,
  //     maxHeight:
  //         64,
  //     quality: 75,
  //   );
  //   print("path--${(await getTemporaryDirectory()).path}");
  //   return fileName!;
  // }

  RxBool isDetailsLaoding = false.obs;
  getGroupDetailsById({required String groupId}) async {
    try {
      isDetailsLaoding(true);
      var res = await _groupRepo.getGroupDetailsById(groupId: groupId);
      groupModel.value = res;
      isDetailsLaoding(false);
    } catch (e) {
      groupModel.value = GroupModel();
      isDetailsLaoding(false);
    }
  }
}
