import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Commons/route.dart';
import 'package:cpscom_admin/Features/Login/Controller/login_controller.dart';
import 'package:cpscom_admin/Features/MyProfile/Presentation/my_profile_screen.dart';
import 'package:cpscom_admin/Features/SoftwareLicencesScreen/Presentation/licenses_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Commons/app_colors.dart';
import '../../../Commons/app_sizes.dart';

class HomeHeader extends StatefulWidget {
  final List<dynamic>? groupsList;

  const HomeHeader({Key? key, this.groupsList}) : super(key: key);

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final loginController = Get.put(LoginController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginController.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Chats',
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(color: AppColors.black, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => context.push(MyProfileScreen(
              groupsList: widget.groupsList,
            )),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(AppSizes.cardCornerRadius * 10),
              child: Obx(() => CachedNetworkImage(
                  width: 34,
                  height: 34,
                  fit: BoxFit.cover,
                  imageUrl: loginController.userModel.value.name ?? "",
                  placeholder: (context, url) => const CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.bg,
                      ),
                  errorWidget: (context, url, error) => CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.bg,
                        child: Text(
                          loginController.userModel.value.name
                              .toString()[0]
                              .toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ))),
            ),
          ),
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              size: 24,
              color: AppColors.darkGrey,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 1,
                  child: Text(
                    'Software Licences',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
            ],
            onSelected: (value) {
              switch (value) {
                case 1:
                  context.push(const LicenseScreen());
                  break;
              }
            },
          )
        ],
      ),
    );
  }
}
