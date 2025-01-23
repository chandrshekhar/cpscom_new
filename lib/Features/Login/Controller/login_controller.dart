// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:cpscom_admin/Features/Home/Presentation/home_screen.dart';
import 'package:cpscom_admin/Features/Login/Repo/respository.dart';
import 'package:cpscom_admin/Utils/navigator.dart';
import 'package:cpscom_admin/Utils/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Utils/app_preference.dart';
import '../../../Widgets/toast_widget.dart';
import '../Model/user_profle_model.dart';

class LoginController extends GetxController {
  final _authRepo = AuthRepo();
  var emailController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  final localStorage = LocalStorage();
  RxBool isPasswordVisible = true.obs;
  var statusController = TextEditingController().obs;
  toggleIsPasswordVisible() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  RxBool isLoginLaoding = false.obs;
  userLogin({required BuildContext context}) async {
    try {
      String? fcmToken = await AppPreference().getFirebaseToken();
      isLoginLaoding(true);
      log("fcm--> $fcmToken");
      Map<String, dynamic> reqModel = {
        "id": emailController.value.text.toString().toLowerCase(),
        "password": passwordController.value.text.toString(),
        "firebaseToken": fcmToken
      };
      log("Login request model ${reqModel.toString()}");
      var res = await _authRepo.userLogin(reqModel: reqModel);
      if (res.data!.success == true) {
        getUserProfile();
        TostWidget().successToast(title: "Login Success", message: res.data!.message);
        localStorage.setToken(token: res.data?.data?.token.toString());
        localStorage.setUserId(userId: res.data?.data?.user?.sId.toString());
        isLoginLaoding(false);
        doNavigateWithReplacement(route: const HomeScreen(isDeleteNavigation: false,), context: context);
      } else {
        TostWidget().errorToast(title: "Error", message: res.data?.error);
        isLoginLaoding(false);
      }
    } catch (e) {
      log(e.toString());
      isLoginLaoding(false);
    }
  }

  RxBool isUserLaoding = false.obs;
  Rx<User> userModel = User().obs;
  getUserProfile({bool isrefresh = true}) async {
    isrefresh ? isUserLaoding(true) : null;
    try {
      var res = await _authRepo.getUserProfile();
      if (res.data?.success == true) {
        userModel.value = res.data!.data!.user!;
        statusController.value.text = res.data!.data!.user!.accountStatus ?? "";
        isUserLaoding(false);
      } else {
        userModel.value = User();
        isUserLaoding(false);
      }
    } catch (e) {
      isUserLaoding(false);
    }
  }

  Future<void> pickImage({required ImageSource imageSource, required BuildContext context}) async {
    try {
      final selected = await ImagePicker().pickImage(imageQuality: 50, source: imageSource);
      if (selected != null) {
        File groupImages = File(selected.path);

        updateUserDetails(status: "", image: groupImages);
      } else {}
    } on Exception {}
  }

  RxBool isUserUpdateLoading = false.obs;
  updateUserDetails({required String status, File? image}) async {
    try {
      isUserUpdateLoading(true);
      var res = await _authRepo.updateProfileDetails(status: status, groupImage: image);
      if (res.data!["success"] == true) {
        await getUserProfile();
        TostWidget().successToast(title: "Successful", message: res.data!['message']);
        getUserProfile();
        isUserUpdateLoading(false);
      } else {
        TostWidget().errorToast(title: "Error", message: res.data!['message']);
        isUserUpdateLoading(false);
      }
    } catch (e) {
      isUserUpdateLoading(false);
    }
  }

  RxBool isLoading = false.obs;
  Future<bool> logout() async {
    String userId = LocalStorage().getUserId();
    Map<String, dynamic> reqModel = {"user_id": userId};
    try {
      isLoading(true);
      final res = await _authRepo.userLogout(reqModel: reqModel);
      if (res.errorMessage != null) {
        return false;
      } else if (res.data!['success'] == false) {
        return false;
      } else {
        return true;
      }
    } finally {
      isLoading(false);
    }
  }
}
