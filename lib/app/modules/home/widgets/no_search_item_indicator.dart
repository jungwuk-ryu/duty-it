import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoSearchItemIndicator extends StatelessWidget {
  const NoSearchItemIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 70.h, horizontal: 70.w),
      child: Text(
        '검색 결과가 존재하지 않습니다.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.g06,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.60,
        ),
      ),
    );
  }
}
