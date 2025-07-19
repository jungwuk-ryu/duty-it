import 'package:get/get.dart';

class SearchFilterViewController extends GetxController {
  final String categoryAll = '전체';
  final RxSet<String> _selectedCategories = RxSet<String>();

  @override
  void onInit() {
    super.onInit();
    _selectedCategories.add(categoryAll);
  }

  @override
  void onReady() {
    super.onReady();
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
}
