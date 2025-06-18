import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/gen/assets.gen.dart';

class EventBookmarkButton extends StatelessWidget {
  const EventBookmarkButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.icons.bookmarkSharp.path,
      width: 40.r,
      height: 40.r,
    );
  }
}
