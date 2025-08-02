import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomRadioButtom extends StatelessWidget {
  final bool checked;
  final VoidCallback onTap;

  const CustomRadioButtom({
    super.key,
    required this.checked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
      width: 22,
      height: 22,
      decoration: ShapeDecoration(
        shape: OvalBorder(side: BorderSide(width: 1, color: AppColors.g05)),
      ),
      child: Center(
        child: Visibility(
          visible: checked,
          child: Container(
            width: 12,
            height: 12,
            decoration: ShapeDecoration(
              color: AppColors.main,
              shape: OvalBorder(),
            ),
          ),
        ),
      ),
    ),
    );
  }
}
