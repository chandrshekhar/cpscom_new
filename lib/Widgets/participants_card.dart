import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Features/Home/Model/group_list_model.dart';
import 'package:cpscom_admin/Features/Login/Controller/login_controller.dart';
import 'package:cpscom_admin/Utils/storage_service.dart';
import 'package:cpscom_admin/Widgets/image_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Commons/app_colors.dart';
import '../Commons/app_sizes.dart';

class ParticipantsCardWidget extends StatelessWidget {
  final CurrentUsers member;
  final String? creatorId;
  final VoidCallback onDeleteButtonPressed;

  final String? userType;

  const ParticipantsCardWidget({
    Key? key,
    required this.onDeleteButtonPressed,
    required this.member,
    this.creatorId,
    this.userType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      trailing: userType == "SuperAdmin" || userType == "admin"
          ? Text(userType ?? "")
          : loginController.userModel.value.userType == "admin" ||
                  loginController.userModel.value.userType == "SuperAdmin"
              ? IconButton(
                  onPressed: onDeleteButtonPressed,
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ))
              : userType == "SuperAdmin" ||
                      userType == "user" &&
                          !member.sId.toString().contains(LocalStorage().getUserId().toString())
                  ? Text(userType ?? "")
                  : InkWell(
                      child: Text(
                        "My Self",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
      // member.sId.toString().contains(LocalStorage().getUserId().toString()) &&
      //         userType == 'user'
      //     ? Text(
      //         "Remove me",
      //         style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      //       )
      //     : member.sId.toString().contains(LocalStorage().getUserId().toString()) &&
      //             userType == "admin"
      //         ? IconButton(
      //             onPressed: onDeleteButtonPressed,
      //             icon: const Icon(
      //               Icons.delete,
      //               color: Colors.red,
      //             ))
      //         : Text(userType ?? ""),

      // userType == "SuperAdmin"
      //     ? Text(userType ?? "")
      //     : userType == "SuperAdmin"
      //         ? IconButton(
      //             onPressed: onDeleteButtonPressed,
      //             icon: const Icon(
      //               Icons.delete,
      //               color: Colors.red,
      //             ))
      //         : SizedBox(),
      leading: InkWell(
        onTap: () {
          if (member.image != null) {
            Get.to(
                () => FullScreenImageViewer(
                      imageUrl: member.image ?? "",
                      lableText: member.name ?? "",
                    ),
                transition: Transition.circularReveal, // Optional: Customize the animation
                duration: const Duration(milliseconds: 700));
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.cardCornerRadius * 10),
          child: CachedNetworkImage(
            width: 28,
            height: 28,
            fit: BoxFit.cover,
            imageUrl: member.image ?? "",
            placeholder: (context, url) => const CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.bg,
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.bg,
              child: Text(
                member.name!.substring(0, 1),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
      title: Text(
        member.name ?? "",
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: AppColors.black, fontWeight: FontWeight.w500),
      ),
    );
  }
}
