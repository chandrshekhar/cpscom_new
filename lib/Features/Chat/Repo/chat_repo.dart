import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cpscom_admin/Api/urls.dart';
import 'package:dio/dio.dart';

import '../../../Utils/storage_service.dart';
import '../Model/chat_list_model.dart';

class ChatRepo {
  final Dio dio = Dio();
  final localStorage = LocalStorage();
  Future<ChatListModel> getChatListApi(
      {required Map<String, dynamic> reqModel}) async {
    var token = localStorage.getUserToken();
    log("Chat list calling....");
    Response response;
    try {
      dio.options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'access-token': token
      };

      response = await dio.post(ApiPath.getAlChat, data: reqModel);
      log("Chat list response ${response.data.toString()}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChatListModel.fromJson(response.data);
      } else {
        return ChatListModel();
      }
    } catch (e) {
      log("Error for call Chat list response ${e.toString()}");
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

  Future<Map> sendMessage(
      {required String groupId,
      required String senderName,
      required String message,
      required String messageType,
      required Map<String, dynamic>? replyOf,
      File? file
      // required File groupImage,
      }) async {
    log("Sending message....");
    Response response;
    var token = localStorage.getUserToken();
    var senderId = localStorage.getUserId();
    try {
      dio.options.headers = {
        'Content-Type': 'multipart/form-data',
        'access-token': token
      };

      FormData formData = FormData.fromMap({
        "replyOf": jsonEncode(replyOf),
        "groupId": groupId,
        "senderName": senderName,
        "senderId": senderId,
        "message": message,
        "messageType": messageType
      });
      if (file != null) {
        formData.files.add(MapEntry(
          "file",
          await MultipartFile.fromFile(
            file.path,
            // filename: file.path.split('/').last,
            //contentType: MediaType("images", "jpeg"),
          ),
        ));
      }

      response = await dio.post(ApiPath.sendSmsApi, data: formData);
      log("Update send msg response ${response.data.toString()}");
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Faild to load data");
      }
    } catch (e) {
      log("Faild to fetch msg api ${e.toString()}");
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

  Future<Map> grouopReport({required Map<String, dynamic> reqModel}) async {
    var token = localStorage.getUserToken();
    log("grouopReport  calling....");
    Response response;
    try {
      dio.options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'access-token': token
      };

      response = await dio.post(ApiPath.groupReportApi, data: reqModel);
      log("group report response ${response.data.toString()}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        return {};
      }
    } catch (e) {
      log("Error for call Chat list response ${e.toString()}");
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

  Future<Map> messageReport({required Map<String, dynamic> reqModel}) async {
    var token = localStorage.getUserToken();
    log("messageReport calling....");
    Response response;
    try {
      dio.options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'access-token': token
      };

      response = await dio.post(ApiPath.messageReportApi, data: reqModel);
      log("messageReport response ${response.data.toString()}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        return {};
      }
    } catch (e) {
      log("Error for call messageReport response ${e.toString()}");
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
