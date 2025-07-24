import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFilterSectionTitle extends StatelessWidget {
  final String text;

  const SearchFilterSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.60,
        ),
      ),
    );
  }
}
