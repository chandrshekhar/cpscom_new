class Urls {
  static const String baseUrl = 'https://api.cpscomhub.com/derick-veliz-admin/api/v1/';
  // static const String baseUrl = 'http://192.168.1.41:4000/api/v1/';
  static const String cmsGetStarted = 'cms/get-started';
  static const String userReport = 'report/user-report';
  static const String groupReport = 'report/group-report';
  static const String report = 'report';
  static const String sendPushNotificationUrl = 'https://fcm.googleapis.com/fcm/send';
  static const String forgetPasswordurl = "https://api.cpscomhub.com/api/v1/users/forgot-password";
  static const String verifyOtp = "https://api.cpscomhub.com/api/v1/users/verify-email-otp";
  static const String resetPassword = "https://api.cpscomhub.com/api/v1/users/reset-password";
}

class ApiPath {
  static const String baseUrls = 'https://cpscomhub.com/api';
  // static const String baseUrls = 'http://192.168.1.41:4000/api/v1';

  static const String socketUrl = "https://api.cpscomhub.com";
  //static const String socketUrl = "https://crazy-sitting-duck.loca.lt";

  //static const String baseUrls = "https://crazy-sitting-duck.loca.lt/api/v1";  //This is for server tunnel for testing live to backend

  //AUTH
  //Login Api
  static const String loginApi = "$baseUrls/v1/users/sign-in";
  static const String getUserDAta = "$baseUrls/v1/users/get-user";
  static const String updateProfileDetails = "$baseUrls/v1/users/update-user";
  static const String changePassword = "$baseUrls/v1/users/change-password";

  //GROUP
  //group api path
  static const String groupListApi = "$baseUrls/v1/groups/getall";

  //MEMBER
  //get all user for showing inside add participent screen
  static const String getAllUserDAta = "$baseUrls/v1/users/get-all-users";
  //delete all user
  //crate group
  static const String craeteGroupApi = "$baseUrls/v1/groups/create";
  //get group by id
  static const String getGroupById = "$baseUrls/v1/groups/get-group-details/";
  //update group details
  static const String updateGroupDetails = "$baseUrls/v1/groups/update-group";
  //remove group member
  static const String deleteMemberFromGroup = "$baseUrls/v1/groups/removeuser";
  //add group memeber exsisting group
  static const String addGroupMember = "$baseUrls/v1/groups/adduser";

  //CHAT
  // get al chat
  static const String getAlChat = "$baseUrls/v1/groups/getonegroup";
  static const String sendSmsApi = "$baseUrls/v1/groups/addnewmsg";

  //report
  static const String groupReportApi = "$baseUrls/v1/groups/report";
  static const String messageReportApi = "$baseUrls/v1/groups/report-message";
}

class EndPoints {
  static const userLogin = '/users/sign-in';
  static const getUserProfileData = '/users/get-user';
  static const groupListApi = "/groups/getall";
  static const groupDetailsApi = "/groups/get-group-details/";
  static const updateGroupDetails = "/groups/update-group";
  static const updateUserProfile = '/users/update-user';
  static const getMemberList = "/admin/users/get-all-users";
  static const createNewGroup = "/groups/create";
  static const deleteMemeberFromGroup = "/groups/removeuser";
  static const addMemberInGroup = "/groups/adduser";
  static const getAllChat = '/groups/getonegroup';
  static const sendMessage = "/groups/addnewmsg";
  static const reportGroup = "/groups/report";
  static const messageReportApi = '/groups/report-message';
}
