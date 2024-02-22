import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:cpscom_admin/Features/Chat/Controller/report_controller.dart';
import 'package:cpscom_admin/Features/Chat/Widget/receiver_tile.dart';
import 'package:cpscom_admin/Features/Chat/Widget/sender_tile.dart';
import 'package:cpscom_admin/Features/GroupInfo/Presentation/group_info_screen.dart';
import 'package:cpscom_admin/Features/Home/Controller/group_list_controller.dart';
import 'package:cpscom_admin/Features/Home/Model/group_list_model.dart';
import 'package:cpscom_admin/Utils/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../Home/Controller/socket_controller.dart';
import '../Widget/send_message_widget.dart';
import '../Widget/show_member_widget.dart';

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
  final groupListController = Get.put(GroupListController());
  final socketController = Get.put(SocketController());
  final reportController = Get.put(ReportController());
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // var ownId = LocalStorage().getUserId();
    chatController.msgController.value.clear();
    chatController.isMemberSuggestion.value = false;
    chatController.getAllChatByGroupId(groupId: widget.groupId).then((value) {
      List<String> reciverId =
          widget.groupModel.currentUsers!.map((user) => user.sId!).toList();
      socketController.socket?.emit("read", {
        "groupId": widget.groupId,
        "userId": LocalStorage().getUserId().toString(),
        "timestamp": chatController.timeStamps.value,
        "receiverId": reciverId
      });
    });
    chatController.groupModel.value = GroupModel();
    chatController.getGroupDetailsById(
        groupId: widget.groupId, timeStamp: chatController.timeStamps.value);
    chatController.groupId.value = widget.groupId;
    super.initState();
    //updateIsSeenField(widget.groupId, true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigator.pop(context);
        // chatController.groupId.value = "";
        // await groupListController.getGroupList(isLoadingShow: false);
        // // Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            leading: InkWell(
              onTap: () async {
                chatController.groupId.value = "";
                Navigator.pop(context);
                // await groupListController.getGroupList(isLoadingShow: false);

                // <-- The target method
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
                      _showReportDialog(
                          isLoading: reportController.isGroupReportLoading,
                          title: "Report Group",
                          context: context,
                          textEditingController:
                              reportController.groupReportController.value,
                          onTap: () async {
                            await reportController.groupReport(
                                groupId: widget.groupId, context: context);
                          });
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
          body: Column(
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
                                    // left: 5,
                                    bottom: AppSizes.kDefaultPadding * 2),
                                itemBuilder: (context, index) {
                                  var item = chatController.chatList.reversed
                                      .toList()[index];

                                  return item.senderId.toString() ==
                                          LocalStorage().getUserId().toString()
                                      ? InkWell(
                                          onTap: () {
                                            chatController.selectedIndex.value =
                                                index;
                                            print(
                                                "consdition ${item.deliveredTo!.length}");
                                          },
                                          child: SenderTile(
                                            isDelivered:
                                                item.allRecipients!.length ==
                                                        item.deliveredTo!.length
                                                    ? true.obs
                                                    : false.obs,
                                            isSeen:
                                                item.allRecipients!.length ==
                                                        item.readBy!.length
                                                    ? true.obs
                                                    : false.obs,
                                            index: index,
                                            fileName: item.fileName ?? "",
                                            message: item.message ?? "",
                                            messageType:
                                                item.messageType.toString(),
                                            sentTime: DateFormat('hh:mm a')
                                                .format(DateTime.parse(
                                                        item.timestamp ?? "")
                                                    .toLocal()),
                                            groupCreatedBy: "",
                                            read: "value",
                                            onLeftSwipe: () {
                                              chatController.isRelayFunction(
                                                  isRep: true,
                                                  msgId: item.sId,
                                                  msgType: item.messageType,
                                                  msg: item.message,
                                                  senderName: item.senderName);
                                              log(chatController.replyOf
                                                  .toString());
                                            },
                                            replyOf: item.replyOf,
                                            // child: item.allRecipients!
                                            //                 .length ==
                                            //             item.deliveredTo!
                                            //                 .length &&
                                            //         item.readBy!.length <
                                            //             item.allRecipients!
                                            //                 .length
                                            //     ? Icon(
                                            //         Icons.done_all_rounded,
                                            //         size: 16,
                                            //         color: item.allRecipients!
                                            //                         .length ==
                                            //                     item.deliveredTo!
                                            //                         .length &&
                                            //                 item.allRecipients!
                                            //                         .length ==
                                            //                     item.readBy!
                                            //                         .length
                                            //             ? AppColors.primary
                                            //             : AppColors.grey,
                                            //       )
                                            //     : const Icon(
                                            //         Icons.check,
                                            //         size: 16,
                                            //         color: AppColors.grey,
                                            //       )),
                                          ))
                                      : InkWell(
                                          onLongPress: () {
                                            _showPopupMenu(
                                                context, item.sId.toString());
                                          },
                                          onTap: () {
                                            chatController.selectedIndex.value =
                                                index;
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 15),
                                            child: ReceiverTile(
                                              index: index,
                                              replyOf: item.replyOf,
                                              fileName: item.fileName ?? "",
                                              chatController: chatController,
                                              onSwipedMessage: () {
                                                chatController.isRelayFunction(
                                                    isRep: true,
                                                    msgId: item.id,
                                                    msgType: item.messageType,
                                                    msg: item.message,
                                                    senderName:
                                                        item.senderName);
                                                // replyToMessage(chatMap);
                                              },
                                              message: item.message ?? "",
                                              messageType:
                                                  item.messageType ?? "",
                                              sentTime: DateFormat('hh:mm a')
                                                  .format(DateTime.parse(
                                                          item.timestamp ?? "")
                                                      .toLocal()),
                                              sentByName: item.senderName ?? "",
                                              sentByImageUrl:
                                                  item.message ?? "",
                                              groupCreatedBy: "Pandey",
                                            ),
                                          ),
                                        );
                                  //             chatMap['isDelivered'])
                                  //         :
                                })
                            : const SizedBox.shrink(),
                  )),
                ],
              )),
              Obx(() => chatController.isMemberSuggestion.value
                  ? TagMemberWidget(chatController: chatController)
                  : const SizedBox()),
              Obx(() => chatController.isReply == true
                  ? SendMessageWidget(
                      groupId: widget.groupId,
                      msgController: chatController.msgController.value,
                      scrollController: _scrollController,
                    )
                  : SendMessageWidget(
                      groupId: widget.groupId,
                      msgController: chatController.msgController.value,
                      scrollController: _scrollController,
                    ))
            ],
          )),
    );
  }

  void _showReportDialog(
      {required BuildContext context,
      required TextEditingController textEditingController,
      required VoidCallback onTap,
      required String title,
      required RxBool isLoading}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: textEditingController,
            maxLines: 3,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: "Enter your issue"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Obx(
              () => TextButton(
                onPressed: onTap,
                child: isLoading.value
                    ? const CircularProgressIndicator.adaptive()
                    : const Text('Submit'),
              ),
            )
          ],
        );
      },
    );
  }

  void _showPopupMenu(BuildContext context, String msgId) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        const Offset(90, 500),
        Offset(overlay.size.width, overlay.size.height),
      ),
      Offset.zero & overlay.size,
    );

    final result = await showMenu(
      context: context,
      position: position,
      items: [
        const PopupMenuItem(
          value: 1,
          child: Text('Report Message'),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text('Delete Message'),
        ),
      ],
    );

    // Handle the selected option
    if (result != null) {
      switch (result) {
        case 1:
          _showReportDialog(
              context: context,
              textEditingController:
                  reportController.messageReportController.value,
              onTap: () {
                reportController.messageReport(
                    messageId: msgId,
                    groupId: widget.groupId,
                    context: context);
              },
              title: "Report Message",
              isLoading: false.obs);
          break;
        case 2:
          // Handle option 2
          break;
      }
    }
  }
}
