// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cpscom_admin/Features/AddMembers/Model/members_model.dart';
import 'package:cpscom_admin/Features/AddMembers/Repo/member_repo.dart';
import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:cpscom_admin/Features/Home/Controller/group_list_controller.dart';
import 'package:cpscom_admin/Features/Home/Controller/socket_controller.dart';
import 'package:cpscom_admin/Utils/storage_service.dart';
import 'package:cpscom_admin/Widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Utils/navigator.dart';
import '../../Home/Presentation/home_screen.dart';

class MemeberlistController extends GetxController {
  var grpNameController = TextEditingController().obs;
  var grpDescController = TextEditingController().obs;
  final memebrListRepo = MemberlistRepo();
  final groupListController = Get.put(GroupListController());
  RxBool isUserChecked = true.obs;
  //member list
  RxList<MemberListMdoel> memberList = <MemberListMdoel>[].obs;
  RxList<String> memberId = <String>[].obs;
  RxList<MemberListMdoel> memberSelectedList = <MemberListMdoel>[].obs;

  //loading memeber list bvool
  RxBool isMemberListLoading = false.obs;
  RxInt limit = 20.obs;
  RxString searchText = "".obs;
  RxString images = "".obs;
  Rx<File?> imageFile = Rx<File?>(null);

  Future<void> pickImage({required ImageSource imageSource}) async {
    try {
      final image = await ImagePicker().pickImage(
        source: imageSource,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 75,
      );
      if (image == null) return;
      var fileImage = File(image.path);
      imageFile.value = fileImage;
      images.value = fileImage.path;
    } on PlatformException catch (e) {
      print("Error picking image: ${e.toString()}");
    }
  }

  //Method for selet the member for create a group

  RxList<String> updateMemberId = <String>[].obs;
  checkBoxTrueFalse(
      dynamic v, String id, MemberListMdoel mmberListModel, String groupId) {
    if (v != null && v) {
      memberId.add(id);
      memberSelectedList.add(mmberListModel);
      groupId.isNotEmpty ? updateMemberId.add(id) : null;
    } else {
      memberId.remove(id);
      memberSelectedList.remove(mmberListModel);
      groupId.isNotEmpty ? updateMemberId.remove(id) : null;
    }
  }

//method for calling memeber  list
  getMemberList({bool isLoaderShowing = true, String? searchQuery}) async {
    try {
      isLoaderShowing ? isMemberListLoading(true) : null;
      var res = await memebrListRepo.getMemberList(
          searchQuery: searchText.value, limit: limit.value, offset: 0);
      if (res.data!.success == true) {
        memberList.value = res.data!.memberList!;
        isMemberListLoading(false);
      } else {
        memberList.value = [];
        isMemberListLoading(false);
      }
    } catch (e) {
      memberList.value = [];
      isMemberListLoading(false);
    }
  }

  RxBool isDeleteWaiting = false.obs;

  Future<void> deleteUserFromGroup(
      {required String groupId, required String userId}) async {
    try {
      Map<String, dynamic> reqModel = {"groupId": groupId, "userId": userId};
      isDeleteWaiting(true);
      var res = await memebrListRepo.deleteMemberFromGroup(reqModel: reqModel);
      if (res.data!['success'] == true) {
        TostWidget()
            .successToast(title: "Success", message: res.data!['message']);
        isDeleteWaiting(false);
      } else {
        isDeleteWaiting(false);
      }
    } catch (e) {
      isDeleteWaiting(false);
      log("Error while fetch the data ${e.toString()}");
    }
  }

  RxBool addingGroup = false.obs;
  Future<void> addGroupMember(
      {required String groupId,
      required List<String> userId,
      required BuildContext context}) async {
    final chatController = Get.put(ChatController());
    try {
      Map<String, dynamic> reqModel = {"groupId": groupId, "userId": userId};
      addingGroup(true);
      var res = await memebrListRepo.addMemberInGroup(reqModel: reqModel);
      if (res.data!['success'] == true) {
        TostWidget()
            .successToast(title: "Success", message: res.data!['message']);
        await chatController.getGroupDetailsById(groupId: groupId);
        Navigator.pop(context);
        addingGroup(false);
        updateMemberId.clear();
      } else {
        addingGroup(false);
        updateMemberId.clear();
      }
    } catch (e) {
      addingGroup(false);
      updateMemberId.clear();
      log("Error while fetch the data ${e.toString()}");
    }
  }

  RxBool isGroupCreateLoading = false.obs;
  //method for create group
  createGroup(BuildContext context) async {
    final socketController = Get.put(SocketController());
    var userId = LocalStorage().getUserId();
    RxList<String> userIds = memberId;
    userIds.add(userId);
    try {
      isGroupCreateLoading(true);
      var res = await memebrListRepo.createNewGroup(
          groupName: grpNameController.value.text,
          memberId: memberId,
          groupDescription: grpDescController.value.text,
          file: images.value.isNotEmpty ? File(images.value) : null);

      if (res.data!['success'] == true) {
        TostWidget()
            .successToast(title: "Success", message: res.data!['message']);
        Map<String, dynamic> reqModeSocket = {
          "currentUsers": res.data!['data']['currentUsers'],
          "_id": res.data!['data']['_id']
        };

        socketController.socket!.emit("creategroup", reqModeSocket);
        //await groupListController.getGroupList();
        isGroupCreateLoading(false);
        dataClearAfterAdd();
        doNavigateWithReplacement(route: const HomeScreen(), context: context);
      } else {
        TostWidget().errorToast(title: "Error", message: res.data!['message']);
        isGroupCreateLoading(false);
      }
    } catch (e) {
      TostWidget().errorToast(title: "Error", message: e.toString());
      isGroupCreateLoading(false);
    }
  }

  //clear all field after creating group
  dataClearAfterAdd() {
    grpNameController.value.clear();
    grpDescController.value.clear();
    memberId.clear();
    memberSelectedList.clear();
    imageFile.value = null;
    images.value = "";
  }
}
