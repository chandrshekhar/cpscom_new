import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Features/Home/Model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseProvider firebaseProvider = FirebaseProvider();
  var userModel = UserModel().obs;

  Future<UserModel?> getUserById() async {
    DocumentSnapshot userDocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (userDocument.exists) {
      return UserModel.fromJson(userDocument.data() as Map<String, dynamic>);
    } else {
      return null; // User with the given ID not found
    }
  }

  @override
  void onReady() {
    getUserById();
    super.onReady();
  }

  getUSerData() async {
    var result = await getUserById();
    userModel.value = result!;
    if (kDebugMode) {
      print(userModel.value.email);
    }
  }
}
