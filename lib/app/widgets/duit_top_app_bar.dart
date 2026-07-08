import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class DuitTopAppBar extends StatelessWidget {
  final bool showNotifications;
  final bool hasNewNotification;
  final VoidCallback onNotificationsTap;
  final VoidCallback onMenuTap;

  const DuitTopAppBar({
    super.key,
    required this.showNotifications,
    required this.hasNewNotification,
    required this.onNotificationsTap,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Image.asset(Assets.icons.logo.path, width: 16, height: 16),
          const SizedBox(width: 8),
          const Text(
            '듀잇 - Du it!',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.60,
            ),
          ),
          const Spacer(),
          if (showNotifications)
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onNotificationsTap,
              child: SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: Image.asset(
                    hasNewNotification
                        ? Assets.icons.bellNew.path
                        : Assets.icons.bell.path,
                    width: 14,
                    height: 18,
                  ),
                ),
              ),
            ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onMenuTap,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: Image.asset(
                  Assets.icons.hamburger.path,
                  width: 18,
                  height: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
