import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Commons/app_colors.dart';
import 'package:cpscom_admin/Commons/app_sizes.dart';
import 'package:cpscom_admin/Commons/route.dart';
import 'package:cpscom_admin/Features/Forget%20password/presentation/change_password_screen.dart';
import 'package:cpscom_admin/Features/Home/Controller/home_controller.dart';
import 'package:cpscom_admin/Features/Home/Controller/socket_controller.dart';
import 'package:cpscom_admin/Features/Login/Controller/login_controller.dart';
import 'package:cpscom_admin/Features/Login/Presentation/login_screen.dart';
import 'package:cpscom_admin/Features/UpdateUserStatus/Presentation/update_user_status_screen.dart';
import 'package:cpscom_admin/Utils/navigator.dart';
import 'package:cpscom_admin/Utils/storage_service.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Commons/app_images.dart';
import '../../../Utils/custom_bottom_modal_sheet.dart';
import '../../../Widgets/custom_confirmation_dialog.dart';
import '../../GroupInfo/Model/image_picker_model.dart';

class MyProfileScreen extends StatefulWidget {
  final List<dynamic>? groupsList;

  const MyProfileScreen({Key? key, this.groupsList}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final homeController = Get.put(HomeController());
  final loginController = Get.put(LoginController());
  final socketController = Get.put(SocketController());
  @override
  void initState() {
    loginController.getUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'My Profile',
          actions: [
            TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext dialogContext) {
                        return ConfirmationDialog(
                            title: 'Logout?',
                            body: 'Are you sure you want to logout?',
                            positiveButtonLabel: 'Logout',
                            negativeButtonLabel: 'Cancel',
                            onPressedPositiveButton: () {
                              Get.delete<SocketController>();
                              socketController.socket?.clearListeners();
                              socketController.socket?.destroy();
                              socketController.socket?.dispose();
                              socketController.socket?.disconnect();
                              socketController.socket?.io.disconnect();
                              socketController.socket?.io.close();
                              socketController.socket?.io
                                  .destroy(socketController.socket);
                              LocalStorage().deleteAllLocalData();
                              context.pushAndRemoveUntil(const LoginScreen());
                            });
                      });
                },
                child: Row(
                  children: [
                    const Icon(
                      EvaIcons.logOutOutline,
                      color: AppColors.red,
                      size: 18,
                    ),
                    const SizedBox(
                      width: AppSizes.kDefaultPadding / 3,
                    ),
                    Text(
                      'Logout',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.red, fontWeight: FontWeight.w500),
                    ),
                  ],
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  AppSizes.cardCornerRadius * 10),
                              child: Obx(
                                () => CachedNetworkImage(
                                  width: 106,
                                  height: 106,
                                  fit: BoxFit.cover,
                                  imageUrl: loginController
                                              .userModel.value.image !=
                                          null
                                      ? loginController.userModel.value.image
                                          .toString()
                                      : "",
                                  placeholder: (context, url) =>
                                      const CircleAvatar(
                                    radius: 66,
                                    backgroundColor: AppColors.bg,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                    radius: 66,
                                    backgroundColor: AppColors.bg,
                                    child: Text(
                                      loginController.userModel.value.name
                                          .toString()[0]
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    showCustomBottomSheet(
                                        context,
                                        '',
                                        SizedBox(
                                          height: 150,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              padding: const EdgeInsets.all(
                                                  AppSizes.kDefaultPadding),
                                              itemCount: imagePickerList.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    switch (index) {
                                                      case 0:
                                                        loginController.pickImage(
                                                            context: context,
                                                            imageSource:
                                                                ImageSource
                                                                    .gallery);
                                                        break;
                                                      case 1:
                                                        loginController
                                                            .pickImage(
                                                                context:
                                                                    context,
                                                                imageSource:
                                                                    ImageSource
                                                                        .camera);
                                                        break;
                                                    }

                                                    Navigator.pop(context);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .only(
                                                        left: AppSizes
                                                                .kDefaultPadding *
                                                            2),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: 60,
                                                          height: 60,
                                                          padding: const EdgeInsets
                                                              .all(AppSizes
                                                                  .kDefaultPadding),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: AppColors
                                                                      .lightGrey),
                                                              color: AppColors
                                                                  .white,
                                                              shape: BoxShape
                                                                  .circle),
                                                          child:
                                                              imagePickerList[
                                                                      index]
                                                                  .icon,
                                                        ),
                                                        const SizedBox(
                                                          height: AppSizes
                                                                  .kDefaultPadding /
                                                              2,
                                                        ),
                                                        Text(
                                                          '${imagePickerList[index].title}',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ));
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    padding: const EdgeInsets.all(
                                        AppSizes.kDefaultPadding / 1.3),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: AppColors.lightGrey),
                                        color: AppColors.white,
                                        shape: BoxShape.circle),
                                    child: Image.asset(
                                      AppImages.cameraIcon,
                                      width: 36,
                                      height: 36,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.kDefaultPadding),
                            child: Text(
                              'Add an optional profile picture',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const CustomDivider(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.kDefaultPadding),
                child: Column(
                  children: [
                    ListTile(
                      dense: true,
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        EvaIcons.person,
                        color: AppColors.grey,
                        size: 20,
                      ),
                      title: Text(
                        'Name',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      subtitle: Obx(() => Text(
                            loginController.userModel.value.name ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.w400),
                          )),
                    ),
                    const CustomDivider(),
                    ListTile(
                      dense: true,
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        EvaIcons.email,
                        color: AppColors.grey,
                        size: 20,
                      ),
                      title: Text(
                        'Email',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      subtitle: Obx(() => Text(
                            loginController.userModel.value.email ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.w400),
                          )),
                    ),
                    const CustomDivider(),
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  context.push(const UpdateUserStatusScreen());
                },
                dense: true,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.kDefaultPadding),
                horizontalTitleGap: 0,
                leading: const Icon(
                  EvaIcons.info,
                  color: AppColors.grey,
                  size: 20,
                ),
                title: Text(
                  'Status',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                subtitle: Obx(() => Text(
                      loginController.userModel.value.accountStatus ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w400),
                    )),
                trailing: const Icon(
                  EvaIcons.arrowIosForward,
                  color: AppColors.grey,
                  size: 24,
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: AppSizes.kDefaultPadding),
                child: CustomDivider(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: InkWell(
                  onTap: () {
                    doNavigator(
                        route: const ChangePasswordScreen(), context: context);
                  },
                  child: ListTile(
                    dense: true,
                    horizontalTitleGap: 0,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      EvaIcons.lock,
                      color: AppColors.grey,
                      size: 20,
                    ),
                    title: Text(
                      'Change Password',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: AppSizes.kDefaultPadding),
                child: CustomDivider(),
              ),
            ],
          ),
        ));
  }
}
