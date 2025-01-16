import 'package:cpscom_admin/Features/Home/Model/group_list_model.dart';
import 'package:get/state_manager.dart';

import '../Repository/group_repo.dart';

class GroupListController extends GetxController {
  final _groupListRepo = GroupRepo();
  RxList<GroupModel> groupList = <GroupModel>[].obs;
  RxBool isGroupLiastLoading = false.obs;
  RxInt limit = 10.obs;
  RxString searchText = "".obs;
  Future<void> getGroupList({bool isLoadingShow = true}) async {
    try {
      isLoadingShow ? isGroupLiastLoading(true) : isGroupLiastLoading(false);
      var res = await _groupListRepo.groupListService(
          searchQuery: searchText.value, offset: 0, limit: limit.value);
      RxList<GroupModel> listData = <GroupModel>[].obs;
      if (res.data!.success == true) {
        listData.value = res.data!.groupModel!;
        listData.sort((a, b) {
          if (a.lastMessage == null && b.lastMessage != null) {
            return 1;
          } else if (a.lastMessage != null && b.lastMessage == null) {
            return -1;
          } else {
            // Both have lastMessage or both don't have lastMessage, sort by updatedAt
            DateTime aUpdatedAt = DateTime.parse(a.updatedAt.toString());
            DateTime bUpdatedAt = DateTime.parse(b.updatedAt.toString());
            return bUpdatedAt.compareTo(aUpdatedAt); // Descending order
          }
        });
        groupList.clear();
        groupList.addAll(listData);
        isGroupLiastLoading(false);
      } else {
        groupList.value = [];
        isGroupLiastLoading(false);
      }
    } catch (e) {
      print("ghghfgf $e");
      isGroupLiastLoading(false);
    }
  }

  @override
  void onInit() {
    getGroupList();
    super.onInit();
  }
}
