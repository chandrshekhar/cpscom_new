class ChatListModel {
  bool? success;
  String? message;
  List<ChatModel>? chat;
  ChatListModel({this.success, this.message, this.chat});
  ChatListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      chat = <ChatModel>[];
      json['data'].forEach((v) {
        chat!.add(ChatModel.fromJson(v));
      });
    }
  }
}

class ChatModel {
  dynamic? sId;
  dynamic? groupId;
  dynamic senderId;
  dynamic senderName;
  dynamic message;
  dynamic messageType;
  bool? forwarded;
  List<ChatDeliveredTo>? deliveredTo;
  List<ChatReadBy>? readBy;
  List<dynamic>? deletedBy;
  List<dynamic>? allRecipients;
  dynamic timestamp;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic fileName;
  int? iV;
  dynamic id;
  ReplyOf? replyOf;
  // List<CurrentUsers>? currentUsers;

  ChatModel(
      {this.sId,
      this.groupId,
      this.senderId,
      this.allRecipients,
      this.senderName,
      this.message,
      this.messageType,
      this.fileName,
      this.forwarded,
      this.deliveredTo,
      this.readBy,
      this.deletedBy,
      this.timestamp,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.id,
      this.replyOf,
    });

  ChatModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    groupId = json['groupId'];
    senderId = json['senderId'];
    senderName = json['senderName'];
    message = json['message'];
    messageType = json['messageType'];
    forwarded = json['forwarded'];
    fileName = json['fileName'];
    allRecipients = json['allRecipients'];
   
    deletedBy =
        json['deletedBy'] == null ? null : json['deletedBy'] as List<dynamic>?;
    if (json['deliveredTo'] != null) {
      deliveredTo = <ChatDeliveredTo>[];
      json['deliveredTo'].forEach((v) {
        deliveredTo!.add(ChatDeliveredTo.fromJson(v));
      });
    }
    if (json['readBy'] != null) {
      readBy = <ChatReadBy>[];
      json['readBy'].forEach((v) {
        readBy!.add(ChatReadBy.fromJson(v));
      });
    }

    replyOf =
        json['replyOf'] != null ? ReplyOf.fromJson(json['replyOf']) : null;

    timestamp = json['timestamp'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
  }
}

class ChatDeliveredTo {
  String? user;
  String? timestamp;
  String? sId;
  String? id;

  ChatDeliveredTo({this.user, this.timestamp, this.sId, this.id});

  ChatDeliveredTo.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    timestamp = json['timestamp'];
    sId = json['_id'];
    id = json['id'];
  }
}

class ChatReadBy {
  User? user;
  String? timestamp;
  String? sId;
  String? id;

  ChatReadBy({this.user, this.timestamp, this.sId, this.id});

  ChatReadBy.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    timestamp = json['timestamp'];
    sId = json['_id'];
    id = json['id'];
  }
}

class User {
  String? sId;
  String? name;
  String? image;

  User({this.sId, this.name, this.image});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    image = json['image'];
  }
}

class ReplyOf {
  String? msgId;
  String? sender;
  String? msg;
  String? msgType;

  ReplyOf({this.msgId, this.sender, this.msg, this.msgType});

  ReplyOf.fromJson(Map<String, dynamic> json) {
    msgId = json['msgId'];
    sender = json['sender'];
    msg = json['msg'];
    msgType = json['msgType'];
  }
}

