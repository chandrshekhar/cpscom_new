import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpscom_admin/Commons/commons.dart';
import 'package:cpscom_admin/Features/AddMembers/Presentation/add_members_screen.dart';
import 'package:cpscom_admin/Features/Home/Bloc/chat_screen_bloc.dart';
import 'package:cpscom_admin/Features/Login/Presentation/login_screen.dart';
import 'package:cpscom_admin/Utils/app_preference.dart';
import 'package:cpscom_admin/Widgets/custom_confirmation_dialog.dart';
import 'package:cpscom_admin/Widgets/responsive.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Api/firebase_provider.dart';
import '../../Chat/Presentation/chat_screen.dart';
import '../../MyProfile/Presentation/my_profile_screen.dart';
import 'home_screen.dart';
class BuildDesktopView extends StatefulWidget {
  const BuildDesktopView({Key? key}) : super(key: key);

  @override
  State<BuildDesktopView> createState() => _BuildDesktopViewState();
}

class _BuildDesktopViewState extends State<BuildDesktopView> {
  var future = FirebaseProvider.firestore
      .collection('users')
      .doc(FirebaseProvider.auth.currentUser!.uid)
      .get();

  bool? isAdmin;
  int? selectedIndex;

  final FirebaseProvider firebaseProvider = FirebaseProvider();
  final AppPreference preference = AppPreference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ChatScreenBloc>(context)
        .add(const ChatScreenEvent(groupId: '', isAdmin: true));
  }

  @override
  Widget build(BuildContext context) {
    return !Responsive.isDesktop(context)?const HomeScreen() :Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.16,
            width: MediaQuery.of(context).size.width,
            decoration:
                const BoxDecoration(gradient: AppColors.buttonGradientColor),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
                vertical: AppSizes.kDefaultPadding * 2),
            decoration: const BoxDecoration(
              color: AppColors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Container(
                        height: AppSizes.appBarHeight,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.kDefaultPadding),
                        decoration: const BoxDecoration(color: AppColors.bg),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StreamBuilder(
                                stream:
                                    firebaseProvider.getCurrentUserDetails(),
                                builder: (context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                      return const CircularProgressIndicator
                                          .adaptive();
                                    default:
                                      if (snapshot.hasData) {
                                        bool isAdmin = snapshot.data?['isAdmin'];
                                        return GestureDetector(
                                          onTap: () {
                                            if (Responsive.isDesktop(context)) {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(content:
                                                          StatefulBuilder(builder:
                                                              (BuildContext
                                                                      context,
                                                                  StateSetter
                                                                      setState) {
                                                        return const SizedBox(
                                                          width: 600,
                                                          child:
                                                              MyProfileScreen(),
                                                        );
                                                      }));
                                                    });
                                            
                                            } else {
                                              context.push(
                                                  const MyProfileScreen());
                                            }
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                AppSizes.cardCornerRadius * 10),
                                            child: CachedNetworkImage(
                                                width: 34,
                                                height: 34,
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    '${snapshot.data?['profile_picture']}',
                                                placeholder: (context, url) =>
                                                    const CircleAvatar(
                                                      radius: 16,
                                                      backgroundColor:
                                                          AppColors.bg,
                                                    ),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    CircleAvatar(
                                                      radius: 16,
                                                      backgroundColor:
                                                          AppColors.bg,
                                                      child: Text(
                                                        snapshot.data!['name']
                                                            .substring(0, 1)
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    )),
                                          ),
                                        );
                                      }
                                  }
                                  return const SizedBox();
                                }),
                            PopupMenuButton(
                              position: PopupMenuPosition.under,
                              icon: const Icon(
                                EvaIcons.moreVerticalOutline,
                                size: 22,
                                color: AppColors.darkGrey,
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 1,
                                    child: Text(
                                      'New Group',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    )),
                                PopupMenuItem(
                                    value: 2,
                                    child: Text(
                                      'Logout',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    )),
                              ],
                              onSelected: (value) {
                                switch (value) {
                                  case 1:
                                    Responsive.isDesktop(context)
                                        ? showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(content:
                                                  StatefulBuilder(builder:
                                                      (BuildContext context,
                                                          StateSetter
                                                              setState) {
                                                return Container(
                                                  width: 500,
                                                  child: const AddMembersScreen(
                                                      isCameFromHomeScreen:
                                                          true),
                                                );
                                              }));
                                            })
                                        : context.push(const AddMembersScreen(
                                            isCameFromHomeScreen: true,
                                          ));
                                    break;
                                  case 2:
                                    showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext dialogContext) {
                                          return ConfirmationDialog(
                                              title: 'Logout?',
                                              body:
                                                  'Are you sure you want to logout?',
                                              positiveButtonLabel: 'Logout',
                                              negativeButtonLabel: 'Cancel',
                                              onPressedPositiveButton:
                                                  () async {
                                                await FirebaseProvider.logout();
                                                await preference
                                                    .setIsLoggedIn(false);
                                                await preference
                                                    .clearPreference();
                                                context.pushAndRemoveUntil(
                                                    const LoginScreen());
                                              });
                                        });
                                    break;
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(child: BuildChatList(isAdmin: isAdmin ?? false))
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: AppColors.lightGrey),
                ),
                BlocBuilder<ChatScreenBloc, ChatScreenState>(
                  builder: (context, state) {
                    print("state--> $state");
                    if (state is ChatScreenClickedState) {
                     return Expanded(
                        flex: 6,
                        child:
                            ChatScreen(groupId: state.groupId, isAdmin: state.isAdmin),
                      );
                    }
                    return Expanded(
                      flex: 6,
                      child: Container(
                          color: AppColors.bg,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/no-group-image.png',
                            height: 200,
                          ),
                          const SizedBox(height: 20),
                          const Text("CPSCOM WEB",style:TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          const SizedBox(
                            width: 500,
                            child: Text(
                                'Lorem ipsum dolor sit amet consectetur. Volutpat justo magna at ante tristique at lacus ultricies auctor. Nullam diam sapien habitasse sed. Suspendisse quam purus vulputate semper nunc lacus magna.'),
                          )
                        ],
                      )
                          // child: ChatScreen(groupId: "", isAdmin: true)
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
