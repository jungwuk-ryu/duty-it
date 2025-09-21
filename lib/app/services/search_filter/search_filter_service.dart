import 'package:duty_it/app/services/search_filter/models/search_filter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SearchFilterService extends GetxService {
  static final String storageBoxName = 'searchFilter';

  final Rx<SearchFilter> filterRx = SearchFilter().obs;
  SearchFilter get filter => filterRx.value;

  @override
  void onInit() {
    super.onInit();
    var box = GetStorage(storageBoxName);
    var json = box.read('filter');

    if (json != null) {
      filterRx.value = SearchFilter.fromJson(json);
    }

    debounce(filterRx, (_) {
      box.write('filter', filter.toJson());
    }, time: Duration(milliseconds: 300));
  }

  void updateFilter(SearchFilter filter) {
    filterRx.value = filter;
  }

  bool hasFilterChanges() {
    return filter.categories.isNotEmpty || filter.host != null || !filter.showEnded;
  }

  void resetFilter(bool softReset) {
    var newFilter = SearchFilter();
    
    updateFilter(newFilter);
  }
}
