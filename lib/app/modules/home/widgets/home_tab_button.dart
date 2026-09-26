import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class HomeTabButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String title;

  const HomeTabButton({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    const animationDuration = Duration(milliseconds: 150);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: animationDuration,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.main : AppColors.g02,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.g07,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
