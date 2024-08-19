import 'dart:developer';
import 'dart:io';

import 'package:cpscom_admin/Api%20Provider/api_client.dart';
import 'package:cpscom_admin/Api%20Provider/api_response.dart';
import 'package:cpscom_admin/Api/urls.dart';
import 'package:cpscom_admin/Features/Login/user_model.dart';
import 'package:cpscom_admin/Utils/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../Model/user_profle_model.dart';

class AuthRepo {
  final Dio dio = Dio();
  final localStorage = LocalStorage();
  final _apiClient = ApiClient();

  //USER LOGIN SERVICE
  Future<ApiResponse<UserModel>> userLogin(
      {required Map<String, dynamic> reqModel}) async {
    final response = await _apiClient.postRequest<UserModel>(
        endPoint: EndPoints.userLogin,
        fromJosn: (data) => UserModel.fromJson(data),
        reqModel: reqModel);
    if (response.errorMessage != null) {
      return ApiResponse<UserModel>(
          statusCode: response.statusCode, errorMessage: response.errorMessage);
    } else {
      return ApiResponse<UserModel>(
          data: response.data, statusCode: response.statusCode);
    }
  }

  //USER PROFILE DATA SERVICE
  Future<ApiResponse<UserProfileModel>> getUserProfile() async {
    final response = await _apiClient.getRequest(
        endPoint: EndPoints.getUserProfileData,
        fromJson: (data) => UserProfileModel.fromJson(data));
    if (response.errorMessage != null) {
      return ApiResponse(
          statusCode: response.statusCode, errorMessage: response.errorMessage);
    } else {
      return ApiResponse(statusCode: response.statusCode, data: response.data);
    }
  }

  //UPDATE PROFILE WITH PICTURE AND NON PICTURE BOTH

  Future<ApiResponse<Map<String, dynamic>>> updateProfileDetails({
    required String status,
    File? groupImage,
  }) async {
    Map<String, dynamic> reqModel = {"accountStatus": status};
    final res = await _apiClient.uploadImage(
        endPoint: EndPoints.updateUserProfile,
        reqModel: reqModel,
        imageFile: groupImage,
        fromJson: (data) => data,
        imageFieldName: "file");
    if (res.errorMessage != null) {
      return ApiResponse(
          statusCode: res.statusCode, errorMessage: res.errorMessage);
    } else {
      return ApiResponse(statusCode: res.statusCode, data: res.data);
    }
  }

//   Future<Map> updateProfileDetails({
//     required String status,
//     required File groupImage,
//   }) async {
//     log("Update user details api calling....");
//     Response response;
//     var token = localStorage.getUserToken();
//     try {
//       dio.options.headers = {
//         'Content-Type': 'multipart/form-data',
//         'access-token': token
//       };
// 
//       FormData formData = FormData.fromMap({
//         "accountStatus": status,
//       });
//       if (groupImage.path.isNotEmpty) {
//         formData.files.add(MapEntry(
//           "file",
//           await MultipartFile.fromFile(groupImage.path,
//               filename: groupImage.path.split('/').last,
//               contentType: MediaType("images", "jpeg")),
//         ));
//       }
// 
//       response = await dio.post(ApiPath.updateProfileDetails, data: formData);
//       log("Update user details response ${response.data.toString()}");
//       if (response.statusCode == 200) {
//         return response.data;
//       } else {
//         throw Exception("Faild to load data");
//       }
//     } catch (e) {
//       log("Faild to fetch update user details api ${e.toString()}");
//       if (e is DioException) {
//         if (e.type == DioExceptionType.connectionTimeout ||
//             e.type == DioExceptionType.sendTimeout ||
//             e.type == DioExceptionType.receiveTimeout ||
//             e.type == DioExceptionType.unknown) {
//           //TostWidget().errorToast(title: "Error!", message: e.toString());
//           throw Exception("No Internet connection or network error");
//         } else if (e.type == DioExceptionType.badResponse) {
//           log(e.response.toString());
//           //TostWidget().errorToast(title: "Error!", message: e.toString());
//           throw Exception("Faild to load data");
//         }
//       }
//       throw Exception("Faild to make api the request : $e");
//     }
//   }
}
