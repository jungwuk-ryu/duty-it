import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/gen/assets.gen.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const HomeSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.g02,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 16),
            Image.asset(
              Assets.icons.iconamoonSearch.path,
              height: 16.r,
              width: 16.r,
              color: Color(0xff878898),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  isCollapsed: true,
                  hintText: '찾으시는 행사가 있나요?',
                  hintStyle: TextStyle(
                    color: AppColors.g05,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
