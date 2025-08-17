import 'package:duty_it/app/models/search_filter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SearchFilterService extends GetxService {
  final Rx<SearchFilter> _filterRx = SearchFilter().obs;
  SearchFilter get filter => _filterRx.value;

  @override
  void onInit() async {
    super.onInit();

    await GetStorage.init('searchFilter');
    var box = GetStorage('searchFilter');

    var json = box.read('filter');

    if (json != null) {
      _filterRx.value = SearchFilter.fromJson(json);
    }

    debounce(_filterRx, (_) {
      box.write('filter', filter.toJson());
    }, time: Duration(milliseconds: 300));
  }

  void updateFilter(SearchFilter filter) {
    _filterRx.value = filter;
  }

  bool hasFilterChanges() {
    return filter.categories.isNotEmpty || filter.host != null || !filter.showEnded;
  }

  void resetFilter(bool softReset) {
    var newFilter = SearchFilter();
    
    updateFilter(newFilter);
  }
}
