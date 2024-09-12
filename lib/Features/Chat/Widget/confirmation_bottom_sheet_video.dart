import 'dart:io';

import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Widgets/custom_video_player.dart';
import '../../../Widgets/full_button.dart';

void videoBottomSheet(
  BuildContext context,
  File video,
  Future<void> Function() onUploadComplete,
) {
  final chatController = Get.put(ChatController());

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  'Video Preview',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: CustomVideoPlayer(
                    file: chatController.videoFile.value ?? File(""),
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() => chatController.isSendSmsLoading.value
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : FullButton(
                        label: 'Send Video',
                        onPressed: () async {
                          await onUploadComplete();
                          Navigator.pop(context);
                        })),
              ],
            ),
          );
        },
      );
    },
  );
}
