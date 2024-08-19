import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cpscom_admin/Api%20Provider/api_client.dart';
import 'package:cpscom_admin/Api%20Provider/api_response.dart';
import 'package:cpscom_admin/Api/urls.dart';
import 'package:dio/dio.dart';

import '../../../Utils/storage_service.dart';
import '../Model/chat_list_model.dart';

class ChatRepo {
  final Dio dio = Dio();
  final localStorage = LocalStorage();
  final _apiClient = ApiClient();

  //GET CHAT LIST
  Future<ApiResponse<ChatListModel>> getChatListApi(
      {required Map<String, dynamic> reqModel}) async {
    final res = await _apiClient.postRequest(
        endPoint: EndPoints.getAllChat,
        fromJosn: (data) => ChatListModel.fromJson(data),
        reqModel: reqModel);
    if (res.errorMessage != null) {
      return ApiResponse(
          statusCode: res.statusCode, errorMessage: res.errorMessage);
    } else {
      return ApiResponse(statusCode: res.statusCode, data: res.data);
    }
  }

  //SEND MESSAGE API
  Future<ApiResponse<Map<String, dynamic>>> sendMessage(
      {required String groupId,
      required String senderName,
      required String message,
      required String messageType,
      required Map<String, dynamic>? replyOf,
      File? file}) async {
    var senderId = localStorage.getUserId();
    Map<String, dynamic> reqModel = {
      "replyOf": jsonEncode(replyOf),
      "groupId": groupId,
      "senderName": senderName,
      "senderId": senderId,
      "message": message,
      "messageType": messageType
    };
    final res = await _apiClient.uploadImage(
        imageFile: file,
        imageFieldName: "file",
        endPoint: EndPoints.sendMessage,
        fromJson: (data) => data,
        reqModel: reqModel);
    if (res.errorMessage != null) {
      return ApiResponse(
          statusCode: res.statusCode, errorMessage: res.errorMessage);
    } else {
      return ApiResponse(statusCode: res.statusCode, data: res.data);
    }
  }

  //REPORT GROUP SERVICE

  Future<ApiResponse<Map>> grouopReport(
      {required Map<String, dynamic> reqModel}) async {
    final res = await _apiClient.postRequest(
        endPoint: EndPoints.reportGroup,
        fromJosn: (data) => data,
        reqModel: reqModel);
    if (res.errorMessage != null) {
      return ApiResponse(
          statusCode: res.statusCode, errorMessage: res.errorMessage);
    } else {
      return ApiResponse(statusCode: res.statusCode, data: res.data);
    }
  }

//MESSAGE REPORT API SERVICE
  Future<ApiResponse<Map>> messageReport(
      {required Map<String, dynamic> reqModel}) async {
    final res = await _apiClient.postRequest(
        endPoint: EndPoints.messageReportApi,
        fromJosn: (data) => data,
        reqModel: reqModel);
    if (res.errorMessage != null) {
      return ApiResponse(
          statusCode: res.statusCode, errorMessage: res.errorMessage);
    } else {
      return ApiResponse(statusCode: res.statusCode, data: res.data);
    }
  }

//   Future<Map> messageReport({required Map<String, dynamic> reqModel}) async {
//     var token = localStorage.getUserToken();
//     log("messageReport calling....");
//     Response response;
//     try {
//       dio.options.headers = {
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//         'access-token': token
//       };
// 
//       response = await dio.post(ApiPath.messageReportApi, data: reqModel);
//       log("messageReport response ${response.data.toString()}");
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return response.data;
//       } else {
//         return {};
//       }
//     } catch (e) {
//       log("Error for call messageReport response ${e.toString()}");
//       if (e is DioException) {
//         if (e.type == DioExceptionType.connectionTimeout ||
//             e.type == DioExceptionType.sendTimeout ||
//             e.type == DioExceptionType.receiveTimeout ||
//             e.type == DioExceptionType.unknown) {
//           // TostWidget().errorToast(title: "Error!", message: e.toString());
//           throw Exception("No Internet connection or network error");
//         } else if (e.type == DioExceptionType.badResponse) {
//           // TostWidget().errorToast(title: "Error!", message: e.toString());
//           throw Exception("Faild to load data");
//         }
//       }
//       throw Exception("Faild to make api the request ");
//     }
//   }
}
