import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Api/firebase_provider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../Commons/app_colors.dart';
import '../Commons/app_sizes.dart';

class ParticipantsCardWidget extends StatelessWidget {
  final bool? isUserAdmin;
  final bool? isUserSuperAdmin;
  final Map<String, dynamic> member;
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
      leading: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(member['uid'])
              .snapshots(),
          builder: (context, snapshot) {
            return ClipRRect(
              borderRadius:
                  BorderRadius.circular(AppSizes.cardCornerRadius * 10),
              child: CachedNetworkImage(
                width: 28,
                height: 28,
                fit: BoxFit.cover,
                imageUrl: snapshot.data?['profile_picture'] ?? "",
                placeholder: (context, url) => const CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.bg,
                ),
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.bg,
                  child: Text(
                    member['name'].substring(0, 1),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            );
          }),
      title: Text(
        member['name'],
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: AppColors.black, fontWeight: FontWeight.w500),
      ),
      subtitle: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(member['uid'])
              .snapshots(),
          builder: (context, snapshot) {
            return Text(
              snapshot.data?['email'] ?? "",
              style: Theme.of(context).textTheme.bodySmall,
            );
          }),
      trailing: creatorId == member['uid'] || member['isSuperAdmin'] == true
          ? Text(
              'Admin',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: AppColors.darkGrey, fontWeight: FontWeight.w400),
            )
          : (creatorId == FirebaseProvider.auth.currentUser!.uid ||
                  isUserSuperAdmin == true)
              ? IconButton(
                  onPressed: () => onDeleteButtonPressed.call(),
                  icon: const Icon(
                    EvaIcons.trash2,
                    color: AppColors.grey,
                    size: 16,
                  ),
                )
              : const SizedBox(),
    );
  }
}
