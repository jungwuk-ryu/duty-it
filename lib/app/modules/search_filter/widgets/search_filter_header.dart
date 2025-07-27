import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/search_filter/controllers/search_filter_view_controller.dart';
import 'package:duty_it/app/widgets/simple_app_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchFilterHeader extends StatelessWidget {
  SearchFilterViewController get controller =>
      Get.find<SearchFilterViewController>();

  const SearchFilterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleAppBar(
      title: '검색 필터',
      endChildren: [
        GestureDetector(
          onTap: controller.onResetSettingsButtonClicked,
          child: Text(
            '초기화',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.g04,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.60,
            ),
          ),
        ),
        SizedBox(width: 14.w),
      ],
    );
  }
}
