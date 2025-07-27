import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/widgets/custom_divider.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SimpleAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? endChildren;

  const SimpleAppBar({super.key, required this.title, this.endChildren});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25.h),
        Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Image.asset(
                Assets.icons.backLeft.path,
                width: 40.r,
                height: 40.h,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1.60,
              ),
            ),
            Expanded(child: SizedBox()),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: endChildren ?? [],
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        CustomDivider(),
        SizedBox(height: 16.h),
      ],
    );
  }
}
