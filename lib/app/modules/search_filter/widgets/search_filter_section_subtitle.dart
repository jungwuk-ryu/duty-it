import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/widgets.dart';

class SearchFilterSectionSubtitle extends StatelessWidget {
  final String text;

  const SearchFilterSectionSubtitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.g05,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.60,
        ),
      ),
    );
  }
}
