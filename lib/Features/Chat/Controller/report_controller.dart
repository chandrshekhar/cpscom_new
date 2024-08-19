import 'dart:developer';

import 'package:cpscom_admin/Features/Chat/Repo/chat_repo.dart';
import 'package:cpscom_admin/Utils/navigator.dart';
import 'package:cpscom_admin/Widgets/toast_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  final _groupRepo = ChatRepo();

  //controller for the report
  var groupReportController = TextEditingController().obs;
  var messageReportController = TextEditingController().obs;

  //loader
  RxBool isGroupReportLoading = false.obs;
  RxBool isMessageReportLoading = false.obs;

  groupReport({required String groupId, required BuildContext context}) async {
    Map<String, dynamic> reqModel = {
      "groupId": groupId,
      "description": groupReportController.value.text
    };
    try {
      isGroupReportLoading(true);
      var res = await _groupRepo.grouopReport(reqModel: reqModel);
      if (res.data!['success'] == true) {
        TostWidget().successToast(
            title: "Success", message: res.data!['message'].toString());
        isGroupReportLoading(false);
        groupReportController.value.clear();
        backFromPrevious(context: context);
      } else {
        TostWidget().errorToast(
            title: "Error", message: res.data!['message'].toString());
        groupReportController.value.clear();
        isGroupReportLoading(false);
        backFromPrevious(context: context);
      }
    } catch (e) {
      log("Error is ${e.toString()}");
      groupReportController.value.clear();
      isGroupReportLoading(false);
      backFromPrevious(context: context);
    }
  }

  messageReport(
      {required String messageId,
      required String groupId,
      required BuildContext context}) async {
    Map<String, dynamic> reqModel = {
      "msgId": messageId,
      "groupId": groupId,
      "description": messageReportController.value.text
    };
    try {
      isGroupReportLoading(true);
      var res = await _groupRepo.messageReport(reqModel: reqModel);
      if (res.data!['success'] == true) {
        TostWidget().successToast(
            title: "Success", message: res.data!['message'].toString());
        isGroupReportLoading(false);
        messageReportController.value.clear();
        backFromPrevious(context: Get.context!);
      } else {
        TostWidget().errorToast(
            title: "Error", message: res.data!['message'].toString());

        isGroupReportLoading(false);
        backFromPrevious(context: Get.context!);
      }
    } catch (e) {
      log("Error is ${e.toString()}");
      groupReportController.value.clear();
      isGroupReportLoading(false);
      backFromPrevious(context: Get.context!);
    }
  }
}
