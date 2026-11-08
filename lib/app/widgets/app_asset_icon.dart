import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Monochrome assets share the same theme tint without Android edge seams.
class AppAssetIcon extends StatelessWidget {
  const AppAssetIcon({
    super.key,
    required this.asset,
    this.width = 20,
    this.height = 20,
    this.color,
  });

  final String asset;
  final double width;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) => ColorFiltered(
    colorFilter: ColorFilter.mode(
      color ?? context.colors.text,
      BlendMode.srcIn,
    ),
    child: Image.asset(asset, width: width, height: height),
  );
}
