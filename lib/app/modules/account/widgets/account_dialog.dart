import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AccountDialog extends StatelessWidget {
  final String title;
  final String content;
  final String actionText;
  final void Function() action;

  const AccountDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actionText,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 200.w,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IntrinsicHeight(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 30),
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              Text(
                content,
                style: TextStyle(fontSize: 14, color: AppColors.g07),
              ),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 1,
                color: AppColors.g07,
              ),
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => Get.back(),
                        child: Center(child: Text('취소')),
                      ),
                    ),
                    Container(width: 1, height: 40, color: AppColors.g07),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: action,
                        child: Center(
                          child: Text(
                            actionText,
                            style: TextStyle(color: AppColors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
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
