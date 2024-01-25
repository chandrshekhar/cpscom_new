import 'package:cpscom_admin/Widgets/custom_text_field.dart';
import 'package:cpscom_admin/Widgets/full_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Commons/app_colors.dart';
import '../../../Commons/app_icons.dart';
import '../../../Commons/app_sizes.dart';
import '../../../Commons/app_strings.dart';
import '../Controller/change_password.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key, this.userEmail});

  final String? userEmail;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final changePasswordController = Get.put(ChangePasswordController());
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: AppSizes.kDefaultPadding,
                    ),
                    Text("Change your password",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.w400,
                            )),
                    // const SizedBox(height: AppSizes.kDefaultPadding * 5),
                    // CustomTextField(
                    //   controller: changePasswordController
                    //       .onlPasswordController.value,
                    //   hintText: 'Enter old password',
                    //   keyboardType: TextInputType.emailAddress,
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'required';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    const SizedBox(
                      height: AppSizes.kDefaultPadding * 5,
                    ),
                    Obx(() => CustomTextField(
                          suffixIcon: InkWell(
                              onTap: () {
                                changePasswordController.showPass(
                                    !changePasswordController
                                        .showPassword.value);
                              },
                              child: changePasswordController.showPassword.value
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility)),
                          obscureText:
                              changePasswordController.showPassword.value,
                          controller: changePasswordController
                              .newPasswordController.value,
                          hintText: 'Enter new password',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'required';
                            }
                            return null;
                          },
                        )),
                    const SizedBox(
                      height: AppSizes.kDefaultPadding * 2,
                    ),
                    Obx(() => CustomTextField(
                          suffixIcon: InkWell(
                              onTap: () {
                                changePasswordController.showCnf(
                                    !changePasswordController
                                        .showCnfPass.value);
                              },
                              child: changePasswordController.showCnfPass.value
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility)),
                          obscureText:
                              changePasswordController.showCnfPass.value,
                          controller: changePasswordController
                              .cnfPasswordController.value,
                          hintText: 'Enter cnf password',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'required';
                            }
                            return null;
                          },
                        )),
                  ],
                ),
              ),
            ),
            Obx(
              () => changePasswordController.isChangingPassword.value == true
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : FullButton(
                      label: 'Save',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          changePasswordController.changePassword(
                              context, userEmail ?? "");
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
