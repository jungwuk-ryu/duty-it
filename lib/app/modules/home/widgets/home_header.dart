import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/main/controllers/main_controller.dart';
import 'package:myapp/gen/assets.gen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65.h,
      child: Center(
        child: Row(
          children: [
            Text("App Name"),
            Expanded(child: SizedBox()),
            GestureDetector(
              onTap: () {
                var con = Get.find<MainController>();
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
