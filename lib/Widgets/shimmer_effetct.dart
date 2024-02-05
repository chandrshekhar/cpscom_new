import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffectLaoder extends StatelessWidget {
  final int numberOfWidget;
  const ShimmerEffectLaoder({super.key, required this.numberOfWidget});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ttb,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 20),
        itemCount: numberOfWidget, // Number of shimmering items
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ListTile(
              trailing: const Text(""),
              leading: const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
              ),
              title: Container(
                width: double.infinity,
                height: 40.0,
                color: Colors.white, // Background color of shimmering item
              ),
            ),
          );
        },
      ),
    );
  }
}
