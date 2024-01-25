// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cpscom_admin/Api/api_provider.dart';
import 'package:cpscom_admin/Commons/route.dart';
import 'package:cpscom_admin/Features/Login/Presentation/login_screen.dart';
import 'package:cpscom_admin/Utils/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  RxBool isChangingPassword = false.obs;
  RxBool showPassword = false.obs;
  RxBool showCnfPass = false.obs;

  var onlPasswordController = TextEditingController().obs;
  var newPasswordController = TextEditingController().obs;
  var cnfPasswordController = TextEditingController().obs;
  ApiProvider apiProvider = ApiProvider();

  void showPass(bool v) {
    showPassword.value = v;
  }

  void showCnf(bool v) {
    showCnfPass.value = v;
  }

  void changePassword(BuildContext context, String userEmail) async {
    isChangingPassword(true);
    Map<String, dynamic> reqModel = {
      "email": userEmail.trim(),
      "password": newPasswordController.value.text.trim(),
      "new_password": cnfPasswordController.value.text.trim()
    };
    log(reqModel.toString());
    var res = await apiProvider.changePassword(reqModel: reqModel);
    log(res.toString());
    if (res['status'] == true) {
      customSnackBar(context, res['message'].toString());
      context.pushAndRemoveUntil(const LoginScreen());
    } else {
      customSnackBar(context, res['message']);
      isChangingPassword(false);
    }

    isChangingPassword(false);
  }
}
