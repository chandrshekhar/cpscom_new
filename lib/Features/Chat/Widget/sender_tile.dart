import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:cpscom_admin/Features/Chat/Model/chat_list_model.dart';
import 'package:cpscom_admin/Features/Chat/Widget/sender_reply_widget.dart';
import 'package:cpscom_admin/Widgets/video_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:get/get.dart';
import 'package:linkable/linkable.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swipe_to/swipe_to.dart';
import '../../../Utils/check_emojii.dart';
import '../../../Utils/check_website.dart';
import 'show_image_widget.dart';

class SenderTile extends StatefulWidget {
  final String message;
  final String messageType;
  final String sentTime;
  final String groupCreatedBy;
  final String read;
  final VoidCallback? onTap;
  RxBool isSeen = false.obs;
  RxBool isDelivered = false.obs;
  String? fileName;
  void Function()? onLeftSwipe;
  final ReplyOf? replyOf;
  final int index;

  SenderTile(
      {Key? key,
      required this.message,
      required this.messageType,
      this.fileName,
      required this.sentTime,
      required this.groupCreatedBy,
      required this.read,
      required this.index,
      required this.isSeen,
      required this.isDelivered,
      this.onTap,
      this.onLeftSwipe,
      this.replyOf})
      : super(key: key);

  @override
  State<SenderTile> createState() => _SenderTileState();
}

class _SenderTileState extends State<SenderTile> {
  final chatController = Get.put(ChatController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(right: AppSizes.kDefaultPadding, top: AppSizes.kDefaultPadding),
      child: SwipeTo(
        onLeftSwipe: widget.onLeftSwipe,
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
                    widget.sentTime,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12),
                  ),
                  const SizedBox(
                    width: AppSizes.kDefaultPadding / 2,
                  ),
                  Obx(() => widget.isDelivered.value == true
                      ? Icon(
                          Icons.done_all_rounded,
                          size: 16,
                          color: widget.isSeen.value == true ? AppColors.primary : AppColors.grey,
                        )
                      : const Icon(
                          Icons.check,
                          size: 16,
                          color: AppColors.grey,
                        ))
                ],
              ),
            ),
            widget.replyOf != null
                ? SenderMsgReplyWidget(
                    replyMsg: widget.replyOf?.msg ?? "",
                    senderName: widget.replyOf?.sender ?? "",
                    messageType: widget.messageType,
                  )
                : const SizedBox(),
            ChatBubble(
              clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
              backGroundColor: AppColors.secondary.withOpacity(0.3),
              alignment: Alignment.topRight,
              elevation: 0,
              margin: const EdgeInsets.only(top: AppSizes.kDefaultPadding / 4),
              child: Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
                  child: widget.messageType == 'image'
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ShowImage(imageUrl: widget.message)));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppSizes.cardCornerRadius),
                            child: CachedNetworkImage(
                              imageUrl: widget.message,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator.adaptive(),
                              errorWidget: (context, url, error) =>
                                  const CircularProgressIndicator.adaptive(),
                            ),
                          ),
                        )
                      : widget.messageType == 'text'
                          ? CheckWebsite().isWebsite(widget.message) || widget.message.contains("@")
                              ? Linkable(
                                  text: widget.message,
                                  linkColor: Colors.blue,
                                )
                              : Text(widget.message,
                                  style: TextStyle(fontSize: isOnlyEmoji(widget.message) ? 40 : 15))
                          : widget.messageType == 'doc'
                              ? InkWell(
                                  onTap: () async {
                                    chatController.openFileAfterDownload(
                                        widget.message, widget.fileName ?? "", context);
                                    // await openFile(
                                    //     url: widget.message,
                                    //     fileName: widget.fileName);
                                    // print("presss");
                                    // _downloadAndOpenFile(
                                    //     file: widget.message,
                                    //     fileName: widget.fileName!);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(AppSizes.cardCornerRadius),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width * 0.45,
                                          maxHeight: MediaQuery.of(context).size.width * 0.30),
                                      child: SizedBox(
                                        height: MediaQuery.of(context).size.width * 0.30,
                                        width: MediaQuery.of(context).size.width * 0.45,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.cloud_download,
                                              size: 40,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 10, right: 10),
                                              child: Text(
                                                widget.fileName ?? "",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontSize: 18),
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
                                              builder: (context) => VideoMessage(
                                                videoUrl: widget.message,
                                              ),
                                            ));
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context).size.width * 0.35,
                                            maxHeight: MediaQuery.of(context).size.width * 0.20),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(AppSizes.cardCornerRadius),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                widget.message.isNotEmpty ? widget.message : '',
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator.adaptive(),
                                            errorWidget: (context, url, error) =>
                                                const Icon(Icons.play_arrow),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox()),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadAndOpenFile({required String file, required String fileName}) async {
    var dio = Dio();
    var dir = await getApplicationDocumentsDirectory();
    String filePath = "${dir.path}/$fileName"; // Change the extension based on your file type
    try {
      await dio.download(file, filePath);
      OpenAppFile.open(filePath); // Open the downloaded file using the native app
    } catch (e) {
      print("Error downloading file: $e");
    }
  }
}
