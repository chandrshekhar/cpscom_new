import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Commons/app_colors.dart';
import 'package:cpscom_admin/Commons/app_sizes.dart';
import 'package:flutter/material.dart';

class SenderMsgReplyWidget extends StatelessWidget {
  const SenderMsgReplyWidget(
      {super.key, required this.replyMsg, required this.senderName, required this.messageType});

  final String replyMsg, messageType;
  final String senderName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 2,
      ),
      decoration: const BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(AppSizes.cardCornerRadius),
              bottomRight: Radius.circular(AppSizes.cardCornerRadius))),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      senderName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.kDefaultPadding / 8,
                  ),
                  messageType == "image"
                      ? CachedNetworkImage(
                          imageUrl: replyMsg,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => const CircularProgressIndicator.adaptive(),
                          errorWidget: (context, url, error) =>
                              const CircularProgressIndicator.adaptive(),
                        )
                      : Flexible(
                          flex: 1,
                          child: Text(
                            replyMsg,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: AppColors.darkGrey),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
