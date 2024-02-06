import 'dart:developer';
import 'dart:io';

import 'package:cpscom_admin/Api/urls.dart';
import 'package:cpscom_admin/Features/Login/user_model.dart';
import 'package:cpscom_admin/Utils/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../Model/user_profle_model.dart';

class AuthRepo {
  final Dio dio = Dio();
  final localStorage = LocalStorage();

  Future<UserModel> userLogin({required Map<String, dynamic> reqModel}) async {
    log("Login api calling....");
    Response response;
    try {
      dio.options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      response = await dio.post(ApiPath.loginApi, data: reqModel);
      log("response after login ${response.data.toString()}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      } else {
        return UserModel();
      }
    } catch (e) {
      log("Error for call login api ${e.toString()}");
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.unknown) {
          // TostWidget().errorToast(title: "Error!", message: e.toString());
          throw Exception("No Internet connection or network error");
        } else if (e.type == DioExceptionType.badResponse) {
          // TostWidget().errorToast(title: "Error!", message: e.toString());
          throw Exception("Faild to load data");
        }
      }
      throw Exception("Faild to make api the request ");
    }
  }

  Future<UserProfileModel> getUserProfile() async {
    var token = localStorage.getUserToken();
    log("Get user profile api calling....");
    Response response;
    try {
      dio.options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'access-token': token
      };

      response = await dio.get(
        ApiPath.getUserDAta,
      );
      log("response Get user profile ${response.data.toString()}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserProfileModel.fromJson(response.data);
      } else {
        return UserProfileModel();
      }
    } catch (e) {
      log("Error for call Get user profile ${e.toString()}");
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.unknown) {
          // TostWidget().errorToast(title: "Error!", message: e.toString());
          throw Exception("No Internet connection or network error");
        } else if (e.type == DioExceptionType.badResponse) {
          // TostWidget().errorToast(title: "Error!", message: e.toString());
          throw Exception("Faild to load data");
        }
      }
      throw Exception("Faild to make api the request ");
    }
  }

  Future<Map> updateProfileDetails({
    required String status,
    required File groupImage,
  }) async {
    log("Update user details api calling....");
    Response response;
    var token = localStorage.getUserToken();
    try {
      dio.options.headers = {
        'Content-Type': 'multipart/form-data',
        'access-token': token
      };

      FormData formData = FormData.fromMap({
        "accountStatus": status,
      });
      if (groupImage.path.isNotEmpty) {
        formData.files.add(MapEntry(
          "file",
          await MultipartFile.fromFile(groupImage.path,
              filename: groupImage.path.split('/').last,
              contentType: MediaType("images", "jpeg")),
        ));
      }

      response = await dio.post(ApiPath.updateProfileDetails, data: formData);
      log("Update user details response ${response.data.toString()}");
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Faild to load data");
      }
    } catch (e) {
      log("Faild to fetch update user details api ${e.toString()}");
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.unknown) {
          //TostWidget().errorToast(title: "Error!", message: e.toString());
          throw Exception("No Internet connection or network error");
        } else if (e.type == DioExceptionType.badResponse) {
          log(e.response.toString());
          //TostWidget().errorToast(title: "Error!", message: e.toString());
          throw Exception("Faild to load data");
        }
      }
      throw Exception("Faild to make api the request : $e");
    }
  }
}
