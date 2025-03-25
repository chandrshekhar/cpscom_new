import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Features/Chat/Controller/chat_info_controller.dart';
import 'package:cpscom_admin/Features/Chat/Model/chat_list_model.dart';
import 'package:cpscom_admin/Features/Home/Controller/socket_controller.dart';
import 'package:cpscom_admin/Utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../Commons/app_colors.dart';
import '../../../Commons/app_sizes.dart';
import '../../../Widgets/image_popup.dart';
import '../Widget/sender_tile.dart';

class ChatInfoListScreen extends StatefulWidget {
  final ChatModel chatModel;

  ChatInfoListScreen({Key? key, required this.chatModel}) : super(key: key);

  @override
  State<ChatInfoListScreen> createState() => _ChatInfoListScreenState();
}

class _ChatInfoListScreenState extends State<ChatInfoListScreen> {
  final chatInfoController = Get.put(ChatInfoController());
  final socketController = Get.put(SocketController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      socketController.msgId.value= widget.chatModel.sId;
      chatInfoController.chatInfo(msgId: widget.chatModel.sId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              backFromPrevious(context: context);
            },
            child: const Icon(
              Icons.arrow_back,
              size: 25,
            ),
          ),
          title: const Text('Chat Info'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              SenderTile(
                isDelivered:
                    widget.chatModel.allRecipients?.length == widget.chatModel.deliveredTo?.length
                        ? true.obs
                        : false.obs,
                isSeen: widget.chatModel.allRecipients?.length == widget.chatModel.readBy?.length
                    ? true.obs
                    : false.obs,
                index: 0,
                fileName: widget.chatModel.fileName ?? "",
                message: widget.chatModel.message ?? "",
                messageType: widget.chatModel.messageType.toString(),
                sentTime: DateFormat('MM/dd/yyyy HH:mm')
                    .format(DateTime.parse(widget.chatModel.timestamp ?? "").toLocal()),
                groupCreatedBy: "",
                read: "value",
                onLeftSwipe: null,
                replyOf: widget.chatModel.replyOf,
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(
                () => chatInfoController.isLoading.value
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          chatInfoController.chatInfoModel.value != null &&
                                  chatInfoController
                                      .chatInfoModel.value!.data!.readUserData!.isNotEmpty
                              ? Container(
                                  margin: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20, right: 20, top: 10),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Read by",
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      Column(
                                        children: List.generate(
                                            chatInfoController.chatInfoModel.value!.data!
                                                .readUserData!.length, (index) {
                                          var item = chatInfoController
                                              .chatInfoModel.value!.data!.readUserData![index];
                                          return ReadByDeliveryByCardWidget(
                                            date: item.timestamp ?? "",
                                            imageUrl: item.image ?? "",
                                            name: item.name ?? "",
                                          );
                                        }),
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox(),
                          chatInfoController.chatInfoModel.value != null &&
                                  chatInfoController
                                      .chatInfoModel.value!.data!.deliveredToData!.isNotEmpty
                              ? Container(
                                  margin: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20, right: 20, top: 10),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Delivered to",
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      Column(
                                        children: List.generate(
                                            chatInfoController.chatInfoModel.value!.data!
                                                .deliveredToData!.length, (index) {
                                          var item = chatInfoController
                                              .chatInfoModel.value!.data!.deliveredToData![index];
                                          return ReadByDeliveryByCardWidget(
                                            date: item.timestamp ?? "",
                                            imageUrl: item.image ?? "",
                                            name: item.name ?? "",
                                          );
                                        }),
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
              )
            ],
          ),
        ));
  }
}

class ReadByDeliveryByCardWidget extends StatelessWidget {
  final String name, date, imageUrl;
  const ReadByDeliveryByCardWidget(
      {super.key, required this.name, required this.date, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              // if (data.image != null && data.image!.isNotEmpty) {
              Get.to(
                  () => FullScreenImageViewer(
                        lableText: name,
                        imageUrl: imageUrl,
                      ),
                  transition: Transition.circularReveal, // Optional: Customize the animation
                  duration: const Duration(milliseconds: 700));
              // }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.cardCornerRadius * 10),
              child: CachedNetworkImage(
                width: 30,
                height: 30,
                fit: BoxFit.cover,
                imageUrl: imageUrl,
                placeholder: (context, url) => const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.shimmer,
                ),
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.shimmer,
                  child: Text(
                    "${name}".substring(0, 1),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style:
                    Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                DateFormat('MM/dd/yyyy HH:mm').format(DateTime.parse(date).toLocal()),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w400, color: AppColors.grey),
              ),
            ],
          )
        ],
      ),
    );
  }
}
