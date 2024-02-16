class GroupListModel {
  bool? success;
  String? message;
  List<GroupModel>? groupModel;

  GroupListModel({this.success, this.message, this.groupModel});

  GroupListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      groupModel = <GroupModel>[];
      json['data'].forEach((v) {
        groupModel!.add(GroupModel.fromJson(v));
      });
    }
  }
}

class GroupModel {
  String? sId;
  String? groupName;
  String? groupImage;
  List<CurrentUsers>? currentUsers;
  List<dynamic>? previousUsers;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? id;
  List<dynamic>? currentUsersId;
  LastMessage? lastMessage;

  GroupModel(
      {this.sId,
      this.groupName,
      this.currentUsers,
      this.previousUsers,
      this.createdAt,
      this.updatedAt,
      this.groupImage,
      this.iV,
      this.id,
      this.currentUsersId,
      this.lastMessage});

  GroupModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    groupImage =
        json['groupImage'] == null ? null : json['groupImage'] as String?;
    groupName = json['groupName'];
    if (json['currentUsers'] != null) {
      currentUsers = <CurrentUsers>[];
      json['currentUsers'].forEach((v) {
        currentUsers!.add(CurrentUsers.fromJson(v));
      });
    }
    previousUsers = json['previousUsers'] == null
        ? null
        : json['previousUsers'] as List<dynamic>?;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
    currentUsersId = json['currentUsersId'] == null
        ? null
        : json['currentUsersId'] as List<dynamic>;
    lastMessage = json['lastMessage'] != null
        ? LastMessage.fromJson(json['lastMessage'])
        : null;
  }
}

class CurrentUsers {
  String? sId;
  String? name;
  String? phone;
  String? image;

  CurrentUsers(
      {this.sId,
      this.name,
      this.phone,
      this.image =
          "https://images.unsplash.com/photo-1575936123452-b67c3203c357?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D"});

  CurrentUsers.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
    image = json["image"] == null ? null : json['image'] as String?;
  }
}

class LastMessage {
  String? sId;
  String? groupId;
  String? senderId;
  String? senderName;
  String? message;
  String? messageType;
  dynamic forwarded;
  List<DeliveredTo>? deliveredTo;
  List<ReadBy>? readBy;
  List<dynamic>? deletedBy;
  String? timestamp;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? id;

  LastMessage(
      {this.sId,
      this.groupId,
      this.senderId,
      this.senderName,
      this.message,
      this.messageType,
      this.forwarded,
      this.deliveredTo,
      this.readBy,
      this.deletedBy,
      this.timestamp,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.id});

  LastMessage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    groupId = json['groupId'];
    senderId = json['senderId'];
    senderName = json['senderName'];
    message = json['message'];
    messageType = json['messageType'];
    forwarded = json['forwarded'];
    timestamp = json['timestamp'];
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

    deletedBy =
        json['deletedBy'] == null ? null : json[deletedBy] as List<dynamic>?;

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['groupId'] = groupId;
    data['senderId'] = senderId;
    data['senderName'] = senderName;
    data['message'] = message;
    data['messageType'] = messageType;
    data['forwarded'] = forwarded;
    // if (this.deliveredTo != null) {
    //   data['deliveredTo'] = this.deliveredTo!.map((v) => v.toJson()).toList();
    // }
    // if (this.readBy != null) {
    //   data['readBy'] = this.readBy!.map((v) => v.toJson()).toList();
    // }
    data['deletedBy'] = deletedBy;
    data['timestamp'] = timestamp;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['id'] = id;
    return data;
  }
}

class ReadBy {
  String? id;
  String? user;
  String? timestamp;

  ReadBy({
    this.id,
    this.user,
    this.timestamp,
  });

  ReadBy.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    user = json['user'];
    timestamp = json['timestamp'];
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
