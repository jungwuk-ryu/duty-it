import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/login_view_controller.dart';

class LoginView extends GetView<LoginViewController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(alignment: Alignment.center, child: Text("LOGO")),
        Positioned(
          left: 0,
          right: 0,
          bottom: 88.h,
          child: GestureDetector(
            onTap: controller.onLoginButtonTap,
            child: Image.asset(
              Assets.icons.kakaoLoginLargeWide.path,
              width: 328.w,
              height: 50.h,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: -12.h,
          child: Obx(
            () => Visibility(
              visible: controller.isLogining,
              child: Image.asset(
                Assets.icons.loadingIndicator.path,
                width: 58.w,
                height: 7.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
