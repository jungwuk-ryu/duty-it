import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppRadioButtom extends StatelessWidget {
  final bool checked;
  final VoidCallback onTap;
  final double tapSize;
  final double visualSize;
  final double selectedSize;

  const AppRadioButtom({
    super.key,
    required this.checked,
    required this.onTap,
    this.tapSize = 44,
    this.visualSize = 18,
    this.selectedSize = 8,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: SizedBox(
        width: tapSize,
        height: tapSize,
        child: Center(
          child: Container(
            width: visualSize,
            height: visualSize,
            decoration: ShapeDecoration(
              shape: OvalBorder(
                side: BorderSide(width: 1, color: AppColors.g05),
              ),
            ),
            child: Center(
              child: Visibility(
                visible: checked,
                child: Container(
                  width: selectedSize,
                  height: selectedSize,
                  decoration: ShapeDecoration(
                    color: AppColors.main,
                    shape: OvalBorder(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
