// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:get/get.dart';

// class NetworkController extends GetxController {
//   final String commingFrom;
//   NetworkController({required this.commingFrom});
//   RxBool isInternetConnected = true.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     Connectivity().onConnectivityChanged.listen((result) {
//       if (result.contains(ConnectivityResult.mobile) ||
//           result.contains(ConnectivityResult.wifi) ||
//           result.contains(ConnectivityResult.ethernet)) {
//         callApiAfterInternetGetting();
//         isInternetConnected(true);
//       } else if (result.contains(ConnectivityResult.none)) {
//         isInternetConnected(false);
//       }
//     });
//   }

//   void callApiAfterInternetGetting() {
//     switch (commingFrom) {
//       case "job_list":
//         final jobListController = Get.put(JobController());
//         jobListController.getJobListWithFilter(isLoadingShowing: false);
//         break;
//       case "profile_seen":
//         final authController = Get.put(ProfileController());
//         authController.getProfileData();
//         break;
//       case "applied_job_list":
//         final authController = Get.put(AppliedJobController());
//         authController.getAppliedJobList(isLoadingShow: false);
//         break;
//       case "feed_list":
//         final authController = Get.put(FeedController());
//         authController.getFeedPost(isLoadingShowing: false);
//         break;
//       case "refer_list":
//         final referController = ReferController();
//         referController.getReferLists(isShowLoading: false);
//         break;
//       default:
//     }
//   }
// }
