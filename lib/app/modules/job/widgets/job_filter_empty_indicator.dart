import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/widgets.dart';

class JobFilterEmptyIndicator extends StatelessWidget {
  const JobFilterEmptyIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 70, horizontal: 40),
      child: Text(
        '필터에 부합하는 채용공고가 없습니다.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: context.colors.icon,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.60,
        ),
      ),
    );
  }
}
