import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/app/core/constants/app_colors.dart';
import 'package:myapp/app/core/utils/app_utils.dart';
import 'package:myapp/app/modules/calendar/models/calendar_event.dart';

class CustomCalendarDayCell extends StatelessWidget {
  final int calendarMonth;
  final DateTime date;
  final List<CalendarEvent> events;

  const CustomCalendarDayCell({
    super.key,
    required this.date,
    required this.calendarMonth,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();

    return SizedBox(
      height: 72.h,
      child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 16.r,
            height: 16.r,
            decoration: BoxDecoration(
              color:
                  AppUtils.isSameDay(date, now)
                      ? AppColors.g03
                      : AppColors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  color:
                      date.month == calendarMonth
                          ? AppColors.g07
                          : AppColors.g03,
                  fontSize: 10,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.60,
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Expanded(
            child: Column(
              verticalDirection: VerticalDirection.up,
              spacing: 2.h,
              children: List.generate(3, (i) {
                if (i == 0 && events.length > 3) {
                  return Text(
                    '+ ${events.length - 2}개',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.g06,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      height: 1.60,
                    ),
                  );
                }

                CalendarEvent event = events[i];
                bool isStart = AppUtils.isSameDay(event.startDate, date);
                bool isEnd = AppUtils.isSameDay(event.endDate, date);

                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: event.color,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(isStart ? 4.r : 0),
                      topLeft: Radius.circular(isStart ? 4.r : 0),
                      bottomRight: Radius.circular(isEnd ? 4.r : 0),
                      topRight: Radius.circular(isEnd ? 4.r : 0),
                    ),
                  ),
                  child: Text(
                    event.title,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      height: 1.60,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),),
    );
  }
}
