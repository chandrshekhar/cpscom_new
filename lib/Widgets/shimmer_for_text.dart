import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffectForTexTWidget extends StatelessWidget {
  final String textName;
  Color? baseColor, highlightColor;
  ShimmerEffectForTexTWidget(
      {super.key, required this.textName, this.baseColor, this.highlightColor});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.shade300,
      highlightColor: highlightColor ?? Colors.grey.shade100,
      child: Text(
        textName,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
