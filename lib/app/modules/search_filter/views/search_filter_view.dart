import 'package:duty_it/app/modules/search_filter/widgets/search_filter_app_bar.dart';
import 'package:duty_it/app/modules/search_filter/widgets/sections/search_filter_category_section.dart';
import 'package:duty_it/app/modules/search_filter/widgets/sections/search_filter_ended_event_section.dart';
import 'package:duty_it/app/modules/search_filter/widgets/sections/search_filter_host_section.dart';
import 'package:duty_it/app/widgets/filter_page_scaffold.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/search_filter_view_controller.dart';

class SearchFilterView extends GetView<SearchFilterViewController> {
  const SearchFilterView({super.key});
  @override
  Widget build(BuildContext context) {
    return FilterPageScaffold(
      header: const SearchFilterAppBar(),
      sections: const [
        SearchFilterCategorySection(),
        SearchFilterHostSection(),
        SearchFilterEndedEventSection(),
      ],
      onApply: controller.onApplyButtonClicked,
    );
  }
}
