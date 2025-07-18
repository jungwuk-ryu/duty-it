import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:duty_it/gen/assets.gen.dart';

class EventBookmarkButton extends StatelessWidget {
  final bool isBookmarked;

  const EventBookmarkButton({super.key, required this.isBookmarked});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      isBookmarked
          ? Assets.icons.bookmarkSharpRed.path
          : Assets.icons.bookmarkSharp.path,
      width: 40.r,
      height: 40.r,
    );
  }
}
