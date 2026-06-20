import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/notifications/controllers/notifications_view_controller.dart';
import 'package:duty_it/app/modules/notifications/models/app_notification.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NotificationItem extends StatelessWidget {
  final AppNotification noti;

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
      key: Key("${noti.id}"),
      confirmDismiss: (_) async {
        NotificationsViewController con =
            Get.find<NotificationsViewController>();
        return await con.deleteNotification(noti.id);
      },
      child: InkWell(
        onTap: () => _openNotificationTarget(noti),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 13, 22, 12),
          decoration: BoxDecoration(
            color: !noti.isRead ? AppColors.cal2 : AppColors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getTitle(noti),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.60,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _getContent(noti),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.g06,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatDateTime(noti.createdAt),
                style: const TextStyle(
                  color: AppColors.g05,
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  height: 1.60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDateTime(DateTime? dt) {
    if (dt == null) return "";
    return '${dt.year}. ${dt.month.toString().padLeft(2, '0')}. ${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  static String _getTitle(AppNotification noti) {
    String type = noti.type;
    final prefix = _getCategoryPrefix(noti);
    switch (type) {
      case "EVENT_START":
        return "$prefix 북마크한 행사가 곧 시작돼요";
      case "RECRUITMENT_START":
        return "$prefix 북마크한 행사의 모집이 시작돼요";
      case "RECRUITMENT_END":
        return "$prefix 북마크한 행사의 모집이 마감돼요";
      case "EVENT_SUBSCRIPTION_KEYWORD":
      case "EVENT_SUBSCRIPTION_HOST":
      case "EVENT_SUBSCRIPTION_TYPE":
        return "$prefix 새로운 공고가 등록 되었어요";
      case "JOB_SUBSCRIPTION_KEYWORD":
      case "JOB_SUBSCRIPTION_COMPANY":
        return "$prefix 새로운 공고가 등록 되었어요";
    }

    return "앱을 업데이트 해주세요";
  }

  static String _getContent(AppNotification noti) {
    String type = noti.type;
    Event? event = noti.event;
    switch (type) {
      case "EVENT_START":
        return "[${event?.title ?? '행사공고'}]가 내일 ${event?.startAt?.hour ?? ''}시에 시작됩니다.";
      case "RECRUITMENT_START":
        return "[${event?.title ?? '행사공고'}]의 모집이 내일 ${event?.recruitmentStartAt?.hour ?? ''}시부터 시작됩니다.";
      case "RECRUITMENT_END":
        return "[${event?.title ?? '행사공고'}]의 모집이 내일 ${event?.recruitmentEndAt?.hour ?? ''}시에 마감됩니다.";
      case "EVENT_SUBSCRIPTION_KEYWORD":
      case "EVENT_SUBSCRIPTION_HOST":
      case "EVENT_SUBSCRIPTION_TYPE":
        return "[${event?.title ?? '행사공고'}]를 확인해 보세요.";
      case "JOB_SUBSCRIPTION_KEYWORD":
      case "JOB_SUBSCRIPTION_COMPANY":
        return "[${noti.jobPosting?.companyName ?? '채용기업'}] ${noti.jobPosting?.title ?? '채용공고'}";
    }

    return "앱을 업데이트 해주세요";
  }

  static String _getCategoryPrefix(AppNotification noti) {
    if (noti.jobPosting != null || noti.type.startsWith('JOB_')) {
      return '[채용]';
    }
    return '[행사]';
  }

  static Future<void> _openNotificationTarget(AppNotification noti) async {
    final Event? event = noti.event;
    if (event != null) {
      if (await canLaunchUrlString(event.uri)) {
        launchUrlString(AppUtils.setDuitUtmSourceString(event.uri));
      }
      return;
    }

    final JobPosting? jobPosting = noti.jobPosting;
    if (jobPosting != null) {
      Get.toNamed(Routes.JOB_DETAIL, arguments: {'jobRx': jobPosting.obs});
    }
  }
}
