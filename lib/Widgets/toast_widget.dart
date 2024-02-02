import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TostWidget {
  errorToast({String? title, String? message}) {
    return Get.snackbar(title ?? "Invalid!", message ?? "",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        forwardAnimationCurve: Curves.easeInOutBack,
        dismissDirection: DismissDirection.up,
        shouldIconPulse: true,
        overlayBlur: 1,
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
        //animationDuration: Duration(seconds: 1),
        margin: const EdgeInsets.only(left: 40, right: 40, bottom: 20));
  }

  successToast({String? title, String? message}) {
    return Get.snackbar(title ?? "Success", message ?? "",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: const Icon(
          Icons.done,
          color: Colors.white,
        ),
        forwardAnimationCurve: Curves.easeInOutBack,
        margin: const EdgeInsets.only(left: 40, right: 40, bottom: 20));
  }
}
