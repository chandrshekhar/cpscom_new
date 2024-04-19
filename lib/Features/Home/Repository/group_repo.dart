import 'dart:developer';
import 'dart:io';

import 'package:cpscom_admin/Features/Home/Model/group_list_model.dart';
import 'package:cpscom_admin/Utils/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../Api/urls.dart';

class GroupRepo {
  final Dio dio = Dio();
  final localStorage = LocalStorage();
  Future<GroupListModel> groupListService(
      {String? searchQuery, int? limit, int? offset}) async {
    var token = localStorage.getUserToken();
    log("Group list calling....");
    Response response;
    try {
      dio.options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'access-token': token
      };

      response = await dio.get(
          "${ApiPath.groupListApi}?searchQuery=$searchQuery&limit=$limit&offset=$offset");
      log("Group list response ${response.data.toString()}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return GroupListModel.fromJson(response.data);
      } else {
        return GroupListModel();
      }
    } catch (e) {
      log("Error for call Group list response ${e.toString()}");
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

  Future<GroupModel> getGroupDetailsById({
    required String groupId,
  }) async {
    var token = localStorage.getUserToken();
    log("Group details by id calling....");
    Response response;
    try {
      dio.options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'access-token': token
      };

      response = await dio.get("${ApiPath.getGroupById}?id=$groupId");
      log("Group details by id response ${response.data.toString()}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return GroupModel.fromJson(response.data['data']);
      } else {
        return GroupModel();
      }
    } catch (e) {
      log("Error for call Group details by id response ${e.toString()}");
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

  Future<Map> updateGroupDetails(
      {required String groupId,
      required String groupName,
      required File groupImage,
      required String groupDes}) async {
    log("Update group details api calling....");
    Response response;
    var token = localStorage.getUserToken();
    try {
      dio.options.headers = {
        'Content-Type': 'multipart/form-data',
        'access-token': token
      };
      log("Token is $token");
      FormData formData = FormData.fromMap({
        "groupId": groupId,
        "groupName": groupName,
        "groupDescription": groupDes
      });
      if (groupImage.path.isNotEmpty) {
        formData.files.add(MapEntry(
          "file",
          await MultipartFile.fromFile(groupImage.path,
              filename: groupImage.path.split('/').last,
              contentType: MediaType("images", "jpeg")),
        ));
      }
      response = await dio.post(ApiPath.updateGroupDetails, data: formData);
      log(response.data.toString());
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Faild to load data");
      }
    } catch (e) {
      log(e.toString());
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
