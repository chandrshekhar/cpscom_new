import 'dart:developer';

import 'package:cpscom_admin/Commons/app_images.dart';
import 'package:cpscom_admin/Commons/app_sizes.dart';
import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:cpscom_admin/Utils/storage_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Commons/app_colors.dart';
import '../../../Utils/custom_bottom_modal_sheet.dart';
import '../../../Widgets/custom_divider.dart';
import '../../../Widgets/custom_text_field.dart';
import '../../GroupInfo/Model/image_picker_model.dart';

class SendMessageWidget extends StatefulWidget {
  final TextEditingController msgController;
  final ScrollController scrollController;
  final String groupId;

  const SendMessageWidget({
    super.key,
    required this.msgController,
    required this.scrollController,
    required this.groupId,
  });

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  final chatController = Get.put(ChatController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatController.getGroupDetailsById(groupId: widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                    borderRadius:
                        BorderRadius.circular(AppSizes.cardCornerRadius),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          chatController.isReply.value == true
                              ? Container(
                                  height: 56,
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width,
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
                                        height: 54,
                                        width: 2,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(
                                        width: AppSizes.kDefaultPadding / 2,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child: Text(
                                                  chatController
                                                      .replyOf['sender'],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color:
                                                              AppColors.primary,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(
                                                height:
                                                    AppSizes.kDefaultPadding /
                                                        8,
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Text(
                                                  chatController.replyOf['msg'],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color: AppColors
                                                              .darkGrey),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            chatController.isRelayFunction(
                                                isRep: false);
                                            FocusScope.of(context).unfocus();
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            size: 24,
                                            color: AppColors.darkGrey,
                                          ))
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          chatController.isReply.value == true
                              ? const CustomDivider()
                              : const SizedBox(),
                          CustomTextField(
                            controller: widget.msgController,
                            hintText: 'Type a message',
                            maxLines: 4,
                            isReplying: chatController.isReply.value,
                            //  focusNode: focusNode,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            onChanged: (value) {
                              chatController.mentionMember(value!);
                              return;
                            },
                            isBorder: false,
                            //onCancelReply: onCancelReply,
                            replyMessage: const {},
                          ),
                        ],
                      )),
                      InkWell(
                        onTap: () {
                          showCustomBottomSheet(
                              context,
                              '',
                              SizedBox(
                                height: 150,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(
                                        AppSizes.kDefaultPadding),
                                    itemCount: chatPickerList.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          var ownId =
                                              LocalStorage().getUserId();
                                          List<String> userIds = chatController
                                              .groupModel.value.currentUsers!
                                              .map((user) => user.sId!)
                                              .where(
                                                  (userId) => userId != ownId)
                                              .toList();

                                          switch (index) {
                                            case 0:
                                              chatController.pickFile(
                                                  groupId: widget.groupId,
                                                  receiverId: userIds,
                                                  context: context);
                                              break;
                                            case 1:
                                              chatController
                                                  .pickImageForSendSms(
                                                      imageSource:
                                                          ImageSource.gallery,
                                                      groupId: widget.groupId,
                                                      receiverId: userIds,
                                                      context: context);
                                              break;
                                            case 2:
                                              chatController
                                                  .pickImageForSendSms(
                                                      imageSource:
                                                          ImageSource.camera,
                                                      groupId: widget.groupId,
                                                      receiverId: userIds,
                                                      context: context);

                                              break;
                                            case 3:
                                              chatController
                                                  .pickVideoFromCameraAndSendMsg(
                                                      groupId: widget.groupId,
                                                      receiverId: userIds);
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left:
                                                  AppSizes.kDefaultPadding * 2),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 60,
                                                height: 60,
                                                padding: const EdgeInsets.all(
                                                    AppSizes.kDefaultPadding),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: AppColors
                                                            .lightGrey),
                                                    color: AppColors.white,
                                                    shape: BoxShape.circle),
                                                child:
                                                    chatPickerList[index].icon,
                                              ),
                                              const SizedBox(
                                                height:
                                                    AppSizes.kDefaultPadding /
                                                        2,
                                              ),
                                              Text(
                                                '${chatPickerList[index].title}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ));
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
                  if (widget.msgController.text.isNotEmpty) {
                    chatController.msgText.value =
                        widget.msgController.text.toString();
                    widget.msgController.clear();
                    var ownId = LocalStorage().getUserId();
                    List<String> userIds = chatController
                        .groupModel.value.currentUsers!
                        .map((user) => user.sId!)
                        .where((userId) => userId != ownId)
                        .toList();
                    log("User id is for another persion $userIds");
                    await chatController.sendMsg(
                        replyOf: chatController.isReply.value == true
                            ? chatController.replyOf
                            : null,
                        msg: chatController.msgText.value,
                        reciverId: userIds,
                        groupId: widget.groupId,
                        msgType: "text");
                    chatController.isRelayFunction(
                      isRep: false,
                    );
                  } else {}
                },
                child: Container(
                  width: 36,
                  height: 36,
                  padding: const EdgeInsets.all(AppSizes.kDefaultPadding / 2),
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
    );
  }
}
