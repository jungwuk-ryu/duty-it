import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/app/core/constants/app_colors.dart';

class CustomCalendarHeaderSection extends StatelessWidget {
  const CustomCalendarHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HeaderText('일'),
        _HeaderText('월'),
        _HeaderText('화'),
        _HeaderText('수'),
        _HeaderText('목'),
        _HeaderText('금'),
        _HeaderText('토'),
      ],
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;

  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 16.h,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.g07,
              fontSize: 10,
              fontWeight: FontWeight.w400,
              height: 1.60,
            ),
          ),
        ),
      ),
    );
  }
}
