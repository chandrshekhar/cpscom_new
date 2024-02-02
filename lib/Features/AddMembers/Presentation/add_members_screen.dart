import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/AddMembers/Controller/group_create_controller.dart';
import 'package:cpscom_admin/Features/CreateNewGroup/Presentation/create_new_group_screen.dart';
import 'package:cpscom_admin/Features/GroupInfo/Presentation/group_info_screen.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_floating_action_button.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Utils/custom_snack_bar.dart';
import '../../../Widgets/custom_text_field.dart';

class AddMembersScreen extends StatefulWidget {
  final String? groupId;
  final bool isCameFromHomeScreen;
  final List<dynamic>? existingMembersList;

  const AddMembersScreen(
      {Key? key,
      this.groupId,
      required this.isCameFromHomeScreen,
      this.existingMembersList})
      : super(key: key);

  @override
  State<AddMembersScreen> createState() => _AddMembersScreenState();
}

class _AddMembersScreenState extends State<AddMembersScreen> {
  final TextEditingController searchController = TextEditingController();
  final memberListController = Get.put(MemeberlistController());

  @override
  void initState() {
    super.initState();
    memberListController.dataClearAfterAdd();
    memberListController.getMemberList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Add Participants',
          actions: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.kDefaultPadding + 6),
              child: Obx(() => Text(
                  '${memberListController.memberId.length} / ${memberListController.memberList.value.length}')),
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.kDefaultPadding),
              margin: const EdgeInsets.all(AppSizes.kDefaultPadding),
              decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius:
                      BorderRadius.circular(AppSizes.cardCornerRadius)),
              child: Row(
                children: [
                  const Icon(
                    EvaIcons.searchOutline,
                    size: 22,
                    color: AppColors.grey,
                  ),
                  const SizedBox(
                    width: AppSizes.kDefaultPadding,
                  ),
                  Expanded(
                    child: CustomTextField(
                      controller: searchController,
                      hintText: 'Search participants...',
                      isBorder: false,
                      onChanged: (val) {
                        return null;
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: Obx(() => memberListController.isMemberListLoading.value
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : memberListController.memberList.isNotEmpty
                        ? ListView.separated(
                            separatorBuilder: (context, index) {
                              return const Divider(
                                height: 1, // Adjust the height of the divider
                                color: Colors.grey,
                              );
                            },
                            shrinkWrap: true,
                            itemCount: memberListController.memberList.length,
                            padding: const EdgeInsets.only(
                                bottom: AppSizes.kDefaultPadding * 9),
                            itemBuilder: (context, index) {
                              //for search members
                              var data = memberListController.memberList[index];
                              return Obx(() => CheckboxListTile(
                                  title: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            AppSizes.cardCornerRadius * 10),
                                        child: CachedNetworkImage(
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.cover,
                                          imageUrl: data.image ?? "",
                                          placeholder: (context, url) =>
                                              const CircleAvatar(
                                            radius: 16,
                                            backgroundColor: AppColors.shimmer,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              CircleAvatar(
                                            radius: 16,
                                            backgroundColor: AppColors.shimmer,
                                            child: Text(
                                              data.name!.substring(0, 1),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: AppSizes.kDefaultPadding,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.name ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                          Text(
                                            data.email ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  value: memberListController.memberId
                                      .contains(data.sId),
                                  onChanged: (value) {
                                    memberListController.checkBoxTrueFalse(
                                        value, data.sId!, data);
                                  }));
                            },
                          )
                        : const Center(
                            child: Text("No Participants found"),
                          )),
              ),
            ),
          ],
        ),
        floatingActionButton: Obx(
          () => memberListController.memberId.isNotEmpty
              ? CustomFloatingActionButton(
                  onPressed: () {
                    if (widget.isCameFromHomeScreen == true) {
                      context.push(const CreateNewGroupScreen());
                    } else {
                      // addMemberToGroup(widget.groupId!);
                      Future.delayed(
                          const Duration(seconds: 1),
                          () => context.pop(GroupInfoScreen(
                                groupId: widget.groupId!,
                              )));
                      customSnackBar(context, 'Member Added Successfully');
                    }
                  },
                  iconData: EvaIcons.arrowForwardOutline,
                )
              : const SizedBox(),
        ));
  }
}
