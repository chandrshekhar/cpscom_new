import 'package:cpscom_admin/Commons/app_icons.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/Forget%20password/Controller/forget_password_controller.dart';
import 'package:cpscom_admin/Features/Login/Controller/login_controller.dart';
import 'package:cpscom_admin/Widgets/custom_text_field.dart';
import 'package:cpscom_admin/Widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Commons/app_images.dart';
import '../../../Widgets/full_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKeyEmail = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyPass = GlobalKey<FormState>();
  final forgetpasswordController = Get.put(ForgetPasswordControler());
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context)
        ? _buildMobileView(context)
        : _buildTabletView(context);
  }

  Widget _buildMobileView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.kDefaultPadding * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: AppSizes.kDefaultPadding,
              ),
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: AppColors.black, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding / 2,
              ),
              Text(
                'Sign in to continue',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.black, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding * 6,
              ),
              Obx(
                () => Form(
                  key: _formKeyEmail,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextField(
                    controller: loginController.emailController.value,
                    labelText: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (!value!.isEmail) {
                        return 'Invalid Email Address';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding * 2,
              ),
              Obx(() => Form(
                    key: _formKeyPass,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: CustomTextField(
                      controller: loginController.passwordController.value,
                      labelText: 'Password',
                      obscureText: loginController.isPasswordVisible.value,
                      keyboardType: TextInputType.visiblePassword,
                      suffixIcon: InkWell(
                          onTap: () {
                            loginController.toggleIsPasswordVisible();
                          },
                          child: Icon(
                            loginController.isPasswordVisible.value == false
                                ? Icons.visibility
                                : Icons.visibility_off,
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Invalid Password';
                        }
                        return null;
                      },
                    ),
                  )),
              const SizedBox(
                height: AppSizes.kDefaultPadding * 1,
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {
                      if (_formKeyEmail.currentState!.validate()) {
                     
                        forgetpasswordController.sentOtp(context);
                      }
                    },
                    child: Obx(
                      () => forgetpasswordController
                                  .isForgetPasswordLoading.value ==
                              true
                          ? const CircularProgressIndicator.adaptive()
                          : Text(
                              "Forgot Password",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: AppColors.red,
                                      fontWeight: FontWeight.w400),
                            ),
                    ),
                  )),
              const SizedBox(
                height: AppSizes.kDefaultPadding * 6,
              ),
              Obx(
                () => loginController.isLoginLaoding.value
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : FullButton(
                        label: 'Login',
                        onPressed: () async {
                          if (_formKeyEmail.currentState!.validate() &&
                              _formKeyPass.currentState!.validate()) {
                            await loginController.userLogin(context: context);
                          }
                          return null;
                        }),
              ),
              const SizedBox(
                height: AppSizes.kDefaultPadding,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletView(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(AppSizes.kDefaultPadding * 2),
              decoration: const BoxDecoration(
                  color: AppColors.shimmer,
                  image: DecorationImage(
                      image: AssetImage(AppImages.welcomeBg),
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high)),
              child: Image(
                image: const AssetImage(AppImages.welcomeImage),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.8,
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppIcons.appLogo,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: AppSizes.kDefaultPadding,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.kDefaultPadding * 2,
                        horizontal: AppSizes.kDefaultPadding * 3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                        Text(
                          'Sign in to continue',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: AppSizes.kDefaultPadding * 6,
                        ),
                        Obx(
                          () => Form(
                            key: _formKeyEmail,
                            child: CustomTextField(
                              controller: loginController.emailController.value,
                              hintText: 'Email Address',
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Invalid Email Addresses';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: AppSizes.kDefaultPadding * 2,
                        ),
                        Obx(() => Form(
                              key: _formKeyPass,
                              child: CustomTextField(
                                controller:
                                    loginController.passwordController.value,
                                hintText: 'Password',
                                obscureText:
                                    loginController.isPasswordVisible.value,
                                suffixIcon: InkWell(
                                    onTap: () {
                                      loginController.toggleIsPasswordVisible();
                                    },
                                    child: Icon(
                                      loginController.isPasswordVisible.value ==
                                              false
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    )),
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Invalid Password';
                                  }
                                  return null;
                                },
                              ),
                            )),
                        const SizedBox(
                          height: AppSizes.kDefaultPadding * 5,
                        ),
                        Obx(() => loginController.isLoginLaoding.value
                            ? const Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : FullButton(
                                label: 'Login',
                                onPressed: () async {
                                  if (_formKeyEmail.currentState!.validate() &&
                                      _formKeyPass.currentState!.validate()) {
                                    await loginController.userLogin(
                                        context: context);
                                  } else {}
                                })),
                        const SizedBox(
                          height: AppSizes.kDefaultPadding,
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  // Widget _buildDesktopView(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: AppColors.lightGrey,
  //     body: Stack(
  //       children: [
  //         Container(
  //           height: MediaQuery.of(context).size.height * 0.16,
  //           width: MediaQuery.of(context).size.width,
  //           decoration:
  //               const BoxDecoration(gradient: AppColors.buttonGradientColor),
  //         ),
  //         Container(
  //           margin: EdgeInsets.symmetric(
  //               horizontal: MediaQuery.of(context).size.width * 0.1,
  //               vertical: AppSizes.kDefaultPadding * 2),
  //           child: Row(
  //             children: [
  //               Expanded(
  //                 flex: 2,
  //                 child: Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   height: MediaQuery.of(context).size.height,
  //                   padding: const EdgeInsets.all(AppSizes.kDefaultPadding * 2),
  //                   decoration: const BoxDecoration(
  //                       color: AppColors.shimmer,
  //                       image: DecorationImage(
  //                           image: AssetImage(AppImages.welcomeBg),
  //                           fit: BoxFit.cover,
  //                           filterQuality: FilterQuality.high)),
  //                   child: Image(
  //                     image: const AssetImage(AppImages.welcomeImage),
  //                     width: MediaQuery.of(context).size.width * 0.8,
  //                     height: MediaQuery.of(context).size.height * 0.8,
  //                   ),
  //                 ),
  //               ),
  //               Expanded(
  //                   flex: 2,
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Image.asset(
  //                         AppIcons.appLogo,
  //                         width: 100,
  //                         height: 100,
  //                         fit: BoxFit.cover,
  //                       ),
  //                       const SizedBox(
  //                         height: AppSizes.kDefaultPadding,
  //                       ),
  //                       Container(
  //                         width: MediaQuery.of(context).size.width,
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: AppSizes.kDefaultPadding * 2,
  //                             horizontal: AppSizes.kDefaultPadding * 3),
  //                         decoration: const BoxDecoration(
  //                           color: Colors.white,
  //                         ),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Text(
  //                               'Welcome Back!',
  //                               style: Theme.of(context)
  //                                   .textTheme
  //                                   .displayMedium!
  //                                   .copyWith(
  //                                       color: AppColors.black,
  //                                       fontWeight: FontWeight.w700),
  //                               textAlign: TextAlign.center,
  //                             ),
  //                             const SizedBox(
  //                               height: AppSizes.kDefaultPadding / 2,
  //                             ),
  //                             Text(
  //                               'Sign in to continue',
  //                               style: Theme.of(context)
  //                                   .textTheme
  //                                   .bodyLarge!
  //                                   .copyWith(
  //                                       color: AppColors.black,
  //                                       fontWeight: FontWeight.w400),
  //                               textAlign: TextAlign.center,
  //                             ),
  //                             const SizedBox(
  //                               height: AppSizes.kDefaultPadding * 6,
  //                             ),
  //                             CustomTextField(
  //                               controller:
  //                                   loginController.emailController.value,
  //                               hintText: 'Email Address',
  //                               keyboardType: TextInputType.emailAddress,
  //                               validator: (value) {
  //                                 if (value!.isEmpty) {
  //                                   return 'Invalid Email Address';
  //                                 }
  //                                 return null;
  //                               },
  //                             ),
  //                             const SizedBox(
  //                               height: AppSizes.kDefaultPadding * 2,
  //                             ),
  //                             CustomTextField(
  //                               controller:
  //                                   loginController.passwordController.value,
  //                               hintText: 'Password',
  //                               obscureText: true,
  //                               keyboardType: TextInputType.visiblePassword,
  //                               validator: (value) {
  //                                 if (value!.isEmpty) {
  //                                   return 'Invalid Password';
  //                                 }
  //                                 return null;
  //                               },
  //                             ),
  //                             const SizedBox(
  //                               height: AppSizes.kDefaultPadding * 6,
  //                             ),
  //                             FullButton(
  //                                 label: 'Login',
  //                                 onPressed: () {
  //                                   if (_formKeyEmail.currentState!
  //                                           .validate() &&
  //                                       _formKeyPass.currentState!.validate()) {
  //                                     // BlocProvider.of<LoginBloc>(context).add(
  //                                     //     LoginSubmittedEvent(
  //                                     //         email: forgetpasswordController
  //                                     //             .forgetemailController.value.text
  //                                     //             .trim(),
  //                                     //         password:
  //                                     //             passwordController.text.trim()));
  //                                   }
  //                                   return null;
  //                                 }),
  //                             const SizedBox(
  //                               height: AppSizes.kDefaultPadding,
  //                             ),
  //                             // TextButton(
  //                             //     style: TextButton.styleFrom(
  //                             //       minimumSize: const Size.fromHeight(
  //                             //           AppSizes.buttonHeight),
  //                             //     ),
  //                             //     onPressed: () {},
  //                             //     child: Text(
  //                             //       'Forgot Password?',
  //                             //       style: Theme.of(context).textTheme.bodyMedium,
  //                             //     ))
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ))
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
