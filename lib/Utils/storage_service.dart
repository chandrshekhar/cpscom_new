import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  final GetStorage storage = GetStorage();
  void setUserId({String? userId}) {
    storage.write("userId", userId);
  }

  void setToken({String? token}) {
    storage.write("userToken", token);
  }

  // void setPassword({String? password}) {
  //   storage.write("password", password);
  // }

  // String getPassword() {
  //   return storage.read("password") ?? "";
  // }

  String getUserId() {
    return storage.read("userId") ?? "";
  }

  String getUserToken() {
    return storage.read("userToken") ?? "";
  }

  void deleteAllLocalData() {
    debugPrint("Deleting all local data....");
    storage.erase();
  }
}
