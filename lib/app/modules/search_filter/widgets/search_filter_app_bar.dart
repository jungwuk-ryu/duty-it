import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/search_filter/controllers/search_filter_view_controller.dart';
import 'package:duty_it/app/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SearchFilterAppBar extends StatelessWidget {
  SearchFilterViewController get controller =>
      Get.find<SearchFilterViewController>();

  const SearchFilterAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleAppBar(
      title: '검색 필터',
      endChildren: [
        TextButton(
          onPressed: controller.onResetSettingsButtonClicked,
          style: TextButton.styleFrom(
            minimumSize: const Size(64, 48),
            foregroundColor: context.colors.secondaryText,
          ),
          child: const Text('초기화', style: TextStyle(fontSize: 16)),
        ),
        SizedBox(width: 14),
      ],
    );
  }
}
