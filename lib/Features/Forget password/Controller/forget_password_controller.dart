// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:cpscom_admin/Api/api_provider.dart';
import 'package:cpscom_admin/Commons/route.dart';
import 'package:cpscom_admin/Features/Forget%20password/presentation/forget_passrow.dart';
import 'package:cpscom_admin/Features/Forget%20password/presentation/reset_password.dart';
import 'package:cpscom_admin/Features/Login/Controller/login_controller.dart';
import 'package:cpscom_admin/Features/Login/Presentation/login_screen.dart';
import 'package:cpscom_admin/Utils/custom_snack_bar.dart';
import 'package:cpscom_admin/Utils/navigator.dart';
import 'package:cpscom_admin/Widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordControler extends GetxController {
  var forgetemailController = TextEditingController().obs;
  var otpController = TextEditingController().obs;
  var password = TextEditingController().obs;
  var cnfPassword = TextEditingController().obs;
  ApiProvider apiProvider = ApiProvider();
  RxBool isForgetPasswordLoading = false.obs;
  RxBool verifyingOtp = false.obs;
  RxBool isPasswordReseting = false.obs;
  RxString slug = "".obs;
  RxBool isPasswordVsible = true.obs;

  //change password
  var oldPasswordController = TextEditingController().obs;
  var newPasswordControllerChange = TextEditingController().obs;
  RxBool isChangingPassword = false.obs;
  RxBool showPassword = true.obs;
  RxBool showCnfPass = true.obs;

  final loginController = Get.put(LoginController());

  void showPass(bool v) {
    showPassword.value = v;
  }

  void showCnf(bool v) {
    showCnfPass.value = v;
  }

  void sentOtp(BuildContext context) async {
    isForgetPasswordLoading(true);
    forgetemailController.value = loginController.emailController.value;
    var res = await apiProvider.forgetPassword(forgetemailController.value.text.toLowerCase());
    if (res['success'] == true) {
      customSnackBar(context, res['data']['message'].toString());
      isForgetPasswordLoading(false);
      context.push(ForgetPasswordScreen());
    } else {
      customSnackBar(context, res['message'].toString());
      isForgetPasswordLoading(false);
    }
  }

  void verifyOtp(BuildContext context) async {
    verifyingOtp(true);
    var res = await apiProvider.verifyOtp(
        email: forgetemailController.value.text.toLowerCase(), otp: otpController.value.text);
    if (res['success'] == true) {
      slug.value = res['data']['slug'];
      customSnackBar(context, res['message'].toString());
      context.push(ResetPasswordPasswordScreen());
      otpController.value.text = "";
      verifyingOtp(false);
      password.value.text = "";
      cnfPassword.value.text = "";
    } else {
      customSnackBar(context, res['error'].toString());
      verifyingOtp(false);
      password.value.text = "";
      cnfPassword.value.text = "";
    }
  }

  void resetPassword(BuildContext context) async {
    isPasswordReseting(true);
    var res = await apiProvider.resetpassword(
        slug: slug.value,
        email: forgetemailController.value.text.toLowerCase(),
        password: password.value.text,
        cnfPassword: cnfPassword.value.text);
    if (res['success'] == true) {
      customSnackBar(context, res['message'].toString());
      context.pushAndRemoveUntil(const LoginScreen());
      otpController.value.text = "";
    } else {
      customSnackBar(context, res['error'].toString());
    }

    isPasswordReseting(false);
  }

  changePassword(BuildContext context) async {
    try {
      Map<String, dynamic> reqModel = {
        "oldPassword": oldPasswordController.value.text,
        "password": newPasswordControllerChange.value.text
      };
      isChangingPassword(true);
      var res = await apiProvider.changePassword(reqModel: reqModel);
      log("response for change password ${res.toString()}");
      if (res['success'] == true) {
        TostWidget().successToast(title: "Success", message: res['message'].toString());
        backFromPrevious(context: context);
        isChangingPassword(false);
      } else {
        TostWidget().errorToast(title: "Error!", message: res['error'].toString());
        isChangingPassword(false);
      }
    } catch (e) {
      print("djsfhdjsfh ${e.toString()}");
      // TostWidget().errorToast(title: "Error!", message: e.toString());
      isChangingPassword(false);
    }
  }
}
