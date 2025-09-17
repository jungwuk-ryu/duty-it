import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/notifications/controllers/notifications_view_controller.dart';
import 'package:duty_it/app/modules/notifications/models/fcm_notification.dart';
import 'package:duty_it/app/modules/notifications/repositories/notification_repository.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationItem extends StatelessWidget {
  final FcmNotification noti;

  const NotificationItem(this.noti, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        color: AppColors.main,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '삭제',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.60,
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
      key: Key(noti.id),
      onDismissed: (_) {
        NotificationsViewController con = Get.find<NotificationsViewController>();
        con.removeNotification(noti.id);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: !noti.read ? AppColors.cal2 : AppColors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              padding: EdgeInsets.all(15),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: OvalBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: const Color(0xFFD0D0D0),
                  ),
                ),
              ),
              child: Center(
                child: Image.asset(Assets.icons.logo.path, fit: BoxFit.contain),
              ),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  noti.title,
                  style: TextStyle(
                    color: const Color(0xFF333333),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.60,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  noti.body,
                  style: TextStyle(
                    color: const Color(0xFF6F6F6F),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.60,
                  ),
                ),
                Text(
                  _formatDateTime(noti.timestamp),
                  style: TextStyle(
                    color: const Color(0xFF949494),
                    fontSize: 8,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    height: 1.60,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}. ${dt.month.toString().padLeft(2, '0')}. ${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
