import 'dart:io';

import 'package:cpscom_admin/Features/Home/Model/group_list_model.dart';
import 'package:cpscom_admin/Features/Home/Repository/group_repo.dart';
import 'package:cpscom_admin/Widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../Home/Controller/group_list_controller.dart';

class ChatController extends GetxController {
  final GroupRepo _groupRepo = GroupRepo();
  RxBool isReply = false.obs;
  RxBool isMemberSuggestion = false.obs;
  var chatMap = <AsyncSnapshot>{}.obs;
  var groupModel = GroupModel().obs;
  var descriptionController = TextEditingController().obs;
  var titleController = TextEditingController().obs;

  Future<void> pickImage(
      {required ImageSource imageSource,
      required String groupId,
      required BuildContext context}) async {
    try {
      final selected =
          await ImagePicker().pickImage(imageQuality: 50, source: imageSource);
      if (selected != null) {
        File groupImages = File(selected.path);
        // ignore: use_build_context_synchronously
        updateGroup(
            groupId: groupId,
            groupName: titleController.value.text.toString(),
            groupImage: groupImages,
            context: context);
      } else {}
    } on Exception catch (e) {}
  }

  isRelayFunction(bool isRep) {
    isReply(isRep);
  }

  setControllerValue() {
    titleController.value.text = groupModel.value.groupName != null
        ? groupModel.value.groupName.toString()
        : "";
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

  RxBool isUpdateLoading = false.obs;
  updateGroup(
      {required String groupId,
      required String groupName,
      required File groupImage,
      required BuildContext context}) async {
    try {
      isUpdateLoading(true);
      var res = await _groupRepo.updateGroupDetails(
          groupId: groupId, groupName: groupName, groupImage: groupImage);
      if (res['success'] == true) {
        final groupListController = Get.put(GroupListController());
        await groupListController.getGroupList(isLoadingShow: false);
        await getGroupDetailsById(groupId: groupId);
        TostWidget().successToast(title: "Success", message: res['message']);
        isUpdateLoading(false);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        TostWidget()
            .errorToast(title: "Error", message: res['error']['message']);
        isUpdateLoading(false);
      }
    } catch (e) {
      isUpdateLoading(false);
    }
  }
}
