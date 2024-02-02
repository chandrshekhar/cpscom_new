class Urls {
  static const String baseUrl =
      'https://excellis.co.in/derick-veliz-admin/api/v1/';
  static const String cmsGetStarted = 'cms/get-started';
  static const String userReport = 'report/user-report';
  static const String groupReport = 'report/group-report';
  static const String report = 'report';
  static const String sendPushNotificationUrl =
      'https://fcm.googleapis.com/fcm/send';

  static const String forgetPasswordurl =
      "https://excellis.co.in/derick-veliz-admin/api/v1/user/submit-forget-password";
  static const String verifyOtp =
      "https://excellis.co.in/derick-veliz-admin/api/v1/user/submit-otp";
  static const String resetPassword =
      "https://excellis.co.in/derick-veliz-admin/api/v1/user/reset-password";
}

class ApiPath {
  static const String baseUrls = 'https://api.excellis.in/api/v1';

  //AUTH
  //Login Api
  static const String loginApi = "$baseUrls/users/sign-in";
  static const String getUserDAta = "$baseUrls/users/get-user";

  //GROUP
  //group api path
  static const String groupListApi = "$baseUrls/groups/getall";
}
