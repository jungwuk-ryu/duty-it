import 'package:duty_it/app/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/account/widgets/account_view_item_text.dart';
import 'package:duty_it/app/modules/account/widgets/account_view_item_title.dart';
import 'package:duty_it/gen/assets.gen.dart';

import '../controllers/account_view_controller.dart';

class AccountView extends GetView<AccountViewController> {
  const AccountView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                    "계정 설정",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.60,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              CustomDivider(),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AccountViewItemTitle("닉네임"),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        AccountViewItemText(controller.getUserName()),
                        GestureDetector(
                          onTap: () => controller.onUserNameEditButtonClicked(),
                          child: Image.asset(
                            Assets.icons.solarPenBold.path,
                            width: 24.w,
                            height: 24.h,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 42.h),

                    AccountViewItemTitle("연결된 카카오 계정"),
                    SizedBox(height: 8.h),
                    AccountViewItemText(controller.getAccountId()),

                    SizedBox(height: 32.h),
                    AccountViewItemText("로그아웃", color: AppColors.g05),

                    SizedBox(height: 16.h),
                    AccountViewItemText("회원 탈퇴", color: AppColors.g05),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
