import 'package:cpscom_admin/Features/Chat/Repo/chat_repo.dart';
import 'package:get/get.dart';

import '../Model/chat_info_model.dart';

class ChatInfoController extends GetxController {
  final chatRepo = ChatRepo();
  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;
  Rx<ChatInfoModel?> chatInfoModel = Rx<ChatInfoModel?>(null);

  chatInfo(String msgId) async {
    errorMessage.value = "";
    Map<String, dynamic> reqModel = {"msgId": msgId};
    try {
      isLoading(true);
      final res = await chatRepo.chatInfo(reqModel: reqModel);
      if (res.errorMessage != null) {
        errorMessage.value = res.errorMessage ?? "";
      }
      if (res.data!.success == true) {
        chatInfoModel.value = res.data!;
      } else {
        errorMessage.value = res.data!.message ?? "";
        chatInfoModel.value = ChatInfoModel();
      }
    } finally {
      isLoading(false);
    }
  }
}
