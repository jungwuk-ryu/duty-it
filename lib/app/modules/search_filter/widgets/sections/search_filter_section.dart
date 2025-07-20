import 'package:duty_it/app/modules/search_filter/controllers/search_filter_view_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

abstract class SearchFilterSection extends StatelessWidget {
  SearchFilterViewController get controller =>
      Get.find<SearchFilterViewController>();

  const SearchFilterSection({super.key});
}
