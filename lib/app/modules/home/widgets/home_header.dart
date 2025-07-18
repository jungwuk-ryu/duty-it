import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:duty_it/app/modules/main/controllers/main_view_controller.dart';
import 'package:duty_it/gen/assets.gen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65.h,
      child: Center(
        child: Row(
          children: [
            Text("듀잇 - Duty It!"),
            Expanded(child: SizedBox()),
            GestureDetector(
              onTap: () {
                var con = Get.find<MainViewController>();
                con.openEndDrawer();
              },
              child: Image.asset(
                Assets.icons.quillHamburger.path,
                width: 40.r,
                height: 40.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
