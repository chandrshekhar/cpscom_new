import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:cpscom_admin/Features/Chat/Widget/receiver_tile.dart';
import 'package:cpscom_admin/Features/Chat/Widget/sender_tile.dart';
import 'package:cpscom_admin/Features/GroupInfo/Presentation/group_info_screen.dart';
import 'package:cpscom_admin/Features/Home/Model/group_list_model.dart';
import 'package:cpscom_admin/Features/ReportScreen/report_screen.dart';
import 'package:cpscom_admin/Utils/app_helper.dart';
import 'package:cpscom_admin/Utils/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../Widget/send_message_widget.dart';

class ChatScreen extends StatefulWidget {
  bool? isAdmin;
  final String groupId;
  final GroupModel groupModel;

  ChatScreen(
      {Key? key, this.isAdmin, required this.groupId, required this.groupModel})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final chatController = Get.put(ChatController());

  FocusNode focusNode = FocusNode();
  // Map<String, dynamic> chatMap = <String, dynamic>{};

  String replyWhom = '';
  String replyText = '';

  late TextEditingController msgController;

  //get current user details from firebase firestore
  // Future<void> updateMessageSeenStatus(
  //   String groupId,
  //   String messageId,
  //   String uid,
  //   String profilePicture,
  //   int index,
  // ) async {
  //   // Update chat member data for seen and delivered
  //   if (uid == auth.currentUser!.uid) {
  //     chatMemberData = {
  //       "isSeen": true,
  //       "isDelivered": true,
  //       "uid": auth.currentUser!.uid,
  //       "profile_picture": profilePicture,
  //       "name": auth.currentUser!.displayName,
  //     };

  //     // remove item from chat members and update with new data
  //     if (mem.length != null) {
  //       for (var i = 0; i < mem.length; i++) {
  //         if (i == index) {
  //           updatedChatMemberList.removeAt(i);
  //           updatedChatMemberList.add(chatMemberData);
  //           log('updated chat members - ${updatedChatMemberList[i]}');
  //         }
  //       }
  //     }
  //   }
  //   // update new data to firebase firestore
  //   await FirebaseProvider.firestore
  //       .collection('groups')
  //       .doc(groupId)
  //       .collection('chats')
  //       .doc(messageId)
  //       .update({'members': updatedChatMemberList}).then(
  //           (value) => 'Message Seen Status Updated ');
  // }

  void onSwipedMessage(Map<String, dynamic> message) {
    // log("-------------- ${message['sendBy']} - ${message['message']}");
    chatController.isRelayFunction(true);
    replyWhom = message['sendBy'];
    replyText = message['message'];
    FocusScope.of(context).unfocus();
    AppHelper.openKeyboard(context, focusNode);
  }

  void replyToMessage(Map<String, dynamic> message) {
    chatController.isRelayFunction(true);

    setState(() {});
  }

  void onCancelReply() {
    chatController.isRelayFunction(false);
    setState(() {});
  }

  ////////////
  // Future<void> pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     allowMultiple: true,
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf', 'doc', 'docx', 'mp4'],
  //   );
  //   if (result != null) {
  //     PlatformFile file = result.files.first;
  //     extension = file.extension;
  //     debugPrint("file extension--> $extension");
  //     List<File> files =
  //         result.paths.map((path) => File(path.toString())).toList();
  //     for (var i in files) {
  //       uploadImage(i, extension);
  //     }
  //   } else {
  //     // User canceled the picker
  //   }
  // }

  // Future pickImageFromGallery() async {
  //   List<XFile>? imageFileList = [];
  //   try {
  //     final images = await ImagePicker().pickMedia();
  //     // final images = await ImagePicker()
  //     //     .pickMultiImage(maxHeight: 512, maxWidth: 512, imageQuality: 75);
  //     if (images != null) {
  //       setState(() {
  //         imageFileList.add(images);
  //       });
  //       final extension = imageFileList.first.path.split(".").last;
  //       for (var i in imageFileList) {
  //         await uploadImage(File(i.path), extension);
  //       }
  //     } else {
  //       // User canceled the picker
  //     }
  //   } on PlatformException catch (e) {
  //     if (kDebugMode) {
  //       log('Failed to pick image: $e');
  //     }
  //   }
  // }
  // choose video from gallary

  // Future<void> pickImageFromGallery() async {
  //   final pickedFile = await ImagePicker().pickMedia();

  //   if (pickedFile != null) {
  //     // Handle the picked media file
  //     print(pickedFile.path);
  //   } else {
  //     // User canceled the picker
  //   }
  // }

  // Future pickImageFromCamera() async {
  //   try {
  //     final image = await ImagePicker().pickImage(
  //         source: ImageSource.camera,
  //         maxHeight: 512,
  //         maxWidth: 512,
  //         imageQuality: 75);
  //     if (image == null) return;
  //     final imageTemp = File(image.path);
  //     setState(() => imageFile = imageTemp);
  //     final extension = image.path.split(".").last;
  //     await uploadImage(imageFile!, extension);
  //   } on PlatformException catch (e) {
  //     if (kDebugMode) {
  //       log('Failed to pick image: $e');
  //     }
  //   }
  // }

  // Future uploadImage(File file, extension) async {
  //   String fileName = const Uuid().v1();
  //   // final ext = file.path.split('.').last;
  //   if (extension == 'pdf') {
  //     extType = "pdf";
  //   } else if (extension == 'jpg' ||
  //       extension == 'JPG' ||
  //       extension == 'jpeg' ||
  //       extension == 'png') {
  //     extType = "img";
  //   } else if (extension == 'doc' || extension == 'docx') {
  //     extType = "doc";
  //   } else if (extension == 'gif') {
  //     extType = "gif";
  //   }
  //   // } else if (extension == 'mp4' ||
  //   //     extension == 'avi' ||
  //   //     extension == 'MST' ||
  //   //     extension == 'M2TS' ||
  //   //     extension == 'mov' ||
  //   //     extension == 'TS' ||
  //   //     extension == 'QT' ||
  //   //     extension == 'wmv' ||
  //   //     extension == 'nkv' ||
  //   //     extension == 'avi' ||
  //   //     extension == 'm4p' ||
  //   //     extension == 'm4v' ||
  //   //     extension == '3gp' ||
  //   //     extension == 'mxf' ||
  //   //     extension == 'svi' ||
  //   //     extension == 'amv')
  //   else{
  //     extType = "mp4";
  //   }
  //   int status = 1;
  //   try {
  //     await _firestore
  //         .collection('groups')
  //         .doc(widget.groupId)
  //         .collection('chats')
  //         .doc(fileName)
  //         .set({
  //       "sendBy": _auth.currentUser!.displayName,
  //       "sendById": _auth.currentUser!.uid,
  //       "message": "",
  //       'profile_picture': profilePicture,
  //       "type": extType,
  //       "isSeen": false,
  //       "time": DateTime.now().millisecondsSinceEpoch,
  //       "members": chatMembersList.toSet().toList(),
  //     });
  //     // Update last msg time with group time to show latest messaged group on top on the groups list
  //     await FirebaseProvider.firestore
  //         .collection('groups')
  //         .doc(widget.groupId)
  //         .update({"time": DateTime.now().millisecondsSinceEpoch});

  //     var ref = FirebaseStorage.instance
  //         .ref()
  //         .child('cpscom_admin_images')
  //         .child("$fileName.$extension");
  //     var uploadTask = await ref.putFile(file).catchError((error) async {
  //       await _firestore
  //           .collection('groups')
  //           .doc(widget.groupId)
  //           .collection('chats')
  //           .doc(fileName)
  //           .delete();
  //       status = 0;
  //     });
  //     if (status == 1) {
  //       String imageUrl = await uploadTask.ref.getDownloadURL();
  //       await _firestore
  //           .collection('groups')
  //           .doc(widget.groupId)
  //           .collection('chats')
  //           .doc(fileName)
  //           .update({"message": imageUrl});
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       log(e.toString());
  //     }
  //   }
  // }

  // Future<void> onSendMessages(String groupId, String msg, String profilePicture,
  //     String senderName) async {
  //   if (msg.trim().isNotEmpty) {
  //     msgController.clear();
  //     Map<String, dynamic> chatData = {};
  //     Map<String, dynamic> reply = {};
  //     try {
  //       if (chatController.isReply.value == true) {
  //         reply = {
  //           "replyWhom": replyWhom,
  //           'message': replyText,
  //           'type': 'reply',
  //         };

  //         chatData = {
  //           'sendBy': FirebaseProvider.auth.currentUser!.displayName,
  //           'sendById': FirebaseProvider.auth.currentUser!.uid,
  //           'profile_picture': profilePicture,
  //           'message': msg,
  //           'read': DateTime.now().millisecondsSinceEpoch,
  //           'type': 'text',
  //           'reply': reply,
  //           'time': DateTime.now().millisecondsSinceEpoch,
  //           "isSeen": false,
  //           "members": membersList.toSet().toList(),
  //         };
  //         chatController.isRelayFunction(false);
  //       } else {
  //         chatData = {
  //           'sendBy': FirebaseProvider.auth.currentUser!.displayName,
  //           'sendById': FirebaseProvider.auth.currentUser!.uid,
  //           'profile_picture': profilePicture,
  //           'message': msg,
  //           'read': DateTime.now().millisecondsSinceEpoch,
  //           'type': 'text',
  //           'time': DateTime.now().millisecondsSinceEpoch,
  //           "isSeen": false,
  //           "members": membersList.toSet().toList(),
  //         };
  //         chatController.isRelayFunction(false);
  //       }
  //       await FirebaseProvider.firestore
  //           .collection('groups')
  //           .doc(groupId)
  //           .collection('chats')
  //           .add(chatData)
  //           .then((value) {
  //         sendPushNotification(senderName, msg);
  //       });

  //       // Update last msg time with group time to show latest messaged group on top on the groups list
  //       await FirebaseProvider.firestore
  //           .collection('groups')
  //           .doc(groupId)
  //           .update({"time": DateTime.now().millisecondsSinceEpoch});
  //     } catch (e) {
  //       chatController.isRelayFunction(false);
  //       if (kDebugMode) {
  //         log(e.toString());
  //       }
  //     }
  //   }
  // }

  // Future<void> sendPushNotification(String senderName, String msg) async {
  //   for (var i = 0; i < membersList.length; i++) {
  //     print(membersList.length);
  //     // notification will sent to all the users of the group except current user.
  //     String token = "";

  //     if (membersList[i]['uid'] != _auth.currentUser!.uid) {
  //       // membersList.removeAt(i);
  //       DocumentSnapshot<Map<String, dynamic>> ref = await FirebaseFirestore
  //           .instance
  //           .collection("users")
  //           .doc(membersList[i]['uid'])
  //           .get();
  //       token = ref['pushToken'];
  //       log("test token $token");
  //     }

  //     try {
  //       final body = {
  //         "priority": "high",
  //         "to": token,
  //         "data": <String, dynamic>{"title": senderName, "body": msg},
  //         "notification": <String, dynamic>{"title": senderName, "body": msg}
  //       };
  //       var response = await post(Uri.parse(Urls.sendPushNotificationUrl),
  //           headers: <String, String>{
  //             HttpHeaders.contentTypeHeader: 'application/json',
  //             HttpHeaders.authorizationHeader: AppStrings.serverKey
  //           },
  //           body: jsonEncode(body));

  //       if (kDebugMode) {
  //         log('status code send notification - ${response.statusCode}');
  //         log('body send notification -  ${response.body}');
  //       }
  //     } catch (e) {
  //       if (kDebugMode) {
  //         log(e.toString());
  //       }
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    //updateIsSeenField(widget.groupId, true);
    msgController = TextEditingController();
    chatController.groupModel.value = GroupModel();
    chatController.getAllChatByGroupId(groupId: widget.groupId);
    chatController.getGroupDetailsById(groupId: widget.groupId);
    chatController.groupId.value = widget.groupId;
  }

  //final queue = Queue<int>();
//  Timer? timer;
  // LinkedHashSet<String> orderedSet = LinkedHashSet<String>();
  // void messageQueue(String messageId, List<dynamic> members) async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;

  //   debugPrint("message seen call");

  //   // Create a batch
  //   WriteBatch batch = firestore.batch();
  //   if (members.isEmpty || messageId.isEmpty) return;
  //   timer?.cancel();
  //   orderedSet.add(messageId);
  //   timer = Timer(const Duration(seconds: 1), () async {
  //     // Loop through the document IDs and update each document in the batch
  //     for (String documentId in orderedSet.toList()) {
  //       debugPrint("seen123 $members");
  //       for (var element in members) {
  //         if (element["uid"] == auth.currentUser!.uid) {
  //           element["isSeen"] = true;
  //         }
  //       }
  //       DocumentReference documentReference = _firestore
  //           .collection('groups')
  //           .doc(widget.groupId)
  //           .collection('chats')
  //           .doc(documentId);
  //       // Update the document with the new data
  //       batch.update(documentReference, {"members": members});
  //     }

  //     // Commit the batch
  //     int seen = 0;
  //     batch.commit().then((_) {
  //       for (var element in members) {
  //         if (element["isSeen"] == true) {
  //           seen++;
  //         }
  //       }
  //       WriteBatch batch2 = firestore.batch();
  //       debugPrint("seen value $seen");
  //       if (seen <= members.length) {
  //         debugPrint("seenIs-> $seen \n $members");
  //         for (String documentId in orderedSet.toList()) {
  //           DocumentReference documentReference = _firestore
  //               .collection('groups')
  //               .doc(widget.groupId)
  //               .collection('chats')
  //               .doc(documentId);
  //           // Update the document with the new data
  //           batch2.update(documentReference, {"isSeen": true});
  //         }
  //         batch2.commit().then((value) => 'null');
  //       }
  //     }).catchError((error) {});
  //   });
  // }

  // String groupName = '';

  // Map<String, dynamic> chatMap = {};

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              size: 22,
            ),
          ),
          title: Obx(
            () => chatController.isDetailsLaoding.value == false
                ? Text(chatController.groupModel.value.groupName ?? "")
                : Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: const Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
          actions: [
            PopupMenuButton(
              position: PopupMenuPosition.under,
              icon: ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppSizes.cardCornerRadius * 10),
                child: Obx(() => CachedNetworkImage(
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                      imageUrl:
                          chatController.groupModel.value.groupImage ?? "",
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: const CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                              AssetImage('assets/your_avatar_image.jpg'),
                        ),
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.bg,
                        child: Text(
                          chatController.groupModel.value.groupName != null
                              ? chatController.groupModel.value.groupName!
                                  .substring(0, 1)
                                  .toUpperCase()
                              : "",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    )),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                    value: 1,
                    child: Text(
                      'Group Info',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: AppColors.black),
                    )),
                PopupMenuItem(
                    value: 2,
                    child: Text(
                      'Report Group',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: AppColors.black),
                    )),
              ],
              onSelected: (value) {
                switch (value) {
                  case 1:
                    context.push(GroupInfoScreen(
                        groupId: widget.groupId.toString(),
                        isAdmin: widget.isAdmin));
                    break;
                  case 2:
                    context.push(ReportScreen(
                      chatMap: const {},
                      groupId: widget.groupId.toString(),
                      groupName: "Group Name",
                      message: '',
                      isGroupReport: true,
                    ));
                    break;
                  // case 2:
                  //   context.push(const GroupMediaScreen());
                  //   break;
                  // case 3:
                  //   context.push(const MessageSearchScreen());
                  //   break;
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Expanded(
                      child: Obx(
                    () => chatController.isChatLoading.value
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : chatController.chatList.isNotEmpty
                            ? ListView.builder(
                                itemCount: chatController.chatList.length,
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller: _scrollController,
                                shrinkWrap: true,
                                reverse: true,
                                padding: const EdgeInsets.only(
                                    bottom: AppSizes.kDefaultPadding * 2),
                                itemBuilder: (context, index) {
                                  var item = chatController.chatList.reversed
                                      .toList()[index];
                                  return item.senderId.toString() ==
                                          LocalStorage().getUserId().toString()
                                      ? SenderTile(
                                          fileName: item.fileName ?? "",
                                          message: item.message ?? "",
                                          messageType:
                                              item.messageType.toString(),
                                          sentTime: DateFormat('hh:mm a')
                                              .format(DateTime.parse(
                                                  item.timestamp ?? "")),
                                          groupCreatedBy: "",
                                          read: "value")
                                      : ReceiverTile(
                                          fileName: item.fileName ?? "",
                                          chatController: chatController,
                                          onSwipedMessage: (chatMap) {
                                            //replyToMessage(chatMap);
                                          },
                                          message: item.message ?? "",
                                          messageType: item.messageType ?? "",
                                          sentTime: DateFormat('hh:mm a')
                                              .format(DateTime.parse(
                                                  item.timestamp ?? "")),
                                          sentByName: item.senderName ?? "",
                                          sentByImageUrl: item.message ?? "",
                                          groupCreatedBy: "Pandey",
                                        );
                                  //             chatMap['isDelivered'])
                                  //         :
                                })
                            : const SizedBox.shrink(),
                  )),
                ],
              )),
              SendMessageWidget(
                groupId: widget.groupId,
                msgController: msgController,
                scrollController: _scrollController,
              )
            ],
          ),
        ));
  }
}
