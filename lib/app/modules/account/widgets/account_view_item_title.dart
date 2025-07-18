import 'package:flutter/material.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';

class AccountViewItemTitle extends StatelessWidget {
  final String text;

  const AccountViewItemTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.60,
        color: AppColors.g05,
      ),
    );
  }
}
