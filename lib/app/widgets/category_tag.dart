import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryTag extends StatelessWidget {
  final String? imageAsset;
  final String name;
  final bool isSelected;
  final GestureTapCallback? onTap;
  final Color? imageColor;
  final Color? backgroundColor;
  final Color? textColor;

  const CategoryTag({
    super.key,
    required this.isSelected,
    required this.name,
    this.imageAsset,
    this.onTap,
    this.imageColor,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveBackgroundColor =
        backgroundColor ?? (isSelected ? AppColors.sub : AppColors.g02);
    final Color effectiveTextColor =
        textColor ?? (isSelected ? AppColors.main : AppColors.black);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 32),
        child: Container(
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(16),
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
                    color: effectiveTextColor,
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
