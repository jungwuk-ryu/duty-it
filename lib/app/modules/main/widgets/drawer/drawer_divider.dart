import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerDivider extends StatelessWidget {
  const DrawerDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Color(0xFFF1F1F1),
      child: SizedBox(height: 8.h, width: double.infinity),
    );
  }
}
