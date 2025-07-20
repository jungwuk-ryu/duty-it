import 'package:duty_it/app/modules/search_filter/controllers/search_filter_view_controller.dart';
import 'package:get/get.dart';

class HostSelectionController extends GetxController {
  SearchFilterViewController get sfvController =>
      Get.find<SearchFilterViewController>();

  final List<String> _hosts = <String>[];
  final RxList<String> filteredHosts = RxList<String>();

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
    _hosts.assignAll([
      '가나다라',
      '가나다라1',
      '가나다라12',
      '가나다라123',
      '가나다라1234',
      '가나다라12345',
      '가나다라6',
      '가나다라7',
      '가나다라8',
    ]);
    _searchHosts();
  }

  void _searchHosts() {
    String query = _query.trim();

    if (query.isEmpty) {
      filteredHosts.assignAll(_hosts);
    } else {
      filteredHosts.assignAll(
        _hosts.where((e) => e.isCaseInsensitiveContains(query)),
      );
    }
  }

  void onHostSelect(String host) {
    sfvController.selectedHost = host;
    Get.back();
  }
}
