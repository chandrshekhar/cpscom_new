import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Commons/route.dart';
import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:cpscom_admin/Features/Chat/Model/chat_list_model.dart';
import 'package:cpscom_admin/Features/Chat/Widget/sender_reply_widget.dart';
import 'package:cpscom_admin/Widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:get/get.dart';
import 'package:linkable/linkable.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../Commons/app_colors.dart';
import '../../../Commons/app_sizes.dart';
import 'show_image_widget.dart';

class ReceiverTile extends StatefulWidget {
  final String message;
  final String messageType;
  final String sentTime;
  final String sentByName;
  final String sentByImageUrl;
  final String groupCreatedBy;
  final void Function()? onSwipedMessage;
  ChatController chatController;
  final String fileName;
  ReplyOf? replyOf;
  final int index;

  ReceiverTile(
      {Key? key,
      required this.replyOf,
      required this.message,
      required this.messageType,
      required this.sentTime,
      required this.fileName,
      required this.sentByName,
      this.sentByImageUrl = '',
      required this.groupCreatedBy,
      required this.onSwipedMessage,
      required this.chatController,
      required this.index})
      : super(key: key);

  @override
  State<ReceiverTile> createState() => _ReceiverTileState();
}

class _ReceiverTileState extends State<ReceiverTile> {
  final chatController = Get.put(ChatController());
  @override
  Widget build(BuildContext context) {
    return widget.messageType == 'notify'
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
                  '${widget.groupCreatedBy} ${widget.message}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          )
        : SwipeTo(
            onRightSwipe: widget.onSwipedMessage,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppSizes.cardCornerRadius * 3),
                    child: CachedNetworkImage(
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                        imageUrl: widget.sentByImageUrl,
                        placeholder: (context, url) => const CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.bg,
                            ),
                        errorWidget: (context, url, error) => CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.bg,
                              child: Text(
                                widget.sentByName
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
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.sentByName,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            ', ${widget.sentTime}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                      widget.replyOf != null
                          ? SenderMsgReplyWidget(
                              replyMsg: widget.replyOf?.msg ?? "",
                              senderName: widget.replyOf?.sender ?? "",
                            )
                          : SizedBox.fromSize(),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSizes.kDefaultPadding * 2,
                        ),
                        child: ChatBubble(
                          // padding: messageType == 'image' ||
                          //         messageType == 'pdf' ||
                          //         messageType == 'docx' ||
                          //         messageType == 'doc' ||
                          //         messageType == 'mp4'
                          //     ? EdgeInsets.zero
                          //     : null,
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
                            child: widget.messageType == 'image'
                                ? GestureDetector(
                                    onTap: () {
                                      context.push(
                                          ShowImage(imageUrl: widget.message));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          AppSizes.cardCornerRadius),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.message,
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator
                                                .adaptive(),
                                        errorWidget: (context, url, error) =>
                                            const CircularProgressIndicator
                                                .adaptive(),
                                      ),
                                    ),
                                  )
                                : widget.messageType == 'text'
                                    ? Linkable(
                                        text: widget.message,
                                        linkColor: Colors.blue,
                                      )
                                    : widget.messageType == 'doc'
                                        ? InkWell(
                                            onTap: () async {
                                              chatController
                                                  .openFileAfterDownload(
                                                      widget.message,
                                                      widget.fileName,
                                                      context);
                                            },
                                            child: ClipRRect(
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
                                                            0.40),
                                                child: SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.40,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.45,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .download_for_offline,
                                                        size: 35,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 10,
                                                                left: 10,
                                                                right: 10),
                                                        child: Text(
                                                          widget.fileName,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 18),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : widget.messageType == "video"
                                            ? GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            VideoMessage(
                                                          videoUrl:
                                                              widget.message,
                                                        ),
                                                      ));
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.35,
                                                      maxHeight:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.20),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius
                                                        .circular(AppSizes
                                                            .cardCornerRadius),
                                                    child: CachedNetworkImage(
                                                      imageUrl: widget.message
                                                              .isNotEmpty
                                                          ? widget.message
                                                          : '',
                                                      fit: BoxFit.cover,
                                                      placeholder: (context,
                                                              url) =>
                                                          const CircularProgressIndicator
                                                              .adaptive(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.play_arrow),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
