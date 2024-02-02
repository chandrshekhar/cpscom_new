import 'package:cpscom_admin/Features/Home/Model/group_list_model.dart';
import 'package:get/state_manager.dart';

import '../Repository/group_repo.dart';

class GroupListController extends GetxController {
  final _groupListRepo = GroupRepo();
  RxList<GroupModel> groupList = <GroupModel>[].obs;
  RxBool isGroupLiastLoading = false.obs;
  getGroupList() async {
    try {
      isGroupLiastLoading(true);
      var res = await _groupListRepo.groupListService();
      if (res.success == true) {
        groupList.value = res.groupModel!;
        isGroupLiastLoading(false);
      } else {
        groupList.value = [];
        isGroupLiastLoading(false);
      }
    } catch (e) {
      isGroupLiastLoading(false);
    }
  }

  @override
  void onInit() {
    getGroupList();
    super.onInit();
  }
}
