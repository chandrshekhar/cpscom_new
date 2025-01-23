import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:flutter/material.dart';

import '../../MyProfile/Presentation/my_profile_screen.dart';
import 'home_screen.dart';

class BuildTabletView extends StatefulWidget {
  final bool isDeleteNavigation;
  const BuildTabletView({Key? key, required this.isDeleteNavigation}) : super(key: key);

  @override
  State<BuildTabletView> createState() => _BuildTabletViewState();
}

class _BuildTabletViewState extends State<BuildTabletView> {
  bool? isAdmin;
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Container(
                  height: AppSizes.appBarHeight,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.kDefaultPadding),
                  decoration: const BoxDecoration(color: AppColors.bg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context.push(const MyProfileScreen()),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              AppSizes.cardCornerRadius * 10),
                          child: CachedNetworkImage(
                              width: 34,
                              height: 34,
                              fit: BoxFit.cover,
                              imageUrl:
                                  'https://images.unsplash.com/photo-1575936123452-b67c3203c357?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D',
                              placeholder: (context, url) => const CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppColors.bg,
                                  ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppColors.bg,
                                    child: Text(
                                      "Name",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  )),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(child: BuildChatList(isAdmin: isAdmin ?? false, isDeleteNavigation: widget.isDeleteNavigation,))
              ],
            ),
          ),
          Container(
            width: 1,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: AppColors.lightGrey),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: AppColors.bg,
            ),
          ),
        ],
      ),
    );
  }
}
