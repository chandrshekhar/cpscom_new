import 'package:cpscom_admin/Features/Home/Model/group_list_model.dart';
import 'package:get/state_manager.dart';

import '../Repository/group_repo.dart';

class GroupListController extends GetxController {
  final _groupListRepo = GroupRepo();
  RxList<GroupModel> groupList = <GroupModel>[].obs;
  RxBool isGroupLiastLoading = false.obs;
  RxInt limit = 20.obs;
  RxString searchText = "".obs;
  getGroupList({bool isLoadingShow = true}) async {
    try {
      isLoadingShow ? isGroupLiastLoading(true) : null;
      var res = await _groupListRepo.groupListService(
          searchQuery: searchText.value, offset: 0, limit: limit.value);
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
