import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/calendar/controllers/calendar_view_controller.dart';
import 'package:duty_it/app/modules/calendar/models/calendar_event.dart';
import 'package:duty_it/app/services/calendar_service.dart';
import 'package:duty_it/app/widgets/adaptive_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CustomCalendarEventCard extends StatelessWidget {
  final CalendarEvent? event;

  const CustomCalendarEventCard(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    final Widget container = Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: event?.color ?? AppColors.g01,
        borderRadius: BorderRadius.circular(4),
      ),
      child: event != null ? _EventMetadataColumn(event!) : _NoEventText(),
    );

    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 7, left: 16, right: 16),
      child: InkWell(
        onTap: () {
          if (event != null) {
            String url = event!.url;
            if (url.startsWith(CalendarViewController.deviceEventScheme)) {
              Get.find<CalendarService>()
                  .showEventModal(url.replaceFirst(CalendarViewController.deviceEventScheme, ""));
            } else {
              launchUrlString(AppUtils.setDuitUtmSourceString(url));
            }
          }
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 48),
          child: AdaptiveLayout(
            phone: container,
            tablet: Row(
              // SliverList가 width를 최대 크기로 고정하기 때문에 Row 필수입니다.
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      child: container,
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

class _NoEventText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '일정 없음',
        style: TextStyle(
          color: AppColors.black,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.60,
        ),
      ),
    );
  }
}

class _EventMetadataColumn extends StatelessWidget {
  final CalendarEvent event;

  const _EventMetadataColumn(this.event);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          event.title,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            height: 1.60,
          ),
        ),
        Text(
          '${_formatDateTime(event.startDate)} ~ ${_formatDateTime(event.endDate)}',
          style: TextStyle(
            color: AppColors.g06,
            fontSize: 10,
            fontWeight: FontWeight.w400,
            height: 1.60,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dt) {
    String dateText = "${dt.month}월 ${dt.day}일";
    String weekDayText = AppUtils.weekDay2Text(dt.weekday);
    String timeText =
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";

    return "$dateText ($weekDayText) $timeText";
  }
}
