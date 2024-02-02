// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cpscom_admin/Features/Home/Presentation/home_screen.dart';
import 'package:cpscom_admin/Features/Login/Repo/respository.dart';
import 'package:cpscom_admin/Utils/navigator.dart';
import 'package:cpscom_admin/Utils/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Widgets/toast_widget.dart';
import '../Model/user_profle_model.dart';

class LoginController extends GetxController {
  final _authRepo = AuthRepo();
  var emailController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  final localStorage = LocalStorage();
  RxBool isPasswordVisible = true.obs;
  toggleIsPasswordVisible() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  RxBool isLoginLaoding = false.obs;
  userLogin({required BuildContext context}) async {
    try {
      isLoginLaoding(true);
      Map<String, dynamic> reqModel = {
        "id": emailController.value.text.toString(),
        "password": passwordController.value.text.toString()
      };
      log("Login request model ${reqModel.toString()}");
      var res = await _authRepo.userLogin(reqModel: reqModel);
      if (res.success == true) {
        getUserProfile();
        TostWidget().successToast(title: "Login Success", message: res.message);
        localStorage.setToken(token: res.data?.token.toString());
        localStorage.setUserId(userId: res.data?.user?.sId.toString());
        isLoginLaoding(false);
        doNavigateWithReplacement(route: const HomeScreen(), context: context);
      } else {
        TostWidget().errorToast(title: "Error", message: res.message);
        isLoginLaoding(false);
      }
    } catch (e) {
      log(e.toString());
      isLoginLaoding(false);
    }
  }

  RxBool isUserLaoding = false.obs;
  var userModel = User().obs;
  getUserProfile() async {
    isUserLaoding(true);
    try {
      var res = await _authRepo.getUserProfile();
      if (res.success == true) {
        userModel.value = res.data!.user!;
        isUserLaoding(false);
      } else {
        userModel.value = User();
        isUserLaoding(false);
      }
    } catch (e) {
      isUserLaoding(false);
    }
  }
}
