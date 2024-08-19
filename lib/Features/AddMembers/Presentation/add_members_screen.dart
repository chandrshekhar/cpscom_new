import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/AddMembers/Controller/group_create_controller.dart';
import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:cpscom_admin/Features/CreateNewGroup/Presentation/create_new_group_screen.dart';
import 'package:cpscom_admin/Utils/storage_service.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_floating_action_button.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../Widgets/custom_smartrefresher_fotter.dart';
import '../../../Widgets/custom_text_field.dart';
import '../../../Widgets/shimmer_effetct.dart';

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
  final chatController = Get.put(ChatController());

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    memberListController.limit.value = 20;
    widget.groupId!.isNotEmpty
        ? WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            memberListController.searchText.value = "";
            memberListController.memberId.clear();
            chatController.getGroupDetailsById(groupId: widget.groupId!);
            for (var element in chatController.groupModel.value.currentUsers!) {
              memberListController.memberId.add(element.sId.toString());
            }
            memberListController.memberId.refresh();
          })
        : null;
    widget.groupId!.isNotEmpty
        ? null
        : memberListController.dataClearAfterAdd();
    memberListController.searchText.value = "";
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
                        memberListController.searchText.value = val.toString();
                        EasyDebounce.debounce(
                            'add-member-list', // <-- An ID for this particular debouncer
                            const Duration(
                                milliseconds: 200), // <-- The debounce duration
                            () async {
                          await memberListController.getMemberList();
                        } // <-- The target method
                            );

                        return;
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: Obx(() => memberListController.isMemberListLoading.value
                    ? const ShimmerEffectLaoder(
                        numberOfWidget: 20,
                      )
                    : memberListController.memberList.value.isNotEmpty
                        ? SmartRefresher(
                            controller: _refreshController,
                            enablePullDown: false,
                            enablePullUp: true,
                            onLoading: () async {
                              memberListController.limit.value += 20;
                              memberListController.getMemberList(
                                  isLoaderShowing: false);
                              _refreshController.loadComplete();
                            },
                            footer: const CustomFooterWidget(),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: memberListController.memberList.length,
                              padding: const EdgeInsets.only(
                                  bottom: AppSizes.kDefaultPadding * 9),
                              itemBuilder: (context, index) {
                                //for search members
                                var data =
                                    memberListController.memberList[index];
                                return Obx(() => CheckboxListTile(
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 20, left: 20, right: 20),
                                    title: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                              backgroundColor:
                                                  AppColors.shimmer,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    CircleAvatar(
                                              radius: 16,
                                              backgroundColor:
                                                  AppColors.shimmer,
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
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.name ?? "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                data.email ?? "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    value: data.sId.toString() ==
                                            LocalStorage()
                                                .getUserId()
                                                .toString()
                                        ? memberListController
                                            .isUserChecked.value
                                        : memberListController.memberId.value
                                            .contains(data.sId),
                                    onChanged: (value) {
                                      memberListController.checkBoxTrueFalse(
                                          value,
                                          data.sId!,
                                          data,
                                          widget.groupId!);
                                    }));
                              },
                            ),
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
              ? memberListController.addingGroup.value
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : CustomFloatingActionButton(
                      onPressed: () {
                        if (widget.isCameFromHomeScreen == true) {
                          context.push(const CreateNewGroupScreen());
                        } else {
                          memberListController.addGroupMember(
                              groupId: widget.groupId!,
                              userId: memberListController.updateMemberId,
                              context: context);
                        }
                      },
                      iconData: EvaIcons.arrowForwardOutline,
                    )
              : const SizedBox(),
        ));
  }
}
