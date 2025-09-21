import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryTag extends StatelessWidget {
  final String? imageAsset;
  final String name;
  final bool isSelected;
  final GestureTapCallback? onTap;
  final Color? imageColor;

  const CategoryTag({
    super.key,
    required this.isSelected,
    required this.name,
    this.imageAsset,
    this.onTap,
    this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 32),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.main : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: BoxBorder.all(
              width: 1,
              color: isSelected ? AppColors.transparent : AppColors.g04,
            ),
          ),
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: imageAsset != null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        imageAsset ?? "",
                        width: 16,
                        height: 16,
                        color: imageColor,
                      ),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.g05,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w300,
                    height: 1.60,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
