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
  String? sId;
  String? groupId;
  String? senderId;
  String? senderName;
  String? message;
  String? messageType;
  bool? forwarded;
  List<DeliveredTo>? deliveredTo;
  List<ReadBy>? readBy;
  List<dynamic>? deletedBy;
  String? timestamp;
  String? createdAt;
  String? updatedAt;
  String? fileName;
  int? iV;
  String? id;
  ReplyOf? replyOf;
  List<CurrentUsers>? currentUsers;

  ChatModel(
      {this.sId,
      this.groupId,
      this.senderId,
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
      this.currentUsers});

  ChatModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    groupId = json['groupId'];
    senderId = json['senderId'];
    senderName = json['senderName'];
    message = json['message'];
    messageType = json['messageType'];
    forwarded = json['forwarded'];
    fileName = json['fileName'];

    if (json['currentUsers'] != null) {
      currentUsers = <CurrentUsers>[];
      json['currentUsers'].forEach((v) {
        currentUsers!.add(CurrentUsers.fromJson(v));
      });
    }

    deletedBy =
        json['deletedBy'] == null ? null : json['deletedBy'] as List<dynamic>?;
    if (json['deliveredTo'] != null) {
      deliveredTo = <DeliveredTo>[];
      json['deliveredTo'].forEach((v) {
        deliveredTo!.add(DeliveredTo.fromJson(v));
      });
    }
    if (json['readBy'] != null) {
      readBy = <ReadBy>[];
      json['readBy'].forEach((v) {
        readBy!.add(ReadBy.fromJson(v));
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

class DeliveredTo {
  String? user;
  String? timestamp;
  String? sId;
  String? id;

  DeliveredTo({this.user, this.timestamp, this.sId, this.id});

  DeliveredTo.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    timestamp = json['timestamp'];
    sId = json['_id'];
    id = json['id'];
  }
}

class ReadBy {
  User? user;
  String? timestamp;
  String? sId;
  String? id;

  ReadBy({this.user, this.timestamp, this.sId, this.id});

  ReadBy.fromJson(Map<String, dynamic> json) {
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

class CurrentUsers {
  String? sId;
  String? name;
  String? phone;
  String? image;

  CurrentUsers({this.sId, this.name, this.phone, this.image});

  CurrentUsers.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
    image = json['image'];
  }
}
