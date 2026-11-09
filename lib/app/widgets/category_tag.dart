import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/widgets/app_asset_icon.dart';
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
        backgroundColor ??
        (isSelected
            ? context.colors.accentSurface
            : context.colors.mutedSurface);
    final Color effectiveTextColor =
        textColor ?? (isSelected ? context.colors.accent : context.colors.text);

    return Semantics(
      button: true,
      selected: isSelected,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
          child: Container(
            decoration: BoxDecoration(
              color: effectiveBackgroundColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 15,
                vertical: 7,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (imageAsset != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppAssetIcon(
                          asset: imageAsset!,
                          width: 16,
                          height: 16,
                          color: imageColor ?? effectiveTextColor,
                        ),
                        SizedBox(width: 4),
                      ],
                    ),
                  Text(
                    name,
                    style: TextStyle(
                      color: effectiveTextColor,
                      fontWeight: FontWeight.w600,
                      height: 1.60,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
