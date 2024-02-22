import 'package:cpscom_admin/Commons/app_colors.dart';
import 'package:cpscom_admin/Commons/app_sizes.dart';
import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:flutter/material.dart';

class TagMemberWidget extends StatelessWidget {
  const TagMemberWidget({super.key, required this.chatController});

  final ChatController chatController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 40),
      decoration: const BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(AppSizes.cardCornerRadius),
              bottomRight: Radius.circular(AppSizes.cardCornerRadius))),
      padding: const EdgeInsets.only(left: 20),
      child: ListView.builder(
          itemCount: chatController.groupModel.value.currentUsers!.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // debugPrint("Memebrlist-> $membersList");
            // return Text("index $index");
            return ListTile(
              onTap: () {
                chatController.addNameInMsgText(
                    mentionname: chatController
                        .groupModel.value.currentUsers![index].name??"");
                chatController.isMemberSuggestion(false);
              },
              contentPadding: EdgeInsets.zero,
              title: Text(
                chatController.groupModel.value.currentUsers![index].name ?? "",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }),
    );
  }
}
