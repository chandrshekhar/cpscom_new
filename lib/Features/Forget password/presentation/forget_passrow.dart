import 'package:cpscom_admin/Widgets/custom_text_field.dart';
import 'package:cpscom_admin/Widgets/full_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Commons/app_colors.dart';
import '../../../Commons/app_icons.dart';
import '../../../Commons/app_sizes.dart';
import '../../../Commons/app_strings.dart';
import '../Controller/forget_password_controller.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final forgetPasswordController = Get.put(ForgetPasswordControler());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                size: 25,
              ))
        ],
        title: Row(
          children: [
            Image.asset(
              AppIcons.appLogo,
              width: 24,
              height: 24,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: AppSizes.kDefaultPadding / 2,
            ),
            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.kDefaultPadding * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: AppSizes.kDefaultPadding,
                    ),
                    Text(
                      'Welcome Back!',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: AppSizes.kDefaultPadding / 2,
                    ),
                    Text("Otp sent to Your mail id :",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 15)),
                    Text(
                      ' ${forgetPasswordController.forgetemailController.value.text ?? ''}',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                      height: AppSizes.kDefaultPadding * 6,
                    ),
                    Form(
                      key: _formKey,
                      child: CustomTextField(
                        controller:
                            forgetPasswordController.otpController.value,
                        labelText: 'Enter otp',
                        maxLength: 6,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.toString().length < 6) {
                            return 'OTP must have at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => forgetPasswordController.verifyingOtp.value == true
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : FullButton(
                      label: 'Verify otp',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          forgetPasswordController.verifyOtp(context);
                        }
                      }),
            ),
            const SizedBox(
              height: AppSizes.kDefaultPadding,
            ),
          ],
        ),
      ),
    );
  }
}
