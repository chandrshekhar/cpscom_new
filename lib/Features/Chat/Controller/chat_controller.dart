import 'dart:developer';
import 'dart:io';

import 'package:cpscom_admin/Features/Chat/Model/chat_list_model.dart';
import 'package:cpscom_admin/Features/Chat/Repo/chat_repo.dart';
import 'package:cpscom_admin/Features/Home/Controller/socket_controller.dart';
import 'package:cpscom_admin/Features/Home/Model/group_list_model.dart';
import 'package:cpscom_admin/Features/Home/Repository/group_repo.dart';
import 'package:cpscom_admin/Utils/storage_service.dart';
import 'package:cpscom_admin/Widgets/toast_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../Home/Controller/group_list_controller.dart';

class ChatController extends GetxController {
  final GroupRepo _groupRepo = GroupRepo();
  final _chatRepo = ChatRepo();
  RxBool isReply = false.obs;
  RxBool isMemberSuggestion = false.obs;
  final msgController = TextEditingController().obs;
  final RxMap<String, dynamic> replyOf = <String, dynamic>{
    "msgId": '',
    "sender": '',
    "msg": '',
    "msgType": '',
  }.obs;
  var chatMap = <AsyncSnapshot>{}.obs;
  var groupModel = GroupModel().obs;
  var descriptionController = TextEditingController().obs;
  var titleController = TextEditingController().obs;
  RxList<ChatModel> chatList = <ChatModel>[].obs;
  RxString groupId = "".obs;

  RxBool isChatLoading = false.obs;

  void addNameInMsgText({String? mentionname}) {
    msgController.value.text = msgController.value.text + mentionname!;
    msgController.value.selection = TextSelection.fromPosition(
        TextPosition(offset: msgController.value.text.length));
  }

  getAllChatByGroupId({required String groupId}) async {
    try {
      isChatLoading(true);
      Map<String, dynamic> reqModel = {
        "id": groupId,
        "timestamp": DateTime.now().toString(),
        "offset": 0,
        "limit": 1000
      };
      var res = await _chatRepo.getChatListApi(reqModel: reqModel);
      if (res.success == true) {
        chatList.clear();
        chatList.addAll(res.chat!);
        isChatLoading(false);
      } else {
        chatList.value = [];
      }
    } catch (e) {
      chatList.value = [];
      isChatLoading(false);
    }
  }

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
    } on Exception {}
  }

  isRelayFunction(
      {required bool isRep,
      String? msg,
      String? senderName,
      String? msgId,
      String? msgType}) {
    replyOf['msgId'] = msgId;
    replyOf['sender'] = senderName;
    replyOf['msg'] = msg;
    replyOf['msgType'] = msgType;
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

  RxBool isSendSmsLoading = false.obs;
  RxString msgText = "demo".obs;
  sendMsg(
      {required String groupId,
      required String msgType,
      required String msg,
      File? file,
      Map<String, dynamic>? replyOf,
      required List<String> reciverId}) async {
    try {
      isSendSmsLoading(true);
      final socketController = Get.put(SocketController());
      var res = await _chatRepo.sendMessage(
          replyOf: replyOf,
          groupId: groupId,
          message: msg,
          file: file,
          messageType: msgType,
          senderName: "Azhar");
      Map<String, dynamic> reqModeSocket = {
        "replyOf": replyOf,
        "_id": res['data']['data']['id'],
        "receiverId": reciverId,
        "senderId": LocalStorage().getUserId(),
        "time": DateFormat('hh:mm a').format(DateTime.now()),
      };
      log("req---> $reqModeSocket");
      socketController.socket!.emit("message", reqModeSocket);
      msgText.value = "";
      isSendSmsLoading(false);
    } catch (e) {}
  }

  Future<void> pickImageForSendSms(
      {required ImageSource imageSource,
      required String groupId,
      required List<String> receiverId,
      required BuildContext context}) async {
    try {
      final selected =
          await ImagePicker().pickImage(imageQuality: 50, source: imageSource);
      if (selected != null) {
        File groupImages = File(selected.path);
        // ignore: use_build_context_synchronously
        await sendMsg(
            msg: "text",
            groupId: groupId,
            file: groupImages,
            msgType: "image",
            reciverId: receiverId);
      } else {}
    } on Exception catch (e) {
      log("image uplaod faild ${e.toString()}");
    }
  }

  // record video
  Future pickVideoFromCameraAndSendMsg(
      {required String groupId, required List<String> receiverId}) async {
    try {
      final video = await ImagePicker().pickVideo(
          source: ImageSource.camera, maxDuration: const Duration(seconds: 30));
      if (video == null) return;
      // final extension = video.path.split(".").last;
      await sendMsg(
          msg: "text",
          groupId: groupId,
          file: File(video.path),
          msgType: "video",
          reciverId: receiverId);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        log('Failed to pick image: $e');
      }
    }
  }

  Future<void> pickFile(
      {required String groupId,
      required List<String> receiverId,
      required BuildContext context}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'mp4'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      //var extension = file.extension;
      // debugPrint("file extension--> $extension");
      File files = File(file.path.toString());
      // List<File> files =
      //     result.paths.map((path) => File(path.toString())).toList();
      String extension = files.path.split(".").last;
      await sendMsg(
          msg: "text",
          groupId: groupId,
          file: files,
          msgType:
              extension == "pdf" || extension == "doc" || extension == "docx"
                  ? "doc"
                  : "video",
          reciverId: receiverId);
      // for (var i in files) {
      //   String extension = i.path.split(".").last;

      // }
    } else {
      // User canceled the picker
    }
  }
}
