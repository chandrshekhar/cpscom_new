import 'dart:io';

import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:cpscom_admin/Widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Widgets/full_button.dart';
import '../../../AddMembers/Controller/group_create_controller.dart';
import '../../../Chat/Controller/chat_controller.dart';

class ChangeGroupDescription extends StatefulWidget {
  final String groupId;

  const ChangeGroupDescription({Key? key, required this.groupId})
      : super(key: key);

  @override
  State<ChangeGroupDescription> createState() => _ChangeGroupDescriptionState();
}

class _ChangeGroupDescriptionState extends State<ChangeGroupDescription> {
  final TextEditingController descController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final chatController = Get.put(ChatController());
  final memberController = Get.put(MemeberlistController());

  @override
  void initState() {
    //descController.text = widget.groupId['group_description'];
    super.initState();
    getDetails();
  }

  getDetails() async {
    await Future.delayed(const Duration(milliseconds: 200), () {
      chatController.getGroupDetailsById(groupId: widget.groupId);
      chatController.setControllerValue();
      // for (var element in chatController.groupModel.value.currentUsers!) {
      //   memberController.memberList.add(MemberListMdoel(
      //       sId: element.sId ?? "",
      //       name: element.name ?? "",
      //       phone: element.phone ?? "",
      //       image: element.image ?? ""));
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: AppColors.shimmer,
        appBar: const CustomAppBar(
          title: 'Group Description',
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 20, right: 10, left: 10),
                      child: Obx(() => CustomTextField(
                            controller: chatController.titleController.value,
                            maxLines: 1,
                            labelText: "Add Title",
                          )),
                    ),
                  ],
                ),
              ),
              Obx(() => chatController.isUpdateLoading.value
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : FullButton(
                      label: 'Ok'.toUpperCase(),
                      onPressed: () {
                        chatController.updateGroup(
                            context: context,
                            groupId: widget.groupId,
                            groupName: chatController.titleController.value.text
                                .toString(),
                            groupImage: File(""));
                      })),
              Container(
                alignment: Alignment.center,
                child: TextButton(
                    style: TextButton.styleFrom(
                        maximumSize:
                            const Size.fromHeight(AppSizes.buttonHeight)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    )),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
