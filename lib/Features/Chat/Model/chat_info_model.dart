import 'package:cpscom_admin/Features/Home/Model/group_list_model.dart';

class ChatInfoModel {
  bool? success;
  String? message;
  Data? data;

  ChatInfoModel({this.success, this.message, this.data});

  ChatInfoModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  String? sId;
  String? message;
  String? messageType;
  String? createdAt;
  List<ReadUserData>? readUserData;
  List<DeliveredTo>? deliveredToData;

  Data(
      {this.sId,
      this.message,
      this.messageType,
      this.createdAt,
      this.readUserData,
      this.deliveredToData});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    message = json['message'];
    messageType = json['messageType'];
    createdAt = json['createdAt'];
    if (json['readUserData'] != null) {
      readUserData = <ReadUserData>[];
      json['readUserData'].forEach((v) {
        readUserData!.add(new ReadUserData.fromJson(v));
      });
    }
    if (json['deliveredToData'] != null) {
      deliveredToData = <DeliveredTo>[];
      json['deliveredToData'].forEach((v) {
        deliveredToData!.add(new DeliveredTo.fromJson(v));
      });
    }
  }
}

class ReadUserData {
  String? sId;
  String? name;
  String? timestamp;
  String? image;

  ReadUserData({this.sId, this.name, this.timestamp, this.image});

  ReadUserData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    timestamp = json['timestamp'];
    image = json['image'];
  }
}

class DeleveredTo {
  String? sId;
  String? name;
  String? timestamp;
  String? image;

  DeleveredTo({this.sId, this.name, this.timestamp, this.image});

  DeleveredTo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    timestamp = json['timestamp'];
    image = json['image'];
  }
}
