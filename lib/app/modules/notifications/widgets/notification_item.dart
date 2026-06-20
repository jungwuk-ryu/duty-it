import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/notifications/controllers/notifications_view_controller.dart';
import 'package:duty_it/app/modules/notifications/models/app_notification.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/gen/assets.gen.dart';
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
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: !noti.isRead ? AppColors.cal2 : AppColors.white,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.only(
                  top: 11,
                  right: 10,
                  bottom: 11,
                  left: 12,
                ),
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
                  child: Image.asset(
                    Assets.icons.logo.path,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTitle(noti),
                      style: TextStyle(
                        color: const Color(0xFF333333),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.60,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      _getContent(noti),
                      style: TextStyle(
                        color: const Color(0xFF6F6F6F),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.60,
                      ),
                    ),
                    Text(
                      _formatDateTime(noti.createdAt),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDateTime(DateTime? dt) {
    if (dt == null) return "";
    return '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  static String _getTitle(AppNotification noti) {
    String type = noti.type;
    switch (type) {
      case "EVENT_START":
        return "내일 북마크한 행사가 시작됩니다";
      case "RECRUITMENT_START":
        return "내일 북마크한 행사의 모집이 시작됩니다";
      case "RECRUITMENT_END":
        return "내일 북마크한 행사의 모집이 마감됩니다.";
      case "EVENT_SUBSCRIPTION_KEYWORD":
      case "EVENT_SUBSCRIPTION_HOST":
      case "EVENT_SUBSCRIPTION_TYPE":
        return "맞춤 행사공고가 등록됐어요";
      case "JOB_SUBSCRIPTION_KEYWORD":
      case "JOB_SUBSCRIPTION_COMPANY":
        return "맞춤 채용공고가 등록됐어요";
    }

    return "앱을 업데이트 해주세요";
  }

  static String _getContent(AppNotification noti) {
    String type = noti.type;
    Event? event = noti.event;
    switch (type) {
      case "EVENT_START":
        return "듀근 듀근 ☺️❤️ [${event?.title}]가 내일 ${event?.startAt?.hour}시에 시작됩니다!";
      case "RECRUITMENT_START":
        return "\uD83D\uDCE2[${event?.title}]의 모집이 내일 ${event?.recruitmentStartAt?.hour}시부터 시작됩니다! 잊지말고 신청하세요!";
      case "RECRUITMENT_END":
        return "⏰[${event?.title}]의 모집이 내일 ${event?.recruitmentEndAt?.hour}시에 마감됩니다. 잊진 않으셨죠?";
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
