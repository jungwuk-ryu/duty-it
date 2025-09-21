import 'package:duty_it/app/models/event_type.dart';
import 'package:duty_it/app/models/host.dart';
import 'package:duty_it/app/services/search_filter/models/search_filter.dart';
import 'package:duty_it/app/modules/search_filter/widgets/host_selection_bottom_modal.dart';
import 'package:duty_it/app/services/search_filter/search_filter_service.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SearchFilterViewController extends GetxController {
  SearchFilterService get service => Get.find<SearchFilterService>();

  final Rx<SearchFilter> _filterRx = SearchFilter().obs;
  SearchFilter get _filter => _filterRx.value;

  Host? get selectedHost => _filter.host;
  set selectedHost(Host? v) => _filterRx(_filter.copyWith(host: v));

  bool get showEnded => _filter.showEnded;
  set showEnded(bool v) => _filterRx(_filter.copyWith(showEnded: v));

  @override
  void onInit() {
    super.onInit();
    _filterRx.value = service.filter;
  }

  List<String> getCategories() {
    return EventType.values.map((e) => e.displayName).toList();
  }

  void onResetSettingsButtonClicked() {
    _filterRx(SearchFilter());
  }

  void onApplyButtonClicked() {
    service.updateFilter(_filter);
    Get.back();
  }

  bool isCategorySelected(String category) {
    return _filter.categories.contains(category);
  }

  void clearSelectedCategories() {
    _filterRx(_filter.copyWith(categories: <String>{}));
  }

  void toggleCategorySelection(String category) {
    var set = Set<String>.from(_filter.categories);

    _filterRx(
      _filter.copyWith(
        categories: set.contains(category)
            ? (set..remove(category))
            : (set..add(category)),
      ),
    );
  }

  bool hasSelectedCategories() {
    return _filter.categories.isNotEmpty;
  }

  void showHostSelectionBottomModal() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => HostSelectionBottomModal(),
    );
  }

  void clearSelectedHost() {
    selectedHost = null;
  }
}
