import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/Home/Presentation/home_screen.dart';
import 'package:cpscom_admin/Features/Login/Controller/login_controller.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Widgets/custom_floating_action_button.dart';
import '../../AddMembers/Presentation/add_members_screen.dart';

class BuildMobileView extends StatefulWidget {
  const BuildMobileView({Key? key}) : super(key: key);

  @override
  State<BuildMobileView> createState() => _BuildMobileViewState();
}

class _BuildMobileViewState extends State<BuildMobileView> {
  final userController = Get.put(LoginController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userController.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.white,
        child: Scaffold(
            body: SafeArea(
              bottom: false,
              child: Obx(() => BuildChatList(
                  isAdmin: userController.userModel.value.userType != null &&
                          userController.userModel.value.userType!.isNotEmpty
                      ? userController.userModel.value.userType!
                                  .contains(AdminCheck.admin) ||
                              userController.userModel.value.userType!
                                  .contains(AdminCheck.superAdmin)
                          ? true
                          : false
                      : false)),
            ),
            floatingActionButton: Obx(() =>
                userController.userModel.value.userType != null &&
                        userController.userModel.value.userType!.isNotEmpty
                    ? userController.userModel.value.userType!
                                .contains(AdminCheck.admin) ||
                            userController.userModel.value.userType!
                                .contains(AdminCheck.superAdmin)
                        ? CustomFloatingActionButton(
                            onPressed: () {
                              context.push(const AddMembersScreen(
                                isCameFromHomeScreen: true,
                                groupId: "",
                              ));
                              //context.push(AddParticipantsScreen());
                            },
                            iconData: EvaIcons.plus,
                          )
                        : const SizedBox()
                    : const SizedBox())));
  }
}
