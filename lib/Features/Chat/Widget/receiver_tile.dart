import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Commons/route.dart';
import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:cpscom_admin/Widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:linkable/linkable.dart';

import '../../../Commons/app_colors.dart';
import '../../../Commons/app_sizes.dart';
import 'show_image_widget.dart';

class ReceiverTile extends StatelessWidget {
  final String message;
  final String messageType;
  final String sentTime;
  final String sentByName;
  final String sentByImageUrl;
  final String groupCreatedBy;
  final ValueChanged<Map<String, dynamic>> onSwipedMessage;
  ChatController chatController;
  final String fileName;

  ReceiverTile(
      {Key? key,
      required this.message,
      required this.messageType,
      required this.sentTime,
      required this.fileName,
      required this.sentByName,
      this.sentByImageUrl = '',
      required this.groupCreatedBy,
      required this.onSwipedMessage,
      required this.chatController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              mainAxisAlignment: MainAxisAlignment.start,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: ChatBubble(
                        // padding: messageType == 'image' ||
                        //         messageType == 'pdf' ||
                        //         messageType == 'docx' ||
                        //         messageType == 'doc' ||
                        //         messageType == 'mp4'
                        //     ? EdgeInsets.zero
                        //     : null,
                        clipper:
                            ChatBubbleClipper3(type: BubbleType.receiverBubble),
                        backGroundColor: AppColors.lightGrey,
                        alignment: Alignment.topLeft,
                        elevation: 0,
                        margin: const EdgeInsets.only(
                            top: AppSizes.kDefaultPadding / 4),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.65),
                          child: messageType == 'image'
                              ? GestureDetector(
                                  onTap: () {
                                    context.push(ShowImage(imageUrl: message));
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
                                      errorWidget: (context, url, error) =>
                                          const CircularProgressIndicator
                                              .adaptive(),
                                    ),
                                  ),
                                )
                              : messageType == 'text'
                                  ? Linkable(
                                      text: message,
                                      linkColor: Colors.blue,
                                    )
                                  : messageType == 'doc'
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              AppSizes.cardCornerRadius),
                                          child: Container(
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
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
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.download_for_offline,
                                                    size: 35,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            left: 10,
                                                            right: 10),
                                                    child: Text(
                                                      fileName,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : messageType == "video"
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
                                                    imageUrl: message.isNotEmpty
                                                        ? message
                                                        : '',
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        const CircularProgressIndicator
                                                            .adaptive(),
                                                    errorWidget: (context, url,
                                                            error) =>
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
                ),
              ],
            ),
          );
  }
}
