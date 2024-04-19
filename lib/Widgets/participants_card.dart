import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Features/Home/Model/group_list_model.dart';
import 'package:cpscom_admin/Utils/storage_service.dart';
import 'package:flutter/material.dart';

import '../Commons/app_colors.dart';
import '../Commons/app_sizes.dart';

class ParticipantsCardWidget extends StatelessWidget {
  final bool? isUserAdmin;
  final bool? isUserSuperAdmin;
  final CurrentUsers member;
  final String? creatorId;
  final VoidCallback onDeleteButtonPressed;

  const ParticipantsCardWidget({
    Key? key,
    required this.onDeleteButtonPressed,
    required this.member,
    this.isUserAdmin = false,
    this.creatorId,
    this.isUserSuperAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      trailing:
          member.sId.toString().contains(LocalStorage().getUserId().toString())
              ? const Text("My Self")
              : isUserAdmin == true
                  ? const Text("Admin")
                  : IconButton(
                      onPressed: onDeleteButtonPressed,
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
      leading: ClipRRect(
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
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w600),
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
