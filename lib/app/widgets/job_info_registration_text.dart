import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/constants/app_legal.dart';
import 'package:flutter/widgets.dart';

class JobInfoRegistrationText extends StatelessWidget {
  final TextAlign textAlign;

  const JobInfoRegistrationText({super.key, this.textAlign = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLegal.jobInfoRegistration,
      textAlign: textAlign,
      style: const TextStyle(
        color: AppColors.g06,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.35,
      ),
    );
  }
}
