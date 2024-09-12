import 'dart:io';

import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Widgets/full_button.dart';

void docsModelBottomSheet(
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
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Docs View',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      video.path.split("/").last,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() => chatController.isSendSmsLoading.value
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : FullButton(
                        label: 'Send Docs',
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
