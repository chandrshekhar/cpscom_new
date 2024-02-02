import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/MyProfile/Presentation/my_profile_screen.dart';
import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../Widgets/custom_text_field.dart';
import '../../../Widgets/full_button.dart';

class UpdateUserStatusScreen extends StatefulWidget {
  const UpdateUserStatusScreen({Key? key}) : super(key: key);

  @override
  State<UpdateUserStatusScreen> createState() => _UpdateUserStatusScreenState();
}

class _UpdateUserStatusScreenState extends State<UpdateUserStatusScreen> {
  final TextEditingController statusController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: const CustomAppBar(
          title: 'Enter New Status',
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.kDefaultPadding),
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Status',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: AppColors.black),
                  ),
                  const SizedBox(
                    height: AppSizes.kDefaultPadding,
                  ),
                  CustomTextField(
                    controller: statusController,
                    hintText: 'Add Status',
                    autoFocus: true,
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.kDefaultPadding * 2),
                child: Column(
                  children: [
                    FullButton(
                        label: 'Ok'.toUpperCase(),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // FirebaseFirestore.instance
                            //     .collection('users')
                            //     .doc(FirebaseAuth.instance.currentUser!.uid)
                            //     .update({"status": statusController.text}).then(
                            //         (value) {
                            //   customSnackBar(
                            //     context,
                            //     'Status Updated Successfully',
                            //   );
                            //   context.pop(const MyProfileScreen());
                            // });
                          }
                        }),
                    Container(
                      alignment: Alignment.center,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              maximumSize:
                                  const Size.fromHeight(AppSizes.buttonHeight)),
                          onPressed: () {
                            context.pop(const MyProfileScreen());
                          },
                          child: Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          )),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
