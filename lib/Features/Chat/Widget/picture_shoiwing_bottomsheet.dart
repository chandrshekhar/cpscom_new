import 'dart:io';

import 'package:cpscom_admin/Features/Chat/Controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Widgets/full_button.dart';

void pictureBottomSheet(
    BuildContext context, List<File> images, Future<void> Function() onUploadComplete,) {
  final PageController pageController = PageController();
  final chatController = Get.put(ChatController());
  int currentIndex = 0; // Track the currently selected image

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
              children: [
                const Text(
                  'Image Preview',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    onPageChanged: (index) {
                      // Update the current index when swiping the image
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Image.file(images[index]);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(images.length, (index) {
                      return Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              // Update the main image when the thumbnail is tapped
                              setState(() {
                                currentIndex = index;
                              });
                              pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: currentIndex == index
                                      ? Colors.blue
                                      : Colors
                                          .transparent, // Highlight selected image
                                  width: 1,
                                ),
                              ),
                              height: 50,
                              width: 50,
                              child:
                                  Image.file(images[index], fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                            child: GestureDetector(
                              onTap: () {
                                // Delete image from the list
                                setState(() {
                                  images.removeAt(index);
                                  // Update the current index if necessary
                                  if (currentIndex >= images.length) {
                                    currentIndex = images.length - 1;
                                  }
                                  pageController.jumpToPage(currentIndex);
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => chatController.isSendSmsLoading.value
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : FullButton(label: 'Send Images', onPressed: ()async{
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
