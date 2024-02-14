import 'package:cpscom_admin/Widgets/custom_text_field.dart';
import 'package:cpscom_admin/Widgets/full_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Commons/app_colors.dart';
import '../../../Commons/app_icons.dart';
import '../../../Commons/app_sizes.dart';
import '../../../Commons/app_strings.dart';
import '../Controller/forget_password_controller.dart';

class ResetPasswordPasswordScreen extends StatelessWidget {
  ResetPasswordPasswordScreen({super.key});

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
                () => Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: AppSizes.kDefaultPadding,
                      ),
                      Text("Reset your password",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w400,
                                  )),
                      const SizedBox(height: AppSizes.kDefaultPadding * 5),
                      CustomTextField(
                        controller: forgetPasswordController.password.value,
                        labelText: 'Enter password',
                        obscureText:
                            forgetPasswordController.isPasswordVsible.value,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: AppSizes.kDefaultPadding * 2,
                      ),
                      CustomTextField(
                        controller: forgetPasswordController.cnfPassword.value,
                        labelText: 'Enter confirm password',
                        obscureText:
                            forgetPasswordController.isPasswordVsible.value,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() => CheckboxListTile.adaptive(
                            title: const Text("Show password"),
                            value:
                                forgetPasswordController.isPasswordVsible.value,
                            onChanged: (v) {
                              forgetPasswordController.isPasswordVsible.value =
                                  v!;
                            },
                          ))
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => forgetPasswordController.isPasswordReseting.value == true
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : FullButton(
                      label: 'Reset',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          forgetPasswordController.resetPassword(context);
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
