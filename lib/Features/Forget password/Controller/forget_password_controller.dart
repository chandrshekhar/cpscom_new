// ignore_for_file: use_build_context_synchronously
import 'package:cpscom_admin/Api/api_provider.dart';
import 'package:cpscom_admin/Commons/route.dart';
import 'package:cpscom_admin/Features/Forget%20password/presentation/forget_passrow.dart';
import 'package:cpscom_admin/Features/Forget%20password/presentation/reset_password.dart';
import 'package:cpscom_admin/Features/Login/Presentation/login_screen.dart';
import 'package:cpscom_admin/Utils/custom_snack_bar.dart';
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
  RxBool resetPasswordField = false.obs;

  void sentOtp(BuildContext context) async {
    isForgetPasswordLoading(true);
    var res =
        await apiProvider.forgetPassword(forgetemailController.value.text);
    if (res['status'] == true) {
      customSnackBar(context, res['message'].toString());
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
        email: forgetemailController.value.text, otp: otpController.value.text);
    if (res['status'] == true) {
      resetPasswordField(true);
      customSnackBar(context, res['message'].toString());
      context.push(ResetPasswordPasswordScreen());
      otpController.value.text = "";
      verifyingOtp(false);
      password.value.text = "";
      cnfPassword.value.text = "";
    } else {
      customSnackBar(context, res['message'].toString());
      verifyingOtp(false);
      password.value.text = "";
      cnfPassword.value.text = "";
    }
  }

  void resetPassword(BuildContext context) async {
    isPasswordReseting(true);
    var res = await apiProvider.resetpassword(
        email: forgetemailController.value.text,
        password: password.value.text,
        cnfPassword: cnfPassword.value.text);
    if (res['status'] == true) {
      customSnackBar(context, res['message'].toString());
      context.pushAndRemoveUntil(const LoginScreen());
      otpController.value.text = "";
    } else {
      customSnackBar(context, res['message'].toString());
    }

    isPasswordReseting(false);
  }
}
