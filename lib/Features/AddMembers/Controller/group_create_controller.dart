// ignore_for_file: use_build_context_synchronously

import 'package:cpscom_admin/Features/AddMembers/Model/members_model.dart';
import 'package:cpscom_admin/Features/AddMembers/Repo/member_repo.dart';
import 'package:cpscom_admin/Features/Home/Controller/group_list_controller.dart';
import 'package:cpscom_admin/Features/Home/Presentation/home_screen.dart';
import 'package:cpscom_admin/Utils/navigator.dart';
import 'package:cpscom_admin/Utils/storage_service.dart';
import 'package:cpscom_admin/Widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MemeberlistController extends GetxController {
  var grpNameController = TextEditingController().obs;
  var grpDescController = TextEditingController().obs;
  final memebrListRepo = MemberlistRepo();
  final groupListController = Get.put(GroupListController());
  //member list
  RxList<MemberListMdoel> memberList = <MemberListMdoel>[].obs;
  RxList<String> memberId = <String>[].obs;
  RxList<MemberListMdoel> memberSelectedList = <MemberListMdoel>[].obs;

  //loading memeber list bvool
  RxBool isMemberListLoading = false.obs;

  RxString images = "".obs;

  Future<void> pickImage({required ImageSource imageSource}) async {
    try {
      final image = await ImagePicker().pickImage(
        source: imageSource,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 75,
      );
      if (image == null) return;
      images.value = image.path.toString();
    } on PlatformException catch (e) {
      print("Error picking image: ${e.toString()}");
    }
  }

  //Method for selet the member for create a group
  checkBoxTrueFalse(dynamic v, String id, MemberListMdoel mmberListModel) {
    if (v != null && v) {
      memberId.add(id);
      memberSelectedList.add(mmberListModel);
    } else {
      memberId.remove(id);
      memberSelectedList.remove(mmberListModel);
    }
  }

//method for calling memeber  list
  getMemberList({bool isLoaderShowing = true}) async {
    try {
      isLoaderShowing ? isMemberListLoading(true) : null;
      var res = await memebrListRepo.getMemberList();
      if (res.success == true) {
        memberList.value = res.memberList!;
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

  RxBool isGroupCreateLoading = false.obs;
  //method for create group
  createGroup(BuildContext context) async {
    var ownUserId = LocalStorage().getUserId();
    memberId.add(ownUserId);
    try {
      Map<String, dynamic> reqModel = {
        "groupName": grpNameController.value.text,
        "users": memberId
      };
      isGroupCreateLoading(true);
      var res = await memebrListRepo.createGroup(reqModel: reqModel);
      if (res['success'] == true) {
        TostWidget().successToast(title: "Error", message: res['message']);
        await groupListController.getGroupList();
        isGroupCreateLoading(false);
        dataClearAfterAdd();
        doNavigateWithReplacement(route: const HomeScreen(), context: context);
      } else {
        TostWidget().errorToast(title: "Error", message: res['message']);
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
    images.value = "";
  }
}
