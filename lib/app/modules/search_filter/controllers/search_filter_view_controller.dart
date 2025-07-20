import 'package:duty_it/app/modules/search_filter/widgets/host_selection_bottom_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchFilterViewController extends GetxController {
  final String categoryAll = '전체';
  final RxSet<String> _selectedCategories = RxSet<String>();

  final RxnString _selectedHost = RxnString();
  String? get selectedHost => _selectedHost.value;
  set selectedHost(v) => _selectedHost.value = v;

  final RxBool _showingEndedEvent = RxBool(true);
  bool get showingEndedEvent => _showingEndedEvent.value;
  set showingEndedEvent(v) => _showingEndedEvent.value = v;

  @override
  void onInit() {
    super.onInit();
    _selectedCategories.add(categoryAll);
  }

  @override
  void onClose() {
    super.onClose();
  }

  List<String> getCategories() {
    return [categoryAll, '컨퍼런스 / 학술대회', '세미나', '웨비나', '워크숍', '공모전'];
  }

  bool isCategorySelected(String category) {
    return _selectedCategories.contains(category);
  }

  void toggleCategorySelection(String category) {
    if (category == categoryAll) {
      _selectedCategories.clear();
      _selectedCategories.add(categoryAll);
      return;
    }

    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
      if (_selectedCategories.isEmpty) _selectedCategories.add(categoryAll);
    } else {
      _selectedCategories.add(category);
      _selectedCategories.remove(categoryAll);
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
