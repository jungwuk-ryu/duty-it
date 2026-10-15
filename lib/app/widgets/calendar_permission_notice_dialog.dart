import 'dart:io';

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/services/calendar_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 정보통신망법 제22조의2에 따라 캘린더 권한을 요청하기 전에 보여주는 접근 권한 안내
class CalendarPermissionNoticeDialog extends StatelessWidget {
  static const String title = '캘린더 접근 권한 안내 (선택)';
  static const String content =
      '듀잇은 북마크한 행사를 휴대폰 기본 캘린더에 추가하고, 기본 캘린더 일정을 듀잇 캘린더에서 함께 보여주기 위해 캘린더 접근 권한을 사용해요. '
      '캘린더 정보는 기기 안에서만 사용하며 서버로 보내지 않아요. '
      '허용하지 않아도 캘린더 연동 외의 기능은 그대로 이용할 수 있어요.';

  const CalendarPermissionNoticeDialog({super.key});

  /// 권한이 없으면 안내를 먼저 보여주고, '계속'을 누른 경우에만 OS 권한을 요청한다.
  /// 허용되면 true, 거부되면 false, 안내에서 취소하면 null을 반환한다.
  static Future<bool?> requestPermission() async {
    final calendarService = Get.find<CalendarService>();
    if (await calendarService.checkPermission()) return true;

    final confirmed = await Get.dialog<bool>(
      const CalendarPermissionNoticeDialog(),
    );
    if (confirmed != true) return null;

    return calendarService.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    const titleWidget = Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
    const contentWidget = Text(
      content,
      style: TextStyle(fontSize: 14, color: AppColors.g07),
    );
    const cancelWidget = Text('취소');
    const continueWidget = Text('계속', style: TextStyle(color: AppColors.main));

    if (!kIsWeb && Platform.isAndroid) {
      return AlertDialog(
        title: titleWidget,
        content: contentWidget,
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: cancelWidget,
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: continueWidget,
          ),
        ],
      );
    }

    return CupertinoAlertDialog(
      title: titleWidget,
      content: contentWidget,
      actions: [
        CupertinoDialogAction(
          onPressed: () => Get.back(result: false),
          child: cancelWidget,
        ),
        CupertinoDialogAction(
          onPressed: () => Get.back(result: true),
          child: continueWidget,
        ),
      ],
    );
  }
}
