import 'dart:io';

import 'package:cpscom_admin/Api%20Provider/api_client.dart';
import 'package:cpscom_admin/Api%20Provider/api_response.dart';
import 'package:cpscom_admin/Features/AddMembers/Model/members_model.dart';
import 'package:dio/dio.dart';

import '../../../Api/urls.dart';
import '../../../Utils/storage_service.dart';

class MemberlistRepo {
  final Dio dio = Dio();
  final localStorage = LocalStorage();
  final _apiClient = ApiClient();

//GET ALL MEMBER
  Future<ApiResponse<MemberModel>> getMemberList(
      {String? searchQuery, int? offset, int? limit}) async {
    Map<String, dynamic> queryParameters = {
      "searchQuery": searchQuery,
      "offset": offset,
      "limit": limit
    };
    final response = await _apiClient.getRequest(
        endPoint: EndPoints.getMemberList,
        queryParameters: queryParameters,
        fromJson: (data) => MemberModel.fromJson(data));
    if (response.errorMessage != null) {
      return ApiResponse(
          statusCode: response.statusCode, errorMessage: response.errorMessage);
    } else {
      return ApiResponse(statusCode: response.statusCode, data: response.data);
    }
  }

  //CREATE A GROUP
  Future<ApiResponse<Map<String, dynamic>>> createNewGroup(
      {required String groupName,
      required List memberId,
      File? file,
      String? groupDescription}) async {
    Map<String, dynamic> reqModel = {
      "groupName": groupName,
      "users": memberId,
      "groupDescription": groupDescription ?? ""
    };
    final res = await _apiClient.uploadImage(
        endPoint: EndPoints.createNewGroup,
        fromJson: (data) => data,
        imageFieldName: "file",
        reqModel: reqModel);
    if (res.errorMessage != null) {
      return ApiResponse(
          statusCode: res.statusCode, errorMessage: res.errorMessage);
    } else {
      return ApiResponse(statusCode: res.statusCode, data: res.data);
    }
  }

  //DELETE MEMBER FROM GROUP
  Future<ApiResponse<Map<String, dynamic>>> deleteMemberFromGroup(
      {required Map<String, dynamic> reqModel}) async {
    final res = await _apiClient.postRequest(
        endPoint: EndPoints.deleteMemeberFromGroup,
        fromJosn: (data) => data,
        reqModel: reqModel);
    if (res.errorMessage != null) {
      return ApiResponse(
          statusCode: res.statusCode, errorMessage: res.errorMessage);
    } else {
      return ApiResponse(statusCode: res.statusCode, data: res.data);
    }
  }

  //ADD MEMBER IN GROUP
  Future<ApiResponse<Map<String, dynamic>>> addMemberInGroup(
      {required Map<String, dynamic> reqModel}) async {
    final res = await _apiClient.postRequest(
        endPoint: EndPoints.addMemberInGroup,
        fromJosn: (data) => data,
        reqModel: reqModel);
    if (res.errorMessage != null) {
      return ApiResponse(
          statusCode: res.statusCode, errorMessage: res.errorMessage);
    } else {
      return ApiResponse(statusCode: res.statusCode, data: res.data);
    }
  }
}
