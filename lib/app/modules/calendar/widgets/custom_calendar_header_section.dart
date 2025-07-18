import 'package:flutter/widgets.dart';
import 'package:myapp/app/core/constants/app_colors.dart';

class CustomCalendarHeaderSection extends StatelessWidget {
  static const List<String> weekTexts = ['일', '월', '화', '수', '목', '금', '토'];

  const CustomCalendarHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        weekTexts.length,
        (i) => _HeaderText(weekTexts[i]),
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;

  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}
