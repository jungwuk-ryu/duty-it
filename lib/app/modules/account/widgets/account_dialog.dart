import 'dart:io';

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    var titleWidget = Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
    var contentWidget = Text(
      content,
      style: TextStyle(fontSize: 14, color: AppColors.g07),
    );
    var cancelWidget = Text('취소');
    var acceptWidget = Text(actionText, style: TextStyle(color: AppColors.red));

    if (!kIsWeb && Platform.isAndroid) {
      return AlertDialog(
        title: titleWidget,
        content: contentWidget,
        actions: [
          TextButton(onPressed: () => Get.back(), child: cancelWidget),
          TextButton(onPressed: action, child: acceptWidget),
        ],
      );
    }

    return CupertinoAlertDialog(
      title: titleWidget,
      content: contentWidget,
      actions: [
        CupertinoDialogAction(child: cancelWidget, onPressed: () => Get.back()),
        CupertinoDialogAction(onPressed: action, child: acceptWidget),
      ],
    );
  }
}
