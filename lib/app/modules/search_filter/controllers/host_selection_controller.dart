import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/models/host.dart';
import 'package:duty_it/app/modules/search_filter/controllers/search_filter_view_controller.dart';
import 'package:get/get.dart';

class HostSelectionController extends GetxController {
  SearchFilterViewController get sfvController =>
      Get.find<SearchFilterViewController>();

  final List<Host> _hosts = <Host>[];
  final RxList<Host> filteredHosts = RxList<Host>();

  final RxString _query = RxString("");
  String get query => _query.value;
  set query(String v) => _query.value = v;

  @override
  void onInit() {
    super.onInit();
    debounce(_query, (_) {
      _searchHosts();
    }, time: Duration(milliseconds: 200));
  }

  @override
  void onReady() {
    super.onReady();
    _fetchHosts();
  }

  Future<void> _fetchHosts() async {
    RequestResult<List<Host>> reqResult = await Get.find<ApiClient>().getHosts();
    if (reqResult is RequestFail) {
      var fail = reqResult.serverFail;
      AppUtils.showSnackBar('주최 목록을 불러오지 못했어요.\n${fail?.message ?? ''}');
      return;
    }

    var success = reqResult as RequestSuccess<List<Host>>;
    _hosts.assignAll(success.data);
    _searchHosts();
  }

  void _searchHosts() {
    String query = _query.trim();

    if (query.isEmpty) {
      filteredHosts.assignAll(_hosts);
    } else {
      filteredHosts.assignAll(
        _hosts.where((e) => e.name.isCaseInsensitiveContains(query)),
      );
    }
  }

  void onHostSelect(Host host) {
    sfvController.selectedHost = host;
    Get.back();
  }
}
