import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:cpscom_admin/Commons/app_images.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:cpscom_admin/Features/Chat/Widget/receiver_tile.dart';
import 'package:cpscom_admin/Features/GroupInfo/Model/image_picker_model.dart';
import 'package:cpscom_admin/Features/GroupInfo/Presentation/group_info_screen.dart';
import 'package:cpscom_admin/Features/ReportScreen/report_screen.dart';
import 'package:cpscom_admin/Utils/app_helper.dart';
import 'package:cpscom_admin/Utils/custom_bottom_modal_sheet.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:cpscom_admin/Widgets/custom_text_field.dart';
import 'package:cpscom_admin/Widgets/responsive.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:focused_menu_custom/focused_menu.dart';
import 'package:focused_menu_custom/modals.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkable/linkable.dart';
import 'package:photo_view/photo_view.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:uuid/uuid.dart';

import '../../../Api/urls.dart';
import '../../../Utils/app_preference.dart';
import '../../../Widgets/notify_message_widget.dart';
import '../../../Widgets/video_player.dart';

class ChatScreen extends StatefulWidget {
  final String groupId;
  bool? isAdmin;

  ChatScreen({Key? key, required this.groupId, this.isAdmin}) : super(key: key);

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
  final AppPreference preference = AppPreference();
  List<dynamic> membersList = []; // add in appbar
  List<dynamic> chatMembersList = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String profilePicture = '';
  List<String> pushToken = [];

  File? imageFile;

  final bool _mention = false;
  final List<String> _suggestions = [];

  dynamic extension;
  dynamic extType;

  ////////////
  List<QueryDocumentSnapshot> chatList = [];
  bool isSender = false;
  String sentTime = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<dynamic> chatMembers = [];
  Map<String, dynamic>? chatMemberData = {};
  List<dynamic> updatedChatMemberList = [];
  int isSeenCount = 0;
  dynamic lastChatMsg;
  dynamic mem;

  late Map<String, dynamic>? replyMessage;

  String chatId = '';

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

    setState(() {
      replyMessage = message;
    });
  }

  void onCancelReply() {
    chatController.isRelayFunction(false);
    setState(() {
      replyMessage = null;
    });
  }

  /// picked for web
  ///
  List<PlatformFile>? _paths;

  void fickforWeb() async {
    debugPrint("file for web is calling");
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['png', 'jpg', 'jpeg', 'heic'],
      ))
          ?.files;
    } on PlatformException catch (e) {
      log('Unsupported operation' + e.toString());
    } catch (e) {
      log(e.toString());
    }
    debugPrint("file path-> ${_paths!.first.path}");
    setState(() {
      if (_paths != null) {
        if (_paths != null) {
          //passing file bytes and file name for API call
          // Get the file path from the PlatformFile
          String filePath = _paths![0].path!;
          // Create a File instance using the file path
          File file = File(filePath);
          String extension = p.extension(file.path);
          print("ee-> $extension");
          print("File--> $file");
          uploadImage(file, extension);
        }
      }
    });
  }

  ////////////
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'mp4', 'png', 'jpg', 'jpeg'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      extension = file.extension;
      debugPrint("file--> $result");
      debugPrint("file extension--> $extension");
      List<File> files =
          result.paths.map((path) => File(path.toString())).toList();
      for (var i in files) {
        uploadImage(i, extension);
      }
    } else {
      // User canceled the picker
    }
  }

  Future pickImageFromGallery() async {
    List<XFile>? imageFileList = [];
    try {
      final images = await ImagePicker().pickMedia();
      // final images = await ImagePicker()
      //     .pickMultiImage(maxHeight: 512, maxWidth: 512, imageQuality: 75);
      if (images != null) {
        setState(() {
          imageFileList.add(images);
        });
        final extension = imageFileList.first.path.split(".").last;
        for (var i in imageFileList) {
          await uploadImage(File(i.path), extension);
        }
      } else {
        // User canceled the picker
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        log('Failed to pick image: $e');
      }
    }
  }
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

  Future pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          maxHeight: 512,
          maxWidth: 512,
          imageQuality: 75);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => imageFile = imageTemp);
      final extension = image.path.split(".").last;
      await uploadImage(imageFile!, extension);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        log('Failed to pick image: $e');
      }
    }
  }

  Future uploadImage(File file, extension) async {
    String fileName = const Uuid().v1();
    // final ext = file.path.split('.').last;
    if (extension == 'pdf') {
      extType = "pdf";
    } else if (extension == 'jpg' ||
        extension == 'JPG' ||
        extension == 'jpeg' ||
        extension == 'JPEG' ||
        extension == 'png' ||
        extension == 'PNG') {
      extType = "img";
    } else if (extension == 'doc' || extension == 'docx') {
      extType = "doc";
    } else if (extension == 'gif') {
      extType = "gif";
    }

    // } else if (extension == 'mp4' ||
    //     extension == 'avi' ||
    //     extension == 'MST' ||
    //     extension == 'M2TS' ||
    //     extension == 'mov' ||
    //     extension == 'TS' ||
    //     extension == 'QT' ||
    //     extension == 'wmv' ||
    //     extension == 'nkv' ||
    //     extension == 'avi' ||
    //     extension == 'm4p' ||
    //     extension == 'm4v' ||
    //     extension == '3gp' ||
    //     extension == 'mxf' ||
    //     extension == 'svi' ||
    //     extension == 'amv')
    else {
      extType = "mp4";
    }
    int status = 1;
    print("imagepath-->  ${file.path}");
    print("pickImagExtension-> $extension");
    try {
      await _firestore
          .collection('groups')
          .doc(widget.groupId)
          .collection('chats')
          .doc(fileName)
          .set({
        "sendBy": _auth.currentUser!.displayName,
        "sendById": _auth.currentUser!.uid,
        "message": "",
        'profile_picture': profilePicture,
        "type": extType,
        "isSeen": false,
        "time": DateTime.now().millisecondsSinceEpoch,
        "members": chatMembersList.toSet().toList(),
      });
      // Update last msg time with group time to show latest messaged group on top on the groups list
      await FirebaseProvider.firestore
          .collection('groups')
          .doc(widget.groupId)
          .update({"time": DateTime.now().millisecondsSinceEpoch});

      var ref = FirebaseStorage.instance
          .ref()
          .child('cpscom_admin_images')
          .child("$fileName.$extension");
      var uploadTask = await ref.putFile(file).catchError((error) async {
        await _firestore
            .collection('groups')
            .doc(widget.groupId)
            .collection('chats')
            .doc(fileName)
            .delete();
        status = 0;
      });
      if (status == 1) {
        String imageUrl = await uploadTask.ref.getDownloadURL();
        await _firestore
            .collection('groups')
            .doc(widget.groupId)
            .collection('chats')
            .doc(fileName)
            .update({"message": imageUrl});
      }
    } catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
    }
  }

  Future<void> onSendMessages(String groupId, String msg, String profilePicture,
      String senderName) async {
    if (msg.trim().isNotEmpty) {
      msgController.clear();
      Map<String, dynamic> chatData = {};
      Map<String, dynamic> reply = {};
      try {
        if (chatController.isReply.value == true) {
          reply = {
            "replyWhom": replyWhom,
            'message': replyText,
            'type': 'reply',
          };

          chatData = {
            'sendBy': FirebaseProvider.auth.currentUser!.displayName,
            'sendById': FirebaseProvider.auth.currentUser!.uid,
            'profile_picture': profilePicture,
            'message': msg,
            'read': DateTime.now().millisecondsSinceEpoch,
            'type': 'text',
            'reply': reply,
            'time': DateTime.now().millisecondsSinceEpoch,
            "isSeen": false,
            "members": membersList.toSet().toList(),
          };
          chatController.isRelayFunction(false);
        } else {
          chatData = {
            'sendBy': FirebaseProvider.auth.currentUser!.displayName,
            'sendById': FirebaseProvider.auth.currentUser!.uid,
            'profile_picture': profilePicture,
            'message': msg,
            'read': DateTime.now().millisecondsSinceEpoch,
            'type': 'text',
            'time': DateTime.now().millisecondsSinceEpoch,
            "isSeen": false,
            "members": membersList.toSet().toList(),
          };
          chatController.isRelayFunction(false);
        }
        await FirebaseProvider.firestore
            .collection('groups')
            .doc(groupId)
            .collection('chats')
            .add(chatData)
            .then((value) {
          sendPushNotification(senderName, msg);
        });

        // Update last msg time with group time to show latest messaged group on top on the groups list
        await FirebaseProvider.firestore
            .collection('groups')
            .doc(groupId)
            .update({"time": DateTime.now().millisecondsSinceEpoch});
      } catch (e) {
        chatController.isRelayFunction(false);
        if (kDebugMode) {
          log(e.toString());
        }
      }
    }
  }

  Future<void> sendPushNotification(String senderName, String msg) async {
    for (var i = 0; i < membersList.length; i++) {
      print(membersList.length);
      // notification will sent to all the users of the group except current user.
      String token = "";

      if (membersList[i]['uid'] != _auth.currentUser!.uid) {
        // membersList.removeAt(i);
        DocumentSnapshot<Map<String, dynamic>> ref = await FirebaseFirestore
            .instance
            .collection("users")
            .doc(membersList[i]['uid'])
            .get();
        token = ref['pushToken'];
        log("test token $token");
      }

      try {
        final body = {
          "priority": "high",
          "to": token,
          "data": <String, dynamic>{"title": senderName, "body": msg},
          "notification": <String, dynamic>{"title": senderName, "body": msg}
        };
        var response = await post(Uri.parse(Urls.sendPushNotificationUrl),
            headers: <String, String>{
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: AppStrings.serverKey
            },
            body: jsonEncode(body));

        if (kDebugMode) {
          log('status code send notification - ${response.statusCode}');
          log('body send notification -  ${response.body}');
        }
      } catch (e) {
        if (kDebugMode) {
          log(e.toString());
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    //updateIsSeenField(widget.groupId, true);
    msgController = TextEditingController();
  }

  final queue = Queue<int>();
  Timer? timer;
  LinkedHashSet<String> orderedSet = LinkedHashSet<String>();
  void messageQueue(String messageId, List<dynamic> members) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    debugPrint("message seen call");

    // Create a batch
    WriteBatch batch = firestore.batch();
    if (members.isEmpty || messageId.isEmpty) return;
    timer?.cancel();
    orderedSet.add(messageId);
    timer = Timer(const Duration(seconds: 1), () async {
      // Loop through the document IDs and update each document in the batch
      for (String documentId in orderedSet.toList()) {
        debugPrint("seen123 $members");
        for (var element in members) {
          if (element["uid"] == auth.currentUser!.uid) {
            element["isSeen"] = true;
          }
        }
        DocumentReference documentReference = _firestore
            .collection('groups')
            .doc(widget.groupId)
            .collection('chats')
            .doc(documentId);
        // Update the document with the new data
        batch.update(documentReference, {"members": members});
      }

      // Commit the batch
      int seen = 0;
      batch.commit().then((_) {
        for (var element in members) {
          if (element["isSeen"] == true) {
            seen++;
          }
        }
        WriteBatch batch2 = firestore.batch();
        debugPrint("seen value $seen");
        if (seen <= members.length) {
          debugPrint("seenIs-> $seen \n $members");
          for (String documentId in orderedSet.toList()) {
            DocumentReference documentReference = _firestore
                .collection('groups')
                .doc(widget.groupId)
                .collection('chats')
                .doc(documentId);
            // Update the document with the new data
            batch2.update(documentReference, {"isSeen": true});
          }
          batch2.commit().then((value) => 'null');
        }
      }).catchError((error) {});
    });
  }

  String groupName = '';

  Map<String, dynamic> chatMap = {};

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
          title: StreamBuilder(
              stream: FirebaseProvider.getGroupDetails(widget.groupId),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  membersList.clear();
                  membersList.addAll(snapshot.data?['members']);
                  return Responsive.isDesktop(context)
                      ? Text("")
                      : Text('${snapshot.data!['name']}');
                } else {
                  return const SizedBox();
                }
              }),
          actions: [
            PopupMenuButton(
                icon: StreamBuilder(
                    stream: FirebaseProvider.getGroupDetails(widget.groupId),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(
                            AppSizes.cardCornerRadius * 10),
                        child: CachedNetworkImage(
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                            imageUrl: '${snapshot.data?['profile_picture']}',
                            placeholder: (context, url) => const CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AppColors.bg,
                                ),
                            errorWidget: (context, url, error) => CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AppColors.bg,
                                  child: Text(
                                    snapshot.data!['name']
                                        .substring(0, 1)
                                        .toString()
                                        .toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                )),
                      );
                    }),
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
                      // PopupMenuItem(
                      //     value: 2,
                      //     child: Text(
                      //       'Group Media',
                      //       style: Theme.of(context)
                      //           .textTheme
                      //           .bodyText2!
                      //           .copyWith(color: AppColors.black),
                      //     )),
                      // PopupMenuItem(
                      //     value: 3,
                      //     child: Text(
                      //       'Search',
                      //       style: Theme.of(context)
                      //           .textTheme
                      //           .bodyText2!
                      //           .copyWith(color: AppColors.black),
                      //     )),
                    ],
                onSelected: (value) {
                  switch (value) {
                    case 1:
                      if (Responsive.isDesktop(context)) {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(content: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                return SizedBox(
                                  width: 600,
                                  child: GroupInfoScreen(
                                      groupId: widget.groupId,
                                      isAdmin: widget.isAdmin),
                                );
                              }));
                            });
                      } else {
                        context.push(GroupInfoScreen(
                            groupId: widget.groupId, isAdmin: widget.isAdmin));
                      }

                      break;
                    case 2:
                      if (Responsive.isDesktop(context)) {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(content: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                return SizedBox(
                                  width: 600,
                                  child: ReportScreen(
                                    chatMap: chatMap,
                                    groupId: widget.groupId,
                                    groupName: groupName,
                                    message: '',
                                    isGroupReport: true,
                                  ),
                                );
                              }));
                            });
                      } else {
                        context.push(ReportScreen(
                          chatMap: chatMap,
                          groupId: widget.groupId,
                          groupName: groupName,
                          message: '',
                          isGroupReport: true,
                        ));
                      }
                  }
                }),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseProvider.getChatsMessages(widget.groupId),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        chatList = snapshot.data!.docs;
                        // lastChatMsg =
                        //     chatList[0].data() as Map<String, dynamic>;
                        // log("lastmsg---> ${lastChatMsg['i']['isSeen']}");
                        if (chatList.length > 1) {
                          // chatMembersList = lastChatMsg['members'];
                        }
                        // for (var i = 0; i < chatList.length; i++) {
                        //   chatMap = chatList[i].data() as Map<String, dynamic>;
                        //   if (chatMap['type'] == 'text' ||
                        //       chatMap['type'] == 'img' ||
                        //       chatMap['type'] == 'pdf' ||
                        //       chatMap['type'] == 'doc' ||
                        //       chatMap['type'] == 'docx' ||
                        //       chatMap['type'] == 'mp4') {
                        //     lastChatMsg =
                        //         chatList[0].data() as Map<String, dynamic>;
                        //     mem = lastChatMsg['members'];
                        //     chatMembers = chatMap['members'];
                        //     if (mem != null) {
                        //       updatedChatMemberList = mem;
                        //     }
                        //     log('mem ------------ ${mem}');
                        //     log('chat members ------------ ${chatMembers}');
                        //   }
                        // }
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  itemCount: chatList.length,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  controller: _scrollController,
                                  shrinkWrap: true,
                                  reverse: true,
                                  padding: const EdgeInsets.only(
                                      bottom: AppSizes.kDefaultPadding * 2),
                                  itemBuilder: (context, index) {
                                    debugPrint(
                                        "type-data-->${chatList[index]['type']}");
                                    if (chatList[index]['type'] == 'notify') {
                                      return NotifieMessageWidget(
                                        messageBy: FirebaseProvider
                                                    .auth.currentUser!.uid ==
                                                chatList[index]['sendById']
                                            ? 'You'
                                            : chatList[index]['sendBy'],
                                        message: chatList[index]['message'],
                                      );
                                    }
                                    // if (chatList[index]["isSeen"] == false) {
                                    //   messageQueue(
                                    //     chatList[index].id,
                                    //     membersList,
                                    //   );
                                    // }
                                    var chatMap = chatList[index].data()
                                        as Map<String, dynamic>;
                                    replyMessage = chatList[index].data()
                                        as Map<String, dynamic>;
                                    chatId = chatList[index].id;
                                    isSender = chatMap['sendBy'] ==
                                            auth.currentUser!.displayName
                                        ? true
                                        : false;
                                    sentTime =
                                        AppHelper.getStringTimeFromTimestamp(
                                            chatMap['time']);
                                    var groupCreatedBy = FirebaseProvider
                                                .auth.currentUser!.uid ==
                                            chatMap['sendById']
                                        ? 'You'
                                        : chatMap['sendBy'];
                                    return isSender
                                        ?
                                        // chatMap['type'] != 'notify' &&
                                        //                 chatMap['type'] != 'pdf' ||
                                        //             (chatMap['reply'] != null &&
                                        //                 chatMap['reply']['type'] !=
                                        //                     'reply')
                                        //         ? _senderTile(
                                        //             chatMap['message'],
                                        //             chatMap['type'],
                                        //             sentTime,
                                        //             groupCreatedBy,
                                        //             sentTime,
                                        //             // () {},
                                        //             chatMap['isSeen'],
                                        //             chatMap['isDelivered'])
                                        //         :
                                        chatMap['type'] == 'text' &&
                                                chatMap['type'] != 'notify' &&
                                                (chatMap['reply'] != null &&
                                                    chatMap['reply']['type'] ==
                                                        'reply')
                                            ? SwipeTo(
                                                onRightSwipe: () {
                                                  onSwipedMessage(
                                                      chatList[index].data()
                                                          as Map<String,
                                                              dynamic>);
                                                },
                                                child: _replySenderTile(
                                                    chatMap['message'],
                                                    chatMap['type'],
                                                    sentTime,
                                                    groupCreatedBy,
                                                    sentTime,
                                                    chatMap['reply']
                                                        ['replyWhom'],
                                                    chatMap['reply']['message'],
                                                    // () {},
                                                    chatMap['isSeen'],
                                                    true),
                                              )
                                            : SwipeTo(
                                                onRightSwipe: () {
                                                  onSwipedMessage(
                                                      chatList[index].data()
                                                          as Map<String,
                                                              dynamic>);
                                                },
                                                child: _senderTile(
                                                    chatMap['message'],
                                                    chatMap['type'],
                                                    sentTime,
                                                    groupCreatedBy,
                                                    sentTime,
                                                    // () {},
                                                    chatMap['isSeen'],
                                                    true),
                                              )
                                        : chatMap['type'] != 'notify' &&
                                                chatMap['type'] != 'mp4' &&
                                                chatMap['type'] == 'text' &&
                                                (chatMap['reply'] != null &&
                                                    chatMap['reply']['type'] ==
                                                        'reply')
                                            ? SwipeTo(
                                                onRightSwipe: () {
                                                  onSwipedMessage(
                                                      chatList[index].data()
                                                          as Map<String,
                                                              dynamic>);
                                                },
                                                child: FocusedMenuHolder(
                                                  openWithTap: true,
                                                  menuItems: [
                                                    FocusedMenuItem(
                                                      title:
                                                          const Text('Report'),
                                                      trailingIcon: const Icon(Icons
                                                          .report_problem_rounded),
                                                      onPressed: () {
                                                        var map =
                                                            chatList[index]
                                                                    .data()
                                                                as Map<String,
                                                                    dynamic>;
                                                        context
                                                            .push(ReportScreen(
                                                          chatMap:
                                                              chatList[index]
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>,
                                                          groupId:
                                                              widget.groupId,
                                                          groupName: groupName,
                                                          message:
                                                              map['message'],
                                                          isGroupReport: false,
                                                        ));
                                                      },
                                                    ),
                                                  ],
                                                  onPressed: () {},
                                                  child: _replyReceiverTile(
                                                      chatMap['message'],
                                                      chatMap['type'],
                                                      sentTime,
                                                      chatMap['sendBy'],
                                                      chatMap[
                                                          'profile_picture'],
                                                      groupCreatedBy,
                                                      chatMap['reply']
                                                          ['replyWhom'],
                                                      chatMap['reply']
                                                          ['message'],
                                                      (message) {
                                                    replyToMessage(
                                                        chatList[index].data()
                                                            as Map<String,
                                                                dynamic>);
                                                  }),
                                                ),
                                              )
                                            : chatMap['type'] != 'notify'
                                                ? SwipeTo(
                                                    onRightSwipe: () {
                                                      onSwipedMessage(
                                                          chatList[index].data()
                                                              as Map<String,
                                                                  dynamic>);
                                                    },
                                                    child: FocusedMenuHolder(
                                                      openWithTap: true,
                                                      menuItems: [
                                                        FocusedMenuItem(
                                                          title: const Text(
                                                              'Report'),
                                                          trailingIcon:
                                                              const Icon(Icons
                                                                  .report_problem_rounded),
                                                          onPressed: () {
                                                            var map = chatList[
                                                                        index]
                                                                    .data()
                                                                as Map<String,
                                                                    dynamic>;
                                                            context.push(
                                                                ReportScreen(
                                                              chatMap: chatList[
                                                                          index]
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>,
                                                              groupId: widget
                                                                  .groupId,
                                                              groupName:
                                                                  groupName,
                                                              message: map[
                                                                  'message'],
                                                              isGroupReport:
                                                                  false,
                                                            ));
                                                          },
                                                        ),
                                                      ],
                                                      onPressed: () {},
                                                      child: ReceiverTile(
                                                        chatController:
                                                            chatController,
                                                        onSwipedMessage:
                                                            (chatMap) {
                                                          replyToMessage(
                                                              chatMap);
                                                        },
                                                        message:
                                                            chatMap['message'],
                                                        messageType:
                                                            chatMap['type'],
                                                        sentTime: sentTime,
                                                        sentByName:
                                                            chatMap['sendBy'],
                                                        sentByImageUrl: chatMap[
                                                            'profile_picture'],
                                                        groupCreatedBy:
                                                            groupCreatedBy,
                                                      ),
                                                    ),
                                                  )
                                                : ReceiverTile(
                                                    chatController:
                                                        chatController,
                                                    onSwipedMessage: (chatMap) {
                                                      replyToMessage(chatMap);
                                                    },
                                                    message: chatMap['message'],
                                                    messageType:
                                                        chatMap['type'],
                                                    sentTime: sentTime,
                                                    sentByName:
                                                        chatMap['sendBy'],
                                                    sentByImageUrl: chatMap[
                                                        'profile_picture'],
                                                    groupCreatedBy:
                                                        groupCreatedBy,
                                                  );
                                  }),
                            ),
                          ],
                        );
                      }
                      return const SizedBox();

                      // return const SizedBox();
                    }),
              ),
              Obx(() => chatController.isMemberSuggestion.value
                  ? Container(
                      margin: const EdgeInsets.only(left: 5, right: 40),
                      decoration: const BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.only(
                              topRight:
                                  Radius.circular(AppSizes.cardCornerRadius),
                              bottomRight:
                                  Radius.circular(AppSizes.cardCornerRadius))),
                      padding: const EdgeInsets.only(left: 20),
                      height: 250,
                      child: ListView.builder(
                          itemCount: membersList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            // debugPrint("Memebrlist-> $membersList");
                            // return Text("index $index");
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  msgController.text = msgController.text +
                                      membersList[index]['name'];
                                  msgController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: msgController.text.length));
                                });
                                chatController.isMemberSuggestion(false);
                              },
                              contentPadding: EdgeInsets.zero,
                              title: Text(membersList[index]['name']),
                            );
                          }),
                    )
                  : const SizedBox()),
              Stack(
                children: [
                  const CustomDivider(),
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.kDefaultPadding),
                            decoration: BoxDecoration(
                              color: AppColors.shimmer,
                              borderRadius: BorderRadius.circular(
                                  AppSizes.cardCornerRadius),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Obx(() => Column(
                                        children: [
                                          chatController.isReply.value == true
                                              ? Container(
                                                  height: 56,
                                                  constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                  ),
                                                  decoration: const BoxDecoration(
                                                      color: AppColors.bg,
                                                      borderRadius: BorderRadius.only(
                                                          topRight: Radius
                                                              .circular(AppSizes
                                                                  .cardCornerRadius),
                                                          bottomRight: Radius
                                                              .circular(AppSizes
                                                                  .cardCornerRadius))),
                                                  child: Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: AppSizes
                                                                .kDefaultPadding /
                                                            4,
                                                      ),
                                                      Container(
                                                        height: 54,
                                                        width: 2,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                      const SizedBox(
                                                        width: AppSizes
                                                                .kDefaultPadding /
                                                            2,
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Flexible(
                                                                flex: 1,
                                                                child: Text(
                                                                  replyWhom,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                          color: AppColors
                                                                              .primary,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: AppSizes
                                                                        .kDefaultPadding /
                                                                    8,
                                                              ),
                                                              Flexible(
                                                                flex: 1,
                                                                child: Text(
                                                                  replyText,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                          color:
                                                                              AppColors.darkGrey),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                          onPressed: () {
                                                            chatController
                                                                .isRelayFunction(
                                                                    false);
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                          },
                                                          icon: const Icon(
                                                            Icons.close,
                                                            size: 24,
                                                            color: AppColors
                                                                .darkGrey,
                                                          ))
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox(),
                                          chatController.isReply.value == true
                                              ? const CustomDivider()
                                              : const SizedBox(),
                                          CustomTextField(
                                            controller: msgController,
                                            hintText: 'Type a message',
                                            maxLines: 4,
                                            isReplying:
                                                chatController.isReply.value,
                                            focusNode: focusNode,
                                            keyboardType:
                                                TextInputType.multiline,
                                            minLines: 1,
                                            onChanged: (value) {
                                              chatController
                                                  .mentionMember(value!);
                                              return null;
                                            },
                                            isBorder: false,
                                            onCancelReply: onCancelReply,
                                            replyMessage: const {},
                                          ),
                                        ],
                                      )),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (kIsWeb) {
                                      print("pandey");
                                      // fickforWeb();
                                      pickFile();
                                    } else {
                                      showCustomBottomSheet(
                                          context,
                                          '',
                                          SizedBox(
                                            height: 150,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                padding: const EdgeInsets.all(
                                                    AppSizes.kDefaultPadding),
                                                itemCount:
                                                    chatPickerList.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      switch (index) {
                                                        case 0:
                                                          pickFile();
                                                          break;
                                                        case 1:
                                                          pickImageFromGallery();
                                                          break;
                                                        case 2:
                                                          pickImageFromCamera();
                                                          break;
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .only(
                                                          left: AppSizes
                                                                  .kDefaultPadding *
                                                              2),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            width: 60,
                                                            height: 60,
                                                            padding:
                                                                const EdgeInsets
                                                                        .all(
                                                                    AppSizes
                                                                        .kDefaultPadding),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: AppColors
                                                                        .lightGrey),
                                                                color: AppColors
                                                                    .white,
                                                                shape: BoxShape
                                                                    .circle),
                                                            child:
                                                                chatPickerList[
                                                                        index]
                                                                    .icon,
                                                          ),
                                                          const SizedBox(
                                                            height: AppSizes
                                                                    .kDefaultPadding /
                                                                2,
                                                          ),
                                                          Text(
                                                            '${chatPickerList[index].title}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ));
                                    }
                                  },
                                  child: const Icon(
                                    EvaIcons.attach,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: AppSizes.kDefaultPadding,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await onSendMessages(
                              widget.groupId,
                              msgController.text,
                              profilePicture,
                              '${_auth.currentUser!.displayName}',
                            );
                            msgController.clear();

                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              _scrollController.animateTo(0.0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut);
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            padding: const EdgeInsets.all(
                                AppSizes.kDefaultPadding / 2),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppColors.buttonGradientColor),
                            child: const Image(
                              image: AssetImage(AppImages.sendIcon),
                              width: 20,
                              height: 20,
                              color: AppColors.white,
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _replyReceiverTile(
      String message,
      String messageType,
      String sentTime,
      String sentByName,
      String sentByImageUrl,
      String groupCreatedBy,
      String replyWhom,
      String replyText,
      ValueChanged<Map<String, dynamic>> onSwipedMessage) {
    return messageType == 'notify'
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: AppSizes.kDefaultPadding),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.kDefaultPadding,
                    vertical: AppSizes.kDefaultPadding / 2),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: AppColors.lightGrey),
                    borderRadius:
                        BorderRadius.circular(AppSizes.cardCornerRadius / 2),
                    color: AppColors.shimmer),
                child: Text(
                  '$groupCreatedBy $message',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          )
        : Padding(
            padding: const EdgeInsets.only(
                left: AppSizes.kDefaultPadding / 4,
                top: AppSizes.kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppSizes.kDefaultPadding * 4 - 2),
                  child: Row(
                    children: [
                      Text(
                        sentByName,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        ', $sentTime',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppSizes.cardCornerRadius * 3),
                      child: CachedNetworkImage(
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                          imageUrl: sentByImageUrl,
                          placeholder: (context, url) => const CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.bg,
                              ),
                          errorWidget: (context, url, error) => CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.bg,
                                child: Text(
                                  sentByName
                                      .substring(0, 1)
                                      .toString()
                                      .toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                              )),
                    ),
                    const SizedBox(
                      width: AppSizes.kDefaultPadding / 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppSizes.kDefaultPadding * 2,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 52,
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.45,
                            ),
                            decoration: const BoxDecoration(
                                color: AppColors.bg,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(
                                        AppSizes.cardCornerRadius),
                                    bottomRight: Radius.circular(
                                        AppSizes.cardCornerRadius))),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: AppSizes.kDefaultPadding / 4,
                                ),
                                Container(
                                  height: 52,
                                  width: 2,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(
                                  width: AppSizes.kDefaultPadding / 2,
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            replyWhom,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: AppColors.primary,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: AppSizes.kDefaultPadding / 6,
                                        ),
                                        FittedBox(
                                          child: Text(
                                            replyText,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: AppColors.darkGrey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ChatBubble(
                            padding: messageType == 'img' ||
                                    messageType == 'pdf' ||
                                    messageType == 'docx' ||
                                    messageType == 'doc' ||
                                    messageType == "mp4"
                                ? EdgeInsets.zero
                                : null,
                            clipper: ChatBubbleClipper3(
                                type: BubbleType.receiverBubble),
                            backGroundColor: AppColors.lightGrey,
                            alignment: Alignment.topLeft,
                            elevation: 0,
                            margin: const EdgeInsets.only(
                                top: AppSizes.kDefaultPadding / 4),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.65),
                              child: messageType == 'img'
                                  ? GestureDetector(
                                      onTap: () {
                                        context
                                            .push(ShowImage(imageUrl: message));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            AppSizes.cardCornerRadius),
                                        child: CachedNetworkImage(
                                            imageUrl: message,
                                            fit: BoxFit.contain,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator
                                                    .adaptive(),
                                            errorWidget: (context, url,
                                                    error) =>
                                                const Icon(Icons.video_call)),
                                      ),
                                    )
                                  : messageType == 'text'
                                      ? Linkable(
                                          text: message,
                                          linkColor: Colors.blue,
                                        )
                                      : messageType == 'pdf'
                                          ? message != null
                                              ? Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(AppSizes
                                                              .cardCornerRadius),
                                                      child: Container(
                                                        constraints: BoxConstraints(
                                                            maxWidth: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.45,
                                                            maxHeight:
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.30),
                                                        child: const PDF()
                                                            .cachedFromUrl(
                                                          message,
                                                          maxAgeCacheObject:
                                                              const Duration(
                                                                  days: 30),
                                                          //duration of cache
                                                          placeholder:
                                                              (progress) => Center(
                                                                  child: Text(
                                                                      '$progress %')),
                                                          errorWidget: (error) =>
                                                              const Center(
                                                                  child: Text(
                                                                      'Loading...')),
                                                        ),
                                                      ),
                                                    ),
                                                    message != null
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              context
                                                                  .push(ShowPdf(
                                                                pdfPath:
                                                                    message,
                                                              ));
                                                            },
                                                            child: Container(
                                                              color: AppColors
                                                                  .transparent,
                                                              constraints: BoxConstraints(
                                                                  maxWidth: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.45,
                                                                  maxHeight: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.30),
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                )
                                              : const SizedBox()
                                          : const SizedBox(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  Widget _senderTile(
      String message,
      String messageType,
      String sentTime,
      String groupCreatedBy,
      String read,
      //VoidCallback? onTap,
      bool? isSeen,
      bool? isDelivered) {
    return messageType == 'notify'
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: AppSizes.kDefaultPadding / 2,
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.kDefaultPadding,
                    vertical: AppSizes.kDefaultPadding / 1.5),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: AppColors.lightGrey),
                    borderRadius:
                        BorderRadius.circular(AppSizes.cardCornerRadius / 2),
                    color: AppColors.shimmer),
                child: Text(
                  '$groupCreatedBy $message'.trim(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          )
        : GestureDetector(
            //onHorizontalDragEnd: (DragEndDetails) => onTap,
            child: Padding(
              padding: const EdgeInsets.only(
                  right: AppSizes.kDefaultPadding,
                  top: AppSizes.kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          sentTime,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 12),
                        ),
                        const SizedBox(
                          width: AppSizes.kDefaultPadding / 2,
                        ),
                        // isDelivered == true
                        //     ?
                        Icon(
                          Icons.done_all_rounded,
                          size: 16,
                          color: isSeen == true
                              ? AppColors.primary
                              : AppColors.grey,
                        )
                        // : const Icon(
                        //     Icons.check,
                        //     size: 16,
                        //     color: AppColors.grey,
                        //   )
                      ],
                    ),
                  ),
                  ChatBubble(
                    clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
                    backGroundColor: AppColors.secondary.withOpacity(0.3),
                    alignment: Alignment.topRight,
                    elevation: 0,
                    margin: const EdgeInsets.only(
                        top: AppSizes.kDefaultPadding / 4),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.65),
                      child: messageType == 'img'
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            ShowImage(imageUrl: message)));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    AppSizes.cardCornerRadius),
                                child: CachedNetworkImage(
                                  imageUrl: message,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator
                                          .adaptive(),
                                  errorWidget: (context, url, error) =>
                                      const CircularProgressIndicator
                                          .adaptive(),
                                ),
                              ),
                            )
                          : messageType == 'text'
                              ? Linkable(
                                  text: message.trim(),
                                  linkColor: Colors.blue,
                                )
                              : messageType == 'pdf'
                                  ? Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              AppSizes.cardCornerRadius),
                                          child: Container(
                                              constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.45,
                                                  maxHeight:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.30),
                                              child: const PDF().cachedFromUrl(
                                                message,
                                                maxAgeCacheObject:
                                                    const Duration(days: 30),
                                                //duration of cache
                                                placeholder: (progress) =>
                                                    Center(
                                                        child: Text(
                                                            '$progress %')),
                                                errorWidget: (error) =>
                                                    const Center(
                                                        child:
                                                            Text('Loading...')),
                                              )),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            context.push(ShowPdf(
                                              pdfPath: message,
                                            ));
                                          },
                                          child: Container(
                                            color: AppColors.transparent,
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.45,
                                                maxHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.30),
                                          ),
                                        ),
                                      ],
                                    )
                                  : messageType == "mp4"
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      VideoMessage(
                                                    videoUrl: message,
                                                  ),
                                                ));
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.35,
                                                maxHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.20),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(AppSizes
                                                      .cardCornerRadius),
                                              child: CachedNetworkImage(
                                                imageUrl: message.isNotEmpty
                                                    ? message
                                                    : '',
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator
                                                        .adaptive(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(
                                                            Icons.play_arrow),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _replySenderTile(
      String message,
      String messageType,
      String sentTime,
      String groupCreatedBy,
      String read,
      String replyWhom,
      String replyText,
      //VoidCallback? onTap,
      bool? isSeen,
      bool? isDelivered) {
    return messageType == 'notify'
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: AppSizes.kDefaultPadding / 2,
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.kDefaultPadding,
                    vertical: AppSizes.kDefaultPadding / 1.5),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: AppColors.lightGrey),
                    borderRadius:
                        BorderRadius.circular(AppSizes.cardCornerRadius / 2),
                    color: AppColors.shimmer),
                child: Text(
                  '$groupCreatedBy $message'.trim(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          )
        : GestureDetector(
            //onHorizontalDragEnd: (DragEndDetails) => onTap,
            child: Padding(
              padding: const EdgeInsets.only(
                  right: AppSizes.kDefaultPadding,
                  top: AppSizes.kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          sentTime,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 12),
                        ),
                        const SizedBox(
                          width: AppSizes.kDefaultPadding / 2,
                        ),
                        isDelivered == true
                            ? Icon(
                                Icons.done_all_rounded,
                                size: 16,
                                color: isSeen == true
                                    ? AppColors.primary
                                    : AppColors.grey,
                              )
                            : const Icon(
                                Icons.check,
                                size: 16,
                                color: AppColors.grey,
                              )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 50,
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.45,
                        ),
                        decoration: const BoxDecoration(
                            color: AppColors.bg,
                            borderRadius: BorderRadius.only(
                                topRight:
                                    Radius.circular(AppSizes.cardCornerRadius),
                                bottomRight: Radius.circular(
                                    AppSizes.cardCornerRadius))),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: AppSizes.kDefaultPadding / 6,
                            ),
                            Container(
                              height: 50,
                              width: 2,
                              color: AppColors.primary,
                            ),
                            const SizedBox(
                              width: AppSizes.kDefaultPadding / 2,
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Text(
                                        replyWhom,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: AppSizes.kDefaultPadding / 6,
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Text(
                                        replyText,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: AppColors.darkGrey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ChatBubble(
                        clipper:
                            ChatBubbleClipper3(type: BubbleType.sendBubble),
                        backGroundColor: AppColors.secondary.withOpacity(0.3),
                        alignment: Alignment.topRight,
                        elevation: 0,
                        margin: const EdgeInsets.only(
                            top: AppSizes.kDefaultPadding / 4),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.65),
                          child: messageType == 'img'
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                ShowImage(imageUrl: message)));
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.cardCornerRadius),
                                    child: CachedNetworkImage(
                                      imageUrl: message,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator
                                              .adaptive(),
                                      errorWidget: (context, url, error) =>
                                          const CircularProgressIndicator
                                              .adaptive(),
                                    ),
                                  ),
                                )
                              : messageType == 'text'
                                  ? Linkable(
                                      text: message.trim(),
                                      linkColor: AppColors.primary,
                                    )
                                  : messageType == 'pdf'
                                      ? Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(AppSizes
                                                      .cardCornerRadius),
                                              child: Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                      maxHeight:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.30),
                                                  child:
                                                      const PDF().cachedFromUrl(
                                                    message,
                                                    maxAgeCacheObject:
                                                        const Duration(
                                                            days: 30),
                                                    //duration of cache
                                                    placeholder: (progress) =>
                                                        Center(
                                                            child: Text(
                                                                '$progress %')),
                                                    errorWidget: (error) =>
                                                        const Center(
                                                            child: Text(
                                                                'Loading...')),
                                                  )
                                                  // SfPdfViewer.network(
                                                  //   message,
                                                  //   canShowPaginationDialog: false,
                                                  //   enableHyperlinkNavigation: false,
                                                  //   canShowScrollHead: false,
                                                  //   enableDoubleTapZooming: false,
                                                  //   canShowScrollStatus: false,
                                                  //   pageLayoutMode:
                                                  //       PdfPageLayoutMode.single,
                                                  //   canShowPasswordDialog: false,
                                                  // ),
                                                  ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                context.push(ShowPdf(
                                                  pdfPath: message,
                                                ));
                                              },
                                              child: Container(
                                                color: AppColors.transparent,
                                                constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.45,
                                                    maxHeight:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.30),
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '',
      ),
      body: PhotoView(imageProvider: NetworkImage(imageUrl)),
    );
  }
}

class ShowPdf extends StatelessWidget {
  final String pdfPath;

  const ShowPdf({
    required this.pdfPath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: '',
        ),
        body: const PDF().cachedFromUrl(
          pdfPath,
          maxAgeCacheObject: const Duration(days: 30),
          //duration of cache
          placeholder: (progress) => Center(child: Text('$progress %')),
          errorWidget: (error) => const Center(child: Text('Loading...')),
        ));
  }
}
