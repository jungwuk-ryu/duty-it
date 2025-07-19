import 'package:get/get.dart';

import '../controllers/search_filter_view_controller.dart';

class SearchFilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchFilterViewController>(() => SearchFilterViewController());
  }
}
