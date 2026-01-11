import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/calendar/controllers/custom_calendar_controller.dart';
import 'package:duty_it/app/modules/calendar/widgets/custom_calendar_event_card.dart';
import 'package:duty_it/app/modules/calendar/widgets/custom_calendar_header_section.dart';
import 'package:duty_it/app/modules/calendar/widgets/custom_calendar_week_cell.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get_state_manager/get_state_manager.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime date;
  final CustomCalendarController controller;

  const CustomCalendar({
    super.key,
    required this.date,
    required this.controller,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime startOfMonth = widget.date.copyWith(day: 1);

    return CustomScrollView(
      //crossAxisAlignment: CrossAxisAlignment.start,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            CustomCalendarHeaderSection(),
            SizedBox(height: 8),
            ...List.generate(5, (i) {
              final DateTime cDt = startOfMonth.add(Duration(days: 7 * i));
              if (cDt.month != widget.date.month) return SizedBox.shrink();
              return CustomCalendarWeekCell(
                date: cDt,
                events: widget.controller.events,
                controller: widget.controller,
              );
            }),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                DateTime selectedDate = widget.controller.currentDateTime;
                return Text(
                  "${selectedDate.month}월 ${selectedDate.day}일 (${AppUtils.weekDay2Text(selectedDate.weekday)})",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.60,
                  ),
                );
              }),
            ),
            SizedBox(height: 4),
          ]),
        ),
        Obx(() {
          var events = widget.controller.getEventsByDay(widget.controller.currentDateTime);
          if (events.isEmpty) {
            return SliverToBoxAdapter(child: CustomCalendarEventCard(null));
          }

          return SliverList(
            delegate: SliverChildListDelegate(
              List.generate(
                events.length,
                (i) => CustomCalendarEventCard(events[i]),
              ),
            ),
          );
        }),
      ],
    );
  }
}
