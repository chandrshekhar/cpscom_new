import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:cpscom_admin/Features/Home/Controller/group_list_controller.dart';
import 'package:cpscom_admin/Features/Home/Controller/socket_controller.dart';
import 'package:cpscom_admin/Features/Home/Model/group_list_model.dart';
import 'package:cpscom_admin/Features/Home/Presentation/build_mobile_view.dart';
import 'package:cpscom_admin/Features/Home/Widgets/home_chat_card.dart';
import 'package:cpscom_admin/Features/Home/Widgets/home_header.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../Widgets/custom_smartrefresher_fotter.dart';
import '../../../Widgets/custom_text_field.dart';
import '../../../Widgets/responsive.dart';
import '../../../Widgets/shimmer_effetct.dart';
import '../../Chat/Presentation/chat_screen.dart';
import '../../Login/Controller/login_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  bool commingFromChat = false;

  @override
  Widget build(BuildContext context) {
    return const BuildMobileView();
  }
}

class BuildChatList extends StatefulWidget {
  final bool isAdmin;

  const BuildChatList({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<BuildChatList> createState() => _BuildChatListState();
}

class _BuildChatListState extends State<BuildChatList> {
  final TextEditingController searchController = TextEditingController();
  final groupListController = Get.put(GroupListController());
  final loginController = Get.put(LoginController());
  final chatController = Get.put(ChatController());
  final socketController = Get.put(SocketController());

  @override
  @override
  void initState() {
    groupListController.limit.value = 100;
    callAfterDelay();
    super.initState();
  }

  callAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 200), () {
      loginController.getUserProfile();
      groupListController.getGroupList();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Responsive.isMobile(context)
            ? const HomeHeader(
                groupsList: ["Group list"],
              )
            : const HomeHeader(
                groupsList: ["Group list"],
              ),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSizes.kDefaultPadding),
          margin:
              const EdgeInsets.symmetric(horizontal: AppSizes.kDefaultPadding),
          decoration: BoxDecoration(
              color: AppColors.bg,
              border: Border.all(width: 1, color: AppColors.bg),
              borderRadius: BorderRadius.circular(AppSizes.cardCornerRadius)),
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
                  hintText: 'Search groups...',
                  minLines: 1,
                  maxLines: 1,
                  onChanged: (value) async {
                    groupListController.searchText.value = value.toString();
                    EasyDebounce.debounce(
                        'group-debounce', // <-- An ID for this particular debouncer
                        const Duration(
                            milliseconds: 200), // <-- The debounce duration
                        () async {
                      await groupListController.getGroupList();
                    } // <-- The target method
                        );
                  },
                  isBorder: false,
                ),
              )
            ],
          ),
        ),
        Responsive.isMobile(context) ? const SizedBox() : const CustomDivider(),
        Expanded(
          child: Scrollbar(
            child: Obx(
              () => groupListController.isGroupLiastLoading.value
                  ? const ShimmerEffectLaoder(
                      numberOfWidget: 20,
                    )
                  : groupListController.groupList.isNotEmpty
                      ? SmartRefresher(
                          controller: _refreshController,
                          enablePullDown: false,
                          enablePullUp: true,
                          onLoading: () async {
                            groupListController.limit.value += 2;
                            groupListController.getGroupList(
                                isLoadingShow: false);
                            _refreshController.loadComplete();
                          },
                          footer: const CustomFooterWidget(),
                          child: Obx(() => ListView.builder(
                                itemCount:
                                    groupListController.groupList.value.length,
                                shrinkWrap: false,
                                // padding: const EdgeInsets.only(
                                //     top: AppSizes.kDefaultPadding / 2),
                                itemBuilder: (context, index) {
                                  var item = groupListController
                                      .groupList.value[index];
                                  return HomeChatCard(
                                      messageCount: item.unreadCount,
                                      groupId: item.sId.toString(),
                                      onPressed: () {
                                        chatController.timeStamps.value =
                                            DateTime.now()
                                                .millisecondsSinceEpoch;
                                        context.push(ChatScreen(
                                          groupId: item.sId.toString(),
                                          isAdmin: widget.isAdmin,
                                          index: index,
                                          // groupModel: item,
                                        ));
                                        groupListController
                                            .groupList[index].unreadCount = 0;
                                        groupListController.groupList.refresh();
                                      },
                                      groupName: item.groupName ?? "",
                                      groupDesc: item.createdAt ?? "",
                                      sentTime: item.lastMessage != null &&
                                              item.lastMessage!.createdAt!
                                                  .isNotEmpty
                                          ? DateFormat('hh:mm a').format(
                                              DateTime.parse(item.lastMessage
                                                          ?.timestamp ??
                                                      "")
                                                  .toLocal())
                                          : "",
                                      sendBy: item.lastMessage != null
                                          ? item.lastMessage!.senderName ?? ""
                                          : "",
                                      lastMsg: item.lastMessage != null
                                          ? item.lastMessage?.message ?? ""
                                          : "",
                                      imageUrl: item.groupImage ?? "",
                                      messageType: item.lastMessage != null
                                          ? item.lastMessage?.messageType ?? ""
                                          : "",
                                      child:
                                          memberWidget(item.currentUsers ?? []));
                                },
                              )),
                        )
                      : const Center(
                          child: Text("No group found"),
                        ),
            ),
          ),
        ),
      ],
    );
  }

  Widget memberWidget(List<CurrentUsers> membersList) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListView.builder(
              itemCount: membersList.length < 3 ? membersList.length : 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Align(
                      widthFactor: 0.3,
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              AppSizes.cardCornerRadius * 10),
                          child: CachedNetworkImage(
                            width: 26,
                            height: 26,
                            fit: BoxFit.cover,
                            imageUrl: membersList[index].image ?? "",
                            placeholder: (context, url) => const CircleAvatar(
                              radius: 26,
                              backgroundColor: AppColors.shimmer,
                            ),
                            errorWidget: (context, url, error) => CircleAvatar(
                              radius: 26,
                              backgroundColor: AppColors.shimmer,
                              child: Text(
                                membersList[index]
                                    .name
                                    .toString()[0]
                                    .toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
          membersList.length > 3
              ? Align(
                  widthFactor: 0.6,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.lightGrey,
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: AppColors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: FittedBox(
                          child: Text(
                            '+${membersList.length - 3}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: AppColors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
