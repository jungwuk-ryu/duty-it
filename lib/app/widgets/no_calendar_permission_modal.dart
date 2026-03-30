import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/widgets/app_bottom_sheet_handle.dart';
import 'package:duty_it/app/widgets/app_normal_button.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class NoCalendarPermissionModal extends StatelessWidget {
  const NoCalendarPermissionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 300),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const AppBottomSheetHandle(),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsetsGeometry.all(16),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Get.back(),
                  child: Image.asset(
                    Assets.icons.close.path,
                    color: AppColors.g05,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16).copyWith(top: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "캘린더 권한 없음",
                      style: TextStyle(
                        height: 1.60,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      '캘린더 권한이 없어서 자동 추가를 할 수 없어요.',
                      style: TextStyle(fontSize: 13),
                      textAlign: TextAlign.center,
                      selectionColor: AppColors.g07,
                    ),
                    SizedBox(height: 20),
                    AppNormalButton(
                      onTap: () async {
                        await openAppSettings();
                      },
                      width: 200,
                      color: AppColors.main,
                      text: '권한 설정',
                    ),
                    SizedBox(height: 5),
                    AppNormalButton(
                      onTap: () async {
                        Get.back();
                        Get.toNamed(Routes.SETTINGS);
                      },
                      width: 200,
                      color: AppColors.g05,
                      text: '자동 추가 끄기',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
