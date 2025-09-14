import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lottie/lottie.dart';

class LoginButton extends StatefulWidget {
  final String iconPath;
  final String providerName;
  final Future Function() onTap;
  final Color? buttonColor;

  const LoginButton({
    super.key,
    required this.iconPath,
    required this.providerName,
    required this.onTap,
    this.buttonColor,
  });

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  RxBool isLogining = RxBool(false);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (isLogining.value) return;
        isLogining.value = true;

        try {
          await widget.onTap();
        } finally {
          isLogining.value = false;
        }
      },
      child: Container(
        width: 328.w,
        height: 40.h,
        decoration: BoxDecoration(
          //border: Border.all(color: AppColors.g07, width: 3),
          boxShadow: [BoxShadow(color: AppColors.g04, blurRadius: 4, spreadRadius: 0, offset: Offset(0, 0))],
          borderRadius: BorderRadius.circular(12),
          color: widget.buttonColor ?? AppColors.white,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  widget.iconPath,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 10.w),
                Obx(
                  () => Visibility(
                    visible: isLogining.value,
                    replacement: Text(
                      "${widget.providerName}로 계속하기",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    child: Lottie.asset(
                      Assets.lottie.loadingDots,
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
