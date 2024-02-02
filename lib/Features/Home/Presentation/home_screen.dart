import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/Home/Controller/group_list_controller.dart';
import 'package:cpscom_admin/Features/Home/Model/group_list_model.dart';
import 'package:cpscom_admin/Features/Home/Presentation/build_mobile_view.dart';
import 'package:cpscom_admin/Features/Home/Widgets/home_chat_card.dart';
import 'package:cpscom_admin/Features/Home/Widgets/home_header.dart';
import 'package:cpscom_admin/Widgets/custom_divider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Utils/date_format.dart';
import '../../../Widgets/custom_text_field.dart';
import '../../../Widgets/responsive.dart';
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    loginController.getUserProfile();
    groupListController.getGroupList();
    // TODO: implement initState
    super.initState();
  }

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
                  onChanged: (value) {
                    // setState(() {
                    //   groupName = value!;
                    //   groupDesc = value;
                    // });
                    return null;
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
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : ListView.builder(
                      itemCount: groupListController.groupList.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                          top: AppSizes.kDefaultPadding / 2),
                      itemBuilder: (context, index) {
                        var item = groupListController.groupList[index];
                        return HomeChatCard(
                            groupId: "Group id",
                            onPressed: () {
                              // context.push(ChatScreen(
                              //   groupId: finalGroupList[index].id,
                              //   isAdmin: widget.isAdmin,
                              // ));
                            },
                            groupName: item.groupName ?? "",
                            groupDesc: item.createdAt ?? "",
                            sentTime: item.lastMessage != null &&
                                    item.lastMessage!.createdAt!.isNotEmpty
                                ? dateFromatter(
                                    dateFormat: "h:mm a",
                                    dateTimeAsString:
                                        item.lastMessage!.timestamp.toString())
                                : "",
                            sendBy: item.lastMessage != null
                                ? item.lastMessage!.senderName ?? ""
                                : "",
                            lastMsg: item.lastMessage != null
                                ? item.lastMessage?.message ?? ""
                                : "",
                            imageUrl: item.groupImage ?? "",
                            child: memberWidget(item.currentUsers ?? []));
                      },
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
              itemCount: membersList.length,
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
        ],
      ),
    );
  }
}
