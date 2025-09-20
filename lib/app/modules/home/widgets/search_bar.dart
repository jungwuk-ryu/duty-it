import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeSearchBar extends StatefulWidget {
  final TextEditingController controller;

  const HomeSearchBar({super.key, required this.controller});

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
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
              Assets.icons.search.path,
              height: 16.r,
              width: 16.r,
              color: Color(0xff878898),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: widget.controller,
                onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
                onChanged: (_) => setState(() {}),
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
            SizedBox(width: 12),
            if (widget.controller.text.isNotEmpty)
              Padding(
                padding: EdgeInsetsGeometry.only(right: 12),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      widget.controller.clear();
                    });
                  },
                  child: Image.asset(
                    Assets.icons.textdelete.path,
                    width: 16.r,
                    height: 16.r,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
