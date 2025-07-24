import 'package:duty_it/app/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:duty_it/app/modules/main/widgets/drawer/drawer_accout_section.dart';
import 'package:duty_it/app/modules/main/widgets/drawer/drawer_category_section.dart';
import 'package:duty_it/app/modules/main/widgets/drawer/drawer_close_button.dart';

class EndDrawer extends StatelessWidget {
  const EndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      clipBehavior: Clip.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      width: 256.w,

      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 49.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: DrawerCloseButton(),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: DrawerAccoutSection(),
            ),

            SizedBox(height: 38.h),
            CustomDivider(),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: DrawerCategorySection(),
            ),
          ],
        ),
      ),
    );
  }
}
