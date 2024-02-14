import 'dart:developer';

import 'package:cpscom_admin/Api/urls.dart';
import 'package:cpscom_admin/Features/ReportScreen/Model/user_report_model.dart';
import 'package:cpscom_admin/Features/Splash/Model/get_started_response_model.dart';
import 'package:cpscom_admin/Models/send_notification_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiProvider {
  final Dio _dio = Dio();

  ///--------- Fetch CMS Get Started  -----///
  Future<ResponseGetStarted> getStarted(
      RequestGetStarted requestGetStarted) async {
    try {
      Response response = await _dio.post(Urls.baseUrl + Urls.cmsGetStarted,
          data: requestGetStarted.toJson());
      if (kDebugMode) {
        log('--------Response Get Started : $response');
      }
      return response.statusCode == 200
          ? ResponseGetStarted.fromJson(response.data)
          : throw Exception('Something Went Wrong');
    } catch (error, stacktrace) {
      if (kDebugMode) {
        log("Exception occurred: $error stackTrace: $stacktrace");
      }
      return ResponseGetStarted.withError(
          "You're offline. Please check your Internet connection.");
    }
  }

  ///--------- User Report Api Call  -----///
  Future<UserReportResponseModel> userReport(
      Map<String, dynamic> requestUserReport) async {
    try {
      Response response =
          await _dio.post(Urls.baseUrl + Urls.report, data: requestUserReport);
      if (kDebugMode) {
        log('--------Response Report : $response');
      }
      return response.statusCode == 200
          ? UserReportResponseModel.fromJson(response.data)
          : throw Exception('Something Went Wrong');
    } catch (error, stacktrace) {
      if (kDebugMode) {
        log("Exception occurred: $error stackTrace: $stacktrace");
      }
      return UserReportResponseModel.withError(
          "You're offline. Please check your Internet connection.");
    }
  }

  Future<ResponseSendNotification> sendNotification(
      RequestSendNotification requestSendNotification) async {
    try {
      Response response = await _dio.post(Urls.sendPushNotificationUrl,
          data: requestSendNotification.toJson());
      if (kDebugMode) {
        log('--------Response Send Notification : $response');
      }
      return response.statusCode == 200
          ? ResponseSendNotification.fromJson(response.data)
          : throw Exception('Something Went Wrong');
    } catch (error, stacktrace) {
      if (kDebugMode) {
        log("Exception occurred: $error stackTrace: $stacktrace");
      }
      return ResponseSendNotification.withError(
          "You're offline. Please check your Internet connection.");
    }
  }

  ///--------- Forget password-----///

  Future<Map> forgetPassword(String email) async {
    Map<String, dynamic> reqModel = {"email": email.trim()};

    log("req--> $reqModel");
    try {
      _dio.options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      Response response =
          await _dio.post(Urls.forgetPasswordurl, data: reqModel);
      if (kDebugMode) {
        log('--------Response forgetPassword : ${response.data}');
      }
      return response.statusCode == 200
          ? response.data
          : throw Exception('Something Went Wrong');
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.unknown) {
          // log("bed res--> ${e.response?.data}");
          return {"status": false, "message": e.response!.data['message']};
          // throw Exception("No Internet connection or network error");
        } else if (e.type == DioExceptionType.badResponse) {
          // throw Exception("Faild to load data");
          log(e.response!.data.toString());
          return {"status": false, "message": e.response!.data['message']};
        }
      }
      return {"status": false, "message": "Something went wrong"};
    }
  }

  ///--------- Forget password-----///

  Future<Map> verifyOtp({required String email, required String otp}) async {
    Map<String, dynamic> reqModel = {"email": email.trim(), "otp": otp.trim()};
    try {
      _dio.options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      Response response = await _dio.post(Urls.verifyOtp, data: reqModel);
      if (kDebugMode) {
        log('--------Response forgetPassword : ${response.data}');
      }
      return response.statusCode == 200
          ? response.data
          : throw Exception('Something Went Wrong');
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.unknown) {
          // log("bed res--> ${e.response?.data}");
          return {"status": false, "message": e.response!.data['message']};
          // throw Exception("No Internet connection or network error");
        } else if (e.type == DioExceptionType.badResponse) {
          // throw Exception("Faild to load data");
          log(e.response!.data.toString());
          return {"status": false, "message": e.response!.data['message']};
        }
      }
      return {"status": false, "message": "Something went wrong"};
    }
  }

  ///--------- reset password-----///

  Future<Map> resetpassword(
      {required String email,
      required String password,
      required String cnfPassword, required String slug}) async {
    Map<String, dynamic> reqModel = {
      "email": email.trim(),
      "slug":slug,
      "password": password.trim(),
      "confirmPassword": cnfPassword.trim()
    };
    log(reqModel.toString());
    try {
      _dio.options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      Response response = await _dio.post(Urls.resetPassword, data: reqModel);
      if (kDebugMode) {
        log('--------Response forgetPassword : ${response.data}');
      }
      return response.statusCode == 200
          ? response.data
          : throw Exception('Something Went Wrong');
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.unknown) {
          // log("bed res--> ${e.response?.data}");
          return {"status": false, "message": e.response!.data['error']};
          // throw Exception("No Internet connection or network error");
        } else if (e.type == DioExceptionType.badResponse) {
          // throw Exception("Faild to load data");
          log(e.response!.data.toString());
          return {"status": false, "message": e.response!.data['error']};
        }
      }
      return {"status": false, "message": "Something went wrong"};
    }
  }

  ///--------- Upload  Group Image -----///
  // Future<ResponseImageUpload> uploadGroupImage(
  //     Map<String, dynamic> request) async {
  //   String url = Urls.baseUrl + Urls.groupImageUpload;
  //   try {
  //     Response response = await _dio.post(url, data: request);
  //     log('--------Response Groups List : $response');
  //     return response.statusCode == 200
  //         ? ResponseImageUpload.fromJson(response.data)
  //         : throw Exception('Something Went Wrong');
  //   } catch (error, stacktrace) {
  //     log("Exception occurred: $error stackTrace: $stacktrace");
  //     return ResponseImageUpload.withError(
  //         "You're offline. Please check your Internet connection.");
  //   }
  // }

// ///--------- Create Group  -----///
// Future<ResponseCreateGroup> createGroups(Map<String, dynamic> request) async {
//   String url = Urls.baseUrl + Urls.groupCreateGroup;
//   try {
//     Response response = await _dio.post(url, data: request);
//     log('--------Response Groups List : $response');
//     return response.statusCode == 200
//         ? ResponseCreateGroup.fromJson(response.data)
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     log("Exception occurred: $error stackTrace: $stacktrace");
//     return ResponseCreateGroup.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
}
