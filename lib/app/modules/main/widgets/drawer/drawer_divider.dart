import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/app/core/constants/app_colors.dart';

class DrawerDivider extends StatelessWidget {
  const DrawerDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.g01,
      child: SizedBox(height: 8.h, width: double.infinity),
    );
  }
}
