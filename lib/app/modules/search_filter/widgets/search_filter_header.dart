import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchFilterHeader extends StatelessWidget {
  const SearchFilterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          behavior: HitTestBehavior.translucent,
          child: Image.asset(
            Assets.icons.backLeft.path,
            width: 40.r,
            height: 40.h,
          ),
        ),
        Text(
          "계정 설정",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1.60,
          ),
        ),
        Expanded(child: SizedBox()),
        Text(
          '초기화',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.g04,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.60,
          ),
        ),
        SizedBox(width: 14.w),
      ],
    );
  }
}
