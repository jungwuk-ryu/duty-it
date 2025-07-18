import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/app/core/constants/app_colors.dart';
import 'package:myapp/app/core/utils/app_utils.dart';
import 'package:myapp/app/modules/calendar/models/calendar_event.dart';

class CustomCalendarEventCard extends StatelessWidget {
  final CalendarEvent? event;

  const CustomCalendarEventCard(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 7.h, left: 16.w, right: 16.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 48.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: event?.color ?? AppColors.g01,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Visibility(
            visible: event != null,
            replacement: _NoEventText(),
            child: _EventMetadataColumn(event!),
          ),
        ),
      ),
    );
  }
}

class _NoEventText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '일정 없음',
      style: TextStyle(
        color: AppColors.black,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.60,
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
