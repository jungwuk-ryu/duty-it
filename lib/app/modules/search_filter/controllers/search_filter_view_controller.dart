import 'package:duty_it/app/modules/search_filter/widgets/host_selection_bottom_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchFilterViewController extends GetxController {
  final RxSet<String> _selectedCategories = RxSet<String>();

  final RxnString _selectedHost = RxnString();
  String? get selectedHost => _selectedHost.value;
  set selectedHost(v) => _selectedHost.value = v;

  static const bool _showingEndedEventDefaultValue = true;
  final RxBool _showingEndedEvent = RxBool(_showingEndedEventDefaultValue);
  bool get showingEndedEvent => _showingEndedEvent.value;
  set showingEndedEvent(v) => _showingEndedEvent.value = v;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void resetSettings() {
    clearSelectedCategories();
    selectedHost = null;
    showingEndedEvent = _showingEndedEventDefaultValue;
  }

  List<String> getCategories() {
    return ['컨퍼런스 / 학술대회', '세미나', '웨비나', '워크숍', '공모전'];
  }

  bool hasSelectedCategories() {
    return _selectedCategories.isNotEmpty;
  }

  bool isCategorySelected(String category) {
    return _selectedCategories.contains(category);
  }

  void clearSelectedCategories() {
    _selectedCategories.clear();
  }

  void toggleCategorySelection(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
  }

  void showHostSelectionBottomModal() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => HostSelectionBottomModal(),
    );
  }
}
