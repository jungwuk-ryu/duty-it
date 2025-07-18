import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/main/widgets/drawer/drawer_account_button.dart';

class DrawerAccoutSection extends StatelessWidget {
  const DrawerAccoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        Text(
          "계정",
          style: TextStyle(
            color: AppColors.g05,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.60,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "수줍은 복숭아",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.60,
              ),
            ),
            DrawerAccountButton(),
          ],
        ),
      ],
    );
  }
}
