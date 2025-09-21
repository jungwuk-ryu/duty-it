import 'package:flutter/material.dart';

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/calendar/models/calendar_event.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CustomCalendarEventCard extends StatelessWidget {
  final CalendarEvent? event;

  const CustomCalendarEventCard(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 7, left: 16, right: 16),
      child: InkWell(
        onTap: () {
          if (event != null) {
            launchUrlString(event!.url);
          }
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 48),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: event?.color ?? AppColors.g01,
              borderRadius: BorderRadius.circular(4),
            ),
            child: event != null
                ? _EventMetadataColumn(event!)
                : _NoEventText(),
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
