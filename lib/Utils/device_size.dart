import 'package:flutter/material.dart';

bool isMobile(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  double threshold = 600.0;
  return screenWidth <= threshold && screenHeight <= threshold;
}

bool isTab(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  double threshold = 600.0;
  return screenWidth > threshold || screenHeight > threshold;
}
