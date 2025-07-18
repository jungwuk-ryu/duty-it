import 'package:flutter/material.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';

class AccountViewItemText extends StatelessWidget {
  final String text;
  final Color? color;

  const AccountViewItemText(this.text, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.60,
        color: color ?? AppColors.black,
      ),
    );
  }
}
