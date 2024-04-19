class Urls {
  static const String baseUrl =
      'https://api.cpscomhub.com/derick-veliz-admin/api/v1/';
  static const String cmsGetStarted = 'cms/get-started';
  static const String userReport = 'report/user-report';
  static const String groupReport = 'report/group-report';
  static const String report = 'report';
  static const String sendPushNotificationUrl =
      'https://fcm.googleapis.com/fcm/send';
  static const String forgetPasswordurl =
      "https://api.cpscomhub.com/api/v1/users/forgot-password";
  static const String verifyOtp =
      "https://api.cpscomhub.com/api/v1/users/verify-email-otp";
  static const String resetPassword =
      "https://api.cpscomhub.com/api/v1/users/reset-password";
}

class ApiPath {
  static const String baseUrls = 'https://api.cpscomhub.com/api/v1';

  static const String socketUrl = "https://api.cpscomhub.com";
  //static const String socketUrl = "https://crazy-sitting-duck.loca.lt";

  //static const String baseUrls = "https://crazy-sitting-duck.loca.lt/api/v1";  //This is for server tunnel for testing live to backend

  //AUTH
  //Login Api
  static const String loginApi = "$baseUrls/users/sign-in";
  static const String getUserDAta = "$baseUrls/users/get-user";
  static const String updateProfileDetails = "$baseUrls/users/update-user";
  static const String changePassword = "$baseUrls/users/change-password";

  //GROUP
  //group api path
  static const String groupListApi = "$baseUrls/groups/getall";

  //MEMBER
  //get all user for showing inside add participent screen
  static const String getAllUserDAta = "$baseUrls/users/get-all-users";
  //delete all user
  //crate group
  static const String craeteGroupApi = "$baseUrls/groups/create";
  //get group by id
  static const String getGroupById = "$baseUrls/groups/get-group-details/";
  //update group details
  static const String updateGroupDetails = "$baseUrls/groups/update-group";
  //remove group member
  static const String deleteMemberFromGroup = "$baseUrls/groups/removeuser";
  //add group memeber exsisting group
  static const String addGroupMember = "$baseUrls/groups/adduser";

  //CHAT
  // get al chat
  static const String getAlChat = "$baseUrls/groups/getonegroup";
  static const String sendSmsApi = "$baseUrls/groups/addnewmsg";

  //report
  static const String groupReportApi = "$baseUrls/groups/report";
  static const String messageReportApi = "$baseUrls/groups/report-message";
}
