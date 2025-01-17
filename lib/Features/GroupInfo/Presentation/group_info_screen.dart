import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/AddMembers/Controller/group_create_controller.dart';
import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:cpscom_admin/Features/GroupInfo/ChangeGroupDescription/Presentation/chnage_group_description.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_card.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:cpscom_admin/Widgets/participants_card.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Commons/app_images.dart';
import '../../../Utils/custom_bottom_modal_sheet.dart';
import '../../../Utils/navigator.dart';
import '../../../Widgets/image_popup.dart';
import '../../../Widgets/shimmer_for_text.dart';
import '../../AddMembers/Presentation/add_members_screen.dart';
import '../../AddMembers/Widgets/delete_widget_alert.dart';
import '../Model/image_picker_model.dart';

class GroupInfoScreen extends StatefulWidget {
  final String groupId;
  final bool? isAdmin;

  const GroupInfoScreen({Key? key, required this.groupId, this.isAdmin}) : super(key: key);

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  final chatController = Get.put(ChatController());
  final memberController = Get.put(MemeberlistController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatController.getGroupDetailsById(groupId: widget.groupId);
      for (var element in chatController.groupModel.value.currentUsers!) {
        memberController.memberId.add(element.sId.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CustomAppBar(
        title: 'Group Info',
        actions: [
          IconButton(
              onPressed: () {
                context.push(ChangeGroupDescription(
                  groupId: widget.groupId,
                ));
              },
              icon: const Icon(
                Icons.edit,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.kDefaultPadding * 2),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          if (chatController.groupModel.value.groupImage != null &&
                              chatController.groupModel.value.groupImage!.isNotEmpty) {
                            doNavigator(
                                route: FullScreenImageViewer(
                                    imageUrl: chatController.groupModel.value.groupImage ?? ""),
                                context: context);
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppSizes.cardCornerRadius * 10),
                          child: Obx(() => CachedNetworkImage(
                                width: 106,
                                height: 106,
                                fit: BoxFit.cover,
                                imageUrl: chatController.groupModel.value.groupImage ?? "",
                                placeholder: (context, url) => const CircleAvatar(
                                  radius: 66,
                                  backgroundColor: AppColors.lightGrey,
                                ),
                                errorWidget: (context, url, error) => CircleAvatar(
                                  radius: 66,
                                  backgroundColor: AppColors.lightGrey,
                                  child: Obx(
                                    () => Text(
                                      chatController.groupModel.value.groupName
                                          .toString()
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ),
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              showCustomBottomSheet(
                                  context,
                                  '',
                                  SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
                                        itemCount: imagePickerList.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              switch (index) {
                                                case 0:
                                                  chatController.pickImage(
                                                      imageSource: ImageSource.gallery,
                                                      groupId: widget.groupId,
                                                      context: context);
                                                  //  pickImageFromGallery();
                                                  break;
                                                case 1:
                                                  chatController.pickImage(
                                                      imageSource: ImageSource.camera,
                                                      groupId: widget.groupId,
                                                      context: context);
                                                  // pickImageFromCamera();
                                                  break;
                                              }
                                              Navigator.pop(context);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: AppSizes.kDefaultPadding * 2),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    height: 60,
                                                    padding: const EdgeInsets.all(
                                                        AppSizes.kDefaultPadding),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1, color: AppColors.lightGrey),
                                                        color: AppColors.white,
                                                        shape: BoxShape.circle),
                                                    child: imagePickerList[index].icon,
                                                  ),
                                                  const SizedBox(
                                                    height: AppSizes.kDefaultPadding / 2,
                                                  ),
                                                  Text(
                                                    '${imagePickerList[index].title}',
                                                    style: Theme.of(context).textTheme.bodyMedium,
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
                              padding: const EdgeInsets.all(AppSizes.kDefaultPadding / 1.3),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: AppColors.lightGrey),
                                  color: AppColors.white,
                                  shape: BoxShape.circle),
                              child: Obx(() => chatController.isUpdateLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator.adaptive(
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : Image.asset(
                                      AppImages.cameraIcon,
                                      width: 36,
                                      height: 36,
                                      fit: BoxFit.contain,
                                    )),
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: AppSizes.kDefaultPadding,
                  ),
                  Obx(() => chatController.isDetailsLaoding.value
                      ? ShimmerEffectForTexTWidget(
                          textName: "Loading...",
                          baseColor: Colors.grey.shade400,
                          highlightColor: Colors.grey.shade200,
                        )
                      : Text(
                          chatController.groupModel.value.groupName ?? "",
                          style: Theme.of(context).textTheme.titleLarge,
                        )),
                  const SizedBox(
                    height: AppSizes.kDefaultPadding / 2,
                  ),
                  Obx(() => Text(
                        'Group  ${chatController.groupModel.value.currentUsers?.length} People',
                        style: Theme.of(context).textTheme.bodySmall,
                      )),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: CustomCard(
                margin: const EdgeInsets.all(AppSizes.kDefaultPadding),
                padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Group Description',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: AppSizes.kDefaultPadding,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() => Text(
                                chatController.groupModel.value.groupDescription ?? "",
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: AppColors.black),
                              )),
                        ),
                        const Icon(
                          EvaIcons.arrowIosForward,
                          size: 24,
                          color: AppColors.grey,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                            '${chatController.groupModel.value.currentUsers?.length} Participants',
                            style: Theme.of(context).textTheme.bodyLarge,
                          )),
                      widget.isAdmin == true
                          ? InkWell(
                              onTap: () {
                                context.push(AddMembersScreen(
                                  groupId: widget.groupId,
                                  isCameFromHomeScreen: false,
                                  existingMembersList: const [],
                                ));
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: AppColors.buttonGradientColor),
                                child: const Icon(
                                  EvaIcons.plus,
                                  size: 18,
                                  color: AppColors.white,
                                ),
                              ),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
                CustomCard(
                  margin: const EdgeInsets.all(AppSizes.kDefaultPadding),
                  padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
                  child: Obx(() => chatController.groupModel.value.currentUsers!.isNotEmpty
                      ? ListView.separated(
                          itemCount: chatController.groupModel.value.currentUsers!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            var item = chatController.groupModel.value.currentUsers![index];

                            return ParticipantsCardWidget(
                                member: item,
                                creatorId: item.sId,
                                userType: item.userType ?? "",
                                onDeleteButtonPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // return alert dialog
                                      return Obx(() => DeleteMemberAlertDialog(
                                            isLoading: memberController.isDeleteWaiting.value,
                                            onDelete: () async {
                                              await memberController
                                                  .deleteUserFromGroup(
                                                      groupId: widget.groupId,
                                                      userId: item.sId.toString(),
                                                      userName: item.name ?? "")
                                                  .then((val) async {
                                                await chatController.getGroupDetailsById(
                                                    groupId: widget.groupId);
                                                for (var element in chatController
                                                    .groupModel.value.currentUsers!) {}
                                                Navigator.pop(context);
                                              });
                                            },
                                          ));
                                    },
                                  );
                                });
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Padding(
                              padding: EdgeInsets.only(left: 42),
                              child: CustomDivider(),
                            );
                          },
                        )
                      : const SizedBox.shrink()),
                ),
              ],
            ),
            const SizedBox(
              height: AppSizes.kDefaultPadding,
            ),
          ],
        ),
      ),
    );
  }
}
