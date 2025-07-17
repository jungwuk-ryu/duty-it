import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/app/core/constants/app_colors.dart';
import 'package:myapp/app/core/utils/app_utils.dart';
import 'package:myapp/app/modules/calendar/models/calendar_event.dart';
import 'package:myapp/app/modules/calendar/widgets/custom_calendar_header_section.dart';
import 'package:myapp/app/modules/calendar/widgets/custom_calendar_week_cell.dart';
import 'package:myapp/app/modules/calendar/widgets/custom_calendart_event_card.dart';

class CustomCalendar extends StatelessWidget {
  final DateTime date;

  const CustomCalendar({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final DateTime correctedDate = date.copyWith(day: 1);

    return ListView(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCalendarHeaderSection(),
        SizedBox(height: 8.h),
        ...List.generate(5, (i) {
          final DateTime cDt = correctedDate.add(Duration(days: 7 * i));
          if (cDt.month != date.month) return SizedBox.shrink();
          return CustomCalendarWeekCell(date: cDt);
        }),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "${correctedDate.month}월 ${correctedDate.day}일 (${AppUtils.weekDay2Text(correctedDate.weekday)})",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.60,
            ),
          ),
        ),
        CustomCalendartEventCard(),
        CustomCalendartEventCard(),
        CustomCalendartEventCard(),
        CustomCalendartEventCard(),
        CustomCalendartEventCard(),
        CustomCalendartEventCard(),
        CustomCalendartEventCard(),
        CustomCalendartEventCard(),
        CustomCalendartEventCard(),
        CustomCalendartEventCard(),
      ],
    );
  }
}
