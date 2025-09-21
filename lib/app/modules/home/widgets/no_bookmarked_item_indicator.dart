import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/widgets.dart';

class NoBookmarkedItemIndicator extends StatelessWidget {
  const NoBookmarkedItemIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 70, horizontal: 30),
      child: Text(
        '북마크된 행사가 없습니다.\n행사 리스트에서 북마크를 추가해보세요.',
        textAlign: TextAlign.center,
        maxLines: 2,
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
