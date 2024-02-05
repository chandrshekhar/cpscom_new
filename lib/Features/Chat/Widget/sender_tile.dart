import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:linkable/linkable.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'show_image_widget.dart';
import 'show_pdf_viewer.dart';

class SenderTile extends StatelessWidget {
  final String message;
  final String messageType;
  final String sentTime;
  final String groupCreatedBy;
  final String read;
  final VoidCallback? onTap;
  bool? isSeen;
  bool? isDelivered;

  SenderTile(
      {Key? key,
      required this.message,
      required this.messageType,
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
                          borderRadius:
                              BorderRadius.circular(AppSizes.cardCornerRadius),
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
                        : messageType == 'pdf'
                            ? Stack(
                                children: [
                                  ClipRRect(
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
                                        child: const PDF().cachedFromUrl(
                                          message,
                                          maxAgeCacheObject:
                                              const Duration(days: 30),
                                          //duration of cache
                                          placeholder: (progress) => Center(
                                              child: Text('$progress %')),
                                          errorWidget: (error) => const Center(
                                              child: Text('Loading...')),
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
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          maxHeight: MediaQuery.of(context)
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
      ),
    );
  }
}
