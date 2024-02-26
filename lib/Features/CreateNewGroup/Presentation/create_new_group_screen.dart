import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Commons/app_images.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/AddMembers/Controller/group_create_controller.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_card.dart';
import 'package:cpscom_admin/Widgets/custom_text_field.dart';
import 'package:cpscom_admin/Widgets/toast_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Utils/custom_bottom_modal_sheet.dart';
import '../../../Widgets/custom_floating_action_button.dart';
import '../../GroupInfo/Model/image_picker_model.dart';

class CreateNewGroupScreen extends StatefulWidget {
  const CreateNewGroupScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateNewGroupScreen> createState() => _CreateNewGroupScreenState();
}

class _CreateNewGroupScreenState extends State<CreateNewGroupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final memberListController = Get.put(MemeberlistController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          backgroundColor: AppColors.bg,
          appBar: const CustomAppBar(
            title: 'Create New Group',
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: AppSizes.kDefaultPadding,
                ),
                Center(
                  child: Stack(
                    children: [
                      Obx(() => CircleAvatar(
                            radius: 56,
                            backgroundColor: AppColors.lightGrey,
                            child: memberListController.images.value.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.cardCornerRadius * 10),
                                    child: Image.file(
                                      File(memberListController.images.value),
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height: 150,
                                    ))
                                : Image.asset(
                                    AppImages.groupAvatar,
                                    fit: BoxFit.contain,
                                    width: 50,
                                    height: 50,
                                  ),
                          )),
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
                                      padding: const EdgeInsets.all(
                                          AppSizes.kDefaultPadding),
                                      itemCount: imagePickerList.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            switch (index) {
                                              case 0:
                                                memberListController.pickImage(
                                                    imageSource:
                                                        ImageSource.gallery);
                                                break;
                                              case 1:
                                                memberListController.pickImage(
                                                    imageSource:
                                                        ImageSource.camera);
                                                break;
                                            }
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: AppSizes.kDefaultPadding *
                                                    2),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 60,
                                                  height: 60,
                                                  padding: const EdgeInsets.all(
                                                      AppSizes.kDefaultPadding),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1,
                                                          color: AppColors
                                                              .lightGrey),
                                                      color: AppColors.white,
                                                      shape: BoxShape.circle),
                                                  child: imagePickerList[index]
                                                      .icon,
                                                ),
                                                const SizedBox(
                                                  height:
                                                      AppSizes.kDefaultPadding /
                                                          2,
                                                ),
                                                Text(
                                                  '${imagePickerList[index].title}',
                                                  style: Theme.of(context)
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
                                    width: 1, color: AppColors.lightGrey),
                                color: AppColors.white,
                                shape: BoxShape.circle),
                            child: Image.asset(
                              AppImages.cameraIcon,
                              width: 36,
                              height: 36,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSizes.kDefaultPadding * 2,
                ),
                CustomCard(
                  margin: const EdgeInsets.symmetric(
                      horizontal: AppSizes.kDefaultPadding),
                  padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Group Title',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: AppColors.black),
                      ),
                      Obx(() => CustomTextField(
                            controller:
                                memberListController.grpNameController.value,
                            hintText: 'Group Name',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Group name can\'t be empty';
                              }
                              return null;
                            },
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSizes.kDefaultPadding,
                ),
                CustomCard(
                  margin: const EdgeInsets.symmetric(
                      horizontal: AppSizes.kDefaultPadding),
                  padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Group Description',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: AppColors.black),
                      ),
                      const SizedBox(
                        height: AppSizes.kDefaultPadding,
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.kDefaultPadding,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  AppSizes.cardCornerRadius / 2),
                              border: Border.all(
                                  width: 1, color: AppColors.lightGrey)),
                          child: Obx(() => CustomTextField(
                                controller: memberListController
                                    .grpDescController.value,
                                hintText: 'Add Group Description (optional)',
                                minLines: 5,
                                maxLines: 5,
                              ))),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSizes.kDefaultPadding * 2,
                ),
                SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(
                          AppSizes.kDefaultPadding,
                        ),
                        child: Obx(() => Text(
                              '${memberListController.memberSelectedList.value.length} Participants',
                              style: Theme.of(context).textTheme.bodyLarge,
                            )),
                      ),
                      Expanded(
                          child: Obx(() => ListView.builder(
                              itemCount: memberListController
                                  .memberSelectedList.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: AppSizes.kDefaultPadding),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                AppSizes.cardCornerRadius * 10),
                                            child: CachedNetworkImage(
                                                width: 56,
                                                height: 56,
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    '${memberListController.memberSelectedList[index].image}',
                                                placeholder: (context, url) =>
                                                    const CircleAvatar(
                                                      radius: 40,
                                                      backgroundColor:
                                                          AppColors.lightGrey,
                                                    ),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    CircleAvatar(
                                                      radius: 40,
                                                      backgroundColor:
                                                          AppColors.lightGrey,
                                                      child: Text(
                                                        memberListController
                                                            .memberSelectedList[
                                                                index]
                                                            .name!
                                                            .substring(0, 1)
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    )),
                                          ),
                                          Positioned(
                                            left: 22,
                                            bottom: 22,
                                            child: IconButton(
                                                splashColor: Colors.transparent,
                                                onPressed: () {
                                                  memberListController
                                                      .memberSelectedList
                                                      .removeAt(index);
                                                  memberListController.memberId
                                                      .removeAt(index);
                                                },
                                                icon: const Icon(
                                                  Icons.cancel,
                                                  color: Colors.red,
                                                )),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: AppSizes.kDefaultPadding / 2,
                                      ),
                                      Text(
                                        memberListController
                                                .memberSelectedList[index]
                                                .name ??
                                            "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(color: AppColors.black),
                                      )
                                    ],
                                  ),
                                );
                              }))),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSizes.kDefaultPadding * 3,
                ),
              ],
            ),
          ),
          floatingActionButton:
              Obx(() => memberListController.isGroupCreateLoading.value
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : CustomFloatingActionButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            memberListController.memberId.isNotEmpty
                                ? await memberListController
                                    .createGroup(context)
                                : TostWidget().errorToast(
                                    title: "Error",
                                    message: "Atlest 1 member need to select");
                          } catch (e) {
                            return;
                          }
                        }
                        return;
                      },
                      iconData: EvaIcons.checkmark,
                    ))),
    );
  }
}
