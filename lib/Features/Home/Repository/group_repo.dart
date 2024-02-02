import 'dart:developer';

import 'package:cpscom_admin/Features/Home/Model/group_list_model.dart';
import 'package:cpscom_admin/Utils/storage_service.dart';
import 'package:dio/dio.dart';

import '../../../Api/urls.dart';

class GroupRepo {
  final Dio dio = Dio();
  final localStorage = LocalStorage();
  Future<GroupListModel> groupListService() async {
    var token = localStorage.getUserToken();
    log("Group list calling....");
    Response response;
    try {
      dio.options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'access-token': token
      };

      response = await dio.get(ApiPath.groupListApi);
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
}
