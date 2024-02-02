import 'package:cpscom_admin/Commons/app_icons.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/Home/Presentation/home_screen.dart';
import 'package:cpscom_admin/Utils/app_preference.dart';
import 'package:cpscom_admin/Utils/storage_service.dart';
import 'package:flutter/material.dart';

import '../../Welcome/Presentation/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AppPreference preference = AppPreference();
  String token = "";

  @override
  void initState() {
    getUserTokenData();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => token.isNotEmpty
                  ? const HomeScreen()
                  : const WelcomeScreen()));
    });

    super.initState();
  }

  getUserTokenData() {
    var userToken = LocalStorage().getUserToken();
    setState(() {
      token = userToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppIcons.appLogo,
              width: 90,
              height: 90,
            ),
            const SizedBox(
              height: AppSizes.kDefaultPadding,
            ),
            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
        ),
      ),
    );
  }
}
