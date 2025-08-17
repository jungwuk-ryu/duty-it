import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:get/get.dart';

class EventBookmarkButton extends StatelessWidget {
  final bool isBookmarked;

  HomeViewController get _controller => Get.find<HomeViewController>();

  const EventBookmarkButton({super.key, required this.isBookmarked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _controller.bookmarkTest(),
      child: Image.asset(
        isBookmarked
            ? Assets.icons.bookmarkSharpRed.path
            : Assets.icons.bookmarkSharp.path,
        width: 40.r,
        height: 40.r,
      ),
    );
  }
}
