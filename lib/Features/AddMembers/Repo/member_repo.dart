import 'dart:developer';

import 'package:cpscom_admin/Features/AddMembers/Model/members_model.dart';
import 'package:dio/dio.dart';

import '../../../Api/urls.dart';
import '../../../Utils/storage_service.dart';

class MemberlistRepo {
  final Dio dio = Dio();
  final localStorage = LocalStorage();
  Future<MemberModel> getMemberList(
      {String? searchQuery, int? offset, int? limit}) async {
    var token = localStorage.getUserToken();
    log("Member list calling....");
    Response response;
    try {
      dio.options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'access-token': token
      };

      response = await dio.get(
          "${ApiPath.getAllUserDAta}?searchQuery=$searchQuery&offset=$offset&limit=$limit");
      log("Member list response ${response.data.toString()}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return MemberModel.fromJson(response.data);
      } else {
        return MemberModel();
      }
    } catch (e) {
      log("Error for call member list response ${e.toString()}");
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

  Future<Map> createGroup({required Map<String, dynamic> reqModel}) async {
    var token = localStorage.getUserToken();
    log("Craete group calling....");
    Response response;
    try {
      dio.options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'access-token': token
      };
      log("Req model for crating group ${reqModel.toString()}");
      response = await dio.post(ApiPath.craeteGroupApi, data: reqModel);
      log("Create group response ${response.data.toString()}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        return {};
      }
    } catch (e) {
      log("Error for call Create group response ${e.toString()}");
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
}
