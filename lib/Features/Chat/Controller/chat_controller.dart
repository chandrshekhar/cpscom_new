import 'dart:developer';
import 'dart:io';

import 'package:cpscom_admin/Features/Chat/Model/chat_list_model.dart';
import 'package:cpscom_admin/Features/Chat/Repo/chat_repo.dart';
import 'package:cpscom_admin/Features/Chat/Widget/docs_video.dart';
import 'package:cpscom_admin/Features/Home/Controller/socket_controller.dart';
import 'package:cpscom_admin/Features/Home/Model/group_list_model.dart';
import 'package:cpscom_admin/Features/Home/Repository/group_repo.dart';
import 'package:cpscom_admin/Features/Login/Controller/login_controller.dart';
import 'package:cpscom_admin/Utils/open_any_file.dart';
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
import '../Widget/confirmation_bottom_sheet_video.dart';
import '../Widget/picture_shoiwing_bottomsheet.dart';

class ChatController extends GetxController {
  final GroupRepo _groupRepo = GroupRepo();
  final _chatRepo = ChatRepo();
  RxBool isReply = false.obs;
  RxInt selectedIndex = (-1).obs;
  RxBool isMemberSuggestion = false.obs;
  final msgController = TextEditingController().obs;
  RxInt timeStamps = (-1).obs;
  RxBool isSendWidgetShow = true.obs;

  void isShowing(
    bool isShowing,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isShowing == true) {
        isSendWidgetShow.value = false;
      } else {
        isSendWidgetShow.value = true;
      }
    });
  }

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
    msgController.value.selection =
        TextSelection.fromPosition(TextPosition(offset: msgController.value.text.length));
  }

  Future<void> getAllChatByGroupId({required String groupId, bool isShowLoading = true}) async {
    try {
      isShowLoading ? isChatLoading(true) : null;
      Map<String, dynamic> reqModel = {
        "id": groupId,
        "timestamp": timeStamps.value,
        "offset": 0,
        "limit": 1000
      };
      var res = await _chatRepo.getChatListApi(reqModel: reqModel);
      if (res.data!.success == true) {
        chatList.addAll(res.data!.chat!);
        chatList.refresh();
        isChatLoading(false);
      } else {
        chatList.value = [];
      }
    } catch (e) {
      print("fhgdsfhgdhsf ${e.toString()}");
      chatList.value = [];
      isChatLoading(false);
    }
  }

  Future<void> pickImage(
      {required ImageSource imageSource,
      required String groupId,
      required BuildContext context}) async {
    try {
      final selected = await ImagePicker().pickImage(imageQuality: 50, source: imageSource);
      if (selected != null) {
        File groupImages = File(selected.path);
        // ignore: use_build_context_synchronously
        updateGroup(
            groupId: groupId,
            groupDes: descriptionController.value.text.toString(),
            groupName: titleController.value.text.toString(),
            groupImage: groupImages,
            context: context);
      } else {}
    } on Exception {}
  }

  isRelayFunction(
      {required bool isRep, String? msg, String? senderName, String? msgId, String? msgType}) {
    replyOf['msgId'] = msgId;
    replyOf['sender'] = senderName;
    replyOf['msg'] = msg;
    replyOf['msgType'] = msgType;
    isReply(isRep);
  }

  setControllerValue() {
    titleController.value.text =
        groupModel.value.groupName != null ? groupModel.value.groupName.toString() : "";
    descriptionController.value.text = groupModel.value.groupDescription ?? "";
  }

  void mentionMember(String value) {
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
  getGroupDetailsById({required String groupId, int? timeStamp, bool isShowLoading = true}) async {
    try {
      isShowLoading ? isDetailsLaoding(true) : null;
      var res = await _groupRepo.getGroupDetailsById(
        groupId: groupId,
      );
      groupModel.value = res.data!;
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
      File? groupImage,
      required String groupDes,
      required BuildContext context}) async {
    try {
      final socketController = Get.put(SocketController());
      isUpdateLoading(true);
      var res = await _groupRepo.updateGroupDetails(
          groupDes: groupDes, groupId: groupId, groupName: groupName, groupImage: groupImage);
      if (res.data!['success'] == true) {
        final groupListController = Get.put(GroupListController());
        Map<String, dynamic> reqModeSocket = res.data!['data'];
        log("req---> $reqModeSocket");
        socketController.socket!.emit("update-group", reqModeSocket);
        await groupListController.getGroupList(isLoadingShow: false);
        await getGroupDetailsById(groupId: groupId);
        TostWidget().successToast(title: "Success", message: res.data!['message']);
        isUpdateLoading(false);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        TostWidget().errorToast(title: "Error", message: res.data!['error']['message']);
        isUpdateLoading(false);
      }
    } catch (e) {
      isUpdateLoading(false);
    }
  }

  RxBool isSendSmsLoading = false.obs;
  RxString msgText = "demo".obs;
  sendMsg({
    required String groupId,
    required String msgType,
    required String msg,
    File? file,
    Map<String, dynamic>? replyOf,
    required List<String> reciverId,
  }) async {
    try {
      isSendSmsLoading(true);
      final socketController = Get.put(SocketController());
      final userController = Get.put(LoginController());
      var res = await _chatRepo.sendMessage(
          replyOf: replyOf,
          groupId: groupId,
          message: msg,
          file: file,
          messageType: msgType,
          senderName: userController.userModel.value.name ?? "");
      Map<String, dynamic> reqModeSocket = {
        "replyOf": replyOf,
        "_id": res.data!['data']['data']['id'],
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

  Future<void> pickImageFromCameraSendSms(
      {required ImageSource imageSource,
      required String groupId,
      required List<String> receiverId,
      required BuildContext context}) async {
    try {
      final selected = await ImagePicker().pickImage(imageQuality: 50, source: imageSource);
      if (selected != null) {
        File groupImages = File(selected.path);
        // ignore: use_build_context_synchronously
        await sendMsg(
            msg: "text",
            groupId: groupId,
            file: groupImages,
            msgType: "image",
            reciverId: receiverId);
        selectedImages.clear();
      } else {}
    } on Exception catch (e) {
      log("image uplaod faild ${e.toString()}");
    }
  }

  RxList<File> selectedImages = <File>[].obs;
  Future<void> pickMultipleImagesForSendSms({
    required String groupId,
    required List<String> receiverId,
    required BuildContext context,
  }) async {
    try {
      final selected = await ImagePicker().pickMultiImage(
        imageQuality: 50,
      );

      for (var image in selected) {
        File imageFile = File(image.path);
        selectedImages.add(imageFile);
      }
      log("ajdsajdfsja ${selectedImages.length}");
      if (selectedImages.value.isNotEmpty) {
        pictureBottomSheet(Get.context!, selectedImages, () async {
          for (var image in selectedImages) {
            await sendMsg(
              msg: "text",
              groupId: groupId,
              file: image,
              msgType: "image",
              reciverId: receiverId,
            );
          }
          selectedImages.clear();
        });
      }
    } on Exception catch (e) {
      log("Image upload failed: ${e.toString()}");
    }
  }

  Rx<File?> videoFile = Rx<File?>(null);
  // record video
  Future pickVideoFromCameraAndSendMsg(
      {required String groupId, required List<String> receiverId}) async {
    try {
      final video = await ImagePicker()
          .pickVideo(source: ImageSource.camera, maxDuration: const Duration(seconds: 30));
      if (video == null) return;
      File videoFileRaw = File(video.path);
      videoFile.value = videoFileRaw;
      if (videoFile.value != null) {
        videoBottomSheet(Get.context!, videoFile.value!, () async {
          // final extension = video.path.split(".").last;
          await sendMsg(
              msg: "text",
              groupId: groupId,
              file: videoFile.value,
              msgType: "video",
              reciverId: receiverId);
        });
      }
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
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'mp4'],
    );
    if (result != null) {
      videoFile.value = null;
      PlatformFile file = result.files.first;
      File files = File(file.path.toString());
      videoFile.value = files;
      String extension = files.path.split(".").last;

      if (extension == "pdf" || extension == "doc" || extension == "docx") {
        docsModelBottomSheet(Get.context!, files, () async {
          await sendMsg(
              msg: "text", groupId: groupId, file: files, msgType: "doc", reciverId: receiverId);
        });
      } else {
        videoBottomSheet(Get.context!, files, () async {
          await sendMsg(
              msg: "text", groupId: groupId, file: files, msgType: "video", reciverId: receiverId);
        });
      }
    } else {
      // User canceled the picker
    }
  }

  openFileAfterDownload(String message, String fileName, BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Downloading File...'),
              ],
            ),
          );
        },
      );

      await openPDF(fileUrl: message, fileName: fileName);

      Navigator.pop(context);
    } catch (e) {
      log("sahdghsdg ${e.toString()}");
      Navigator.pop(context);
    }
  }
}
