import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_sizes.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: false,
      dividerColor: AppColors.grey,
      brightness: Brightness.light,
      cardColor: AppColors.white,
      primaryColor: AppColors.primary,
      hintColor: AppColors.darkGrey,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: AppSizes.elevation5, backgroundColor: AppColors.primary),
      appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            size: AppSizes.appBarIconSize,
            color: AppColors.black,
          ),
          backgroundColor: AppColors.white,
          elevation: AppSizes.elevation0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.black,
            fontSize: AppSizes.bodyText1,
            fontWeight: FontWeight.w500,
            //    fontFamily: FontFamily.poppinsRegular
          ),
          foregroundColor: AppColors.black),
      progressIndicatorTheme: ProgressIndicatorThemeData(
          color: AppColors.primary.withOpacity(0.7)),
      checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppSizes.kDefaultPadding * 5))),
      scaffoldBackgroundColor: AppColors.scaffold,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      tabBarTheme: const TabBarTheme(
        labelStyle: TextStyle(fontWeight: FontWeight.w600),
        labelColor: AppColors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        unselectedLabelColor: AppColors.lightGrey,
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: AppColors.primary)),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            color: AppColors.black,
            fontSize: AppSizes.headline1,
            fontWeight: FontWeight.w700),
        displayMedium: TextStyle(
            color: AppColors.black,
            fontSize: AppSizes.headline2,
            fontWeight: FontWeight.w700),
        displaySmall: TextStyle(
            color: AppColors.black,
            fontSize: AppSizes.headline3,
            fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(
            color: AppColors.black,
            fontSize: AppSizes.headline4,
            fontWeight: FontWeight.w700),
        headlineSmall: TextStyle(
            color: AppColors.black,
            fontSize: AppSizes.headline5,
            fontWeight: FontWeight.w600),
        titleLarge: TextStyle(
            color: AppColors.black,
            fontSize: AppSizes.headline6,
            fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(
            color: AppColors.black,
            fontSize: AppSizes.bodyText1,
            fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(
            color: AppColors.darkGrey,
            fontSize: AppSizes.bodyText2,
            fontWeight: FontWeight.w400),
        bodySmall: TextStyle(
            color: AppColors.darkGrey,
            fontSize: AppSizes.caption,
            fontWeight: FontWeight.w400),
        labelLarge: TextStyle(
            color: AppColors.white,
            fontSize: AppSizes.button,
            fontWeight: FontWeight.w600),
      ), colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.generateMaterialColor(AppColors.primary)).copyWith(background: AppColors.white),
      //fontFamily: FontFamily.poppinsRegular,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        background: AppColors.black,
        primary: Colors.grey[900]!,
        secondary: Colors.grey[800]!
      )
    );
  }
}
