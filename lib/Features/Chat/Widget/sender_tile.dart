import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Utils/open_any_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:linkable/linkable.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'show_image_widget.dart';

class SenderTile extends StatelessWidget {
  final String message;
  final String messageType;
  final String sentTime;
  final String groupCreatedBy;
  final String read;
  final VoidCallback? onTap;
  bool? isSeen;
  bool? isDelivered;
  String? fileName;

  SenderTile(
      {Key? key,
      required this.message,
      required this.messageType,
      this.fileName,
      required this.sentTime,
      required this.groupCreatedBy,
      required this.read,
      this.isSeen = false,
      this.isDelivered = true,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails) => onTap,
      child: Padding(
        padding: const EdgeInsets.only(
            right: AppSizes.kDefaultPadding, top: AppSizes.kDefaultPadding),
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
            ChatBubble(
              clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
              backGroundColor: AppColors.secondary.withOpacity(0.3),
              alignment: Alignment.topRight,
              elevation: 0,
              margin: const EdgeInsets.only(top: AppSizes.kDefaultPadding / 4),
              child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65),
                  child: messageType == 'image'
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
                                  const CircularProgressIndicator.adaptive(),
                              errorWidget: (context, url, error) =>
                                  const CircularProgressIndicator.adaptive(),
                            ),
                          ),
                        )
                      : messageType == 'text'
                          ? Linkable(
                              text: message.trim(),
                              linkColor: Colors.blue,
                            )
                          : messageType == 'doc'
                              ? InkWell(
                                  onTap: () {
                                    openPDF(
                                        fileUrl: message,
                                        fileName: fileName ?? "");
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.cardCornerRadius),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.30),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.30,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.download_for_offline,
                                              size: 40,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 10, right: 10),
                                              child: Text(
                                                fileName ?? "",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              ),
                                            )
                                          ],
                                        ),
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
}
