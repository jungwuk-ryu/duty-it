import 'dart:math' as math;

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/calendar/controllers/custom_calendar_controller.dart';
import 'package:duty_it/app/modules/calendar/widgets/custom_calendar_event_card.dart';
import 'package:duty_it/app/modules/calendar/widgets/custom_calendar_header_section.dart';
import 'package:duty_it/app/modules/calendar/widgets/custom_calendar_week_cell.dart';
import 'package:duty_it/app/widgets/app_bottom_sheet_handle.dart';
import 'package:flutter/material.dart';

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
  static const double _defaultMinSheetHeight = 184;
  static const double _minimumSheetHeight = 136;
  static const double _compactWeekHeight = 32;
  static const double _expandedWeekHeight = 74;
  static const double _calendarHeaderHeight = 24;
  static const double _inlineEventsThreshold = 0.35;

  bool _showInlineEvents = true;

  DateTime _startOfWeekSunday(DateTime date) {
    final int offset = date.weekday % 7;
    return AppUtils.dateTime2Date(date.subtract(Duration(days: offset)));
  }

  List<DateTime> _getWeekStartsInMonth(DateTime monthDate) {
    final DateTime startOfMonth = AppUtils.startOfMonth(monthDate);
    final DateTime endOfMonth = AppUtils.endOfMonth(monthDate);

    final DateTime firstWeekStart = _startOfWeekSunday(startOfMonth);
    final int startOffset = startOfMonth.weekday % 7;
    final int daysInMonth = endOfMonth.day;
    final int weekCount = (startOffset + daysInMonth + 6) ~/ 7;

    return List.generate(
      weekCount,
      (i) => firstWeekStart.add(Duration(days: 7 * i)),
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime> weekStarts = _getWeekStartsInMonth(widget.date);

    return LayoutBuilder(
      builder: (context, constraints) {
        final fullCalendarHeight = _calendarHeight(
          weekStarts.length,
          showInlineEvents: true,
        );
        final compactCalendarHeight = _calendarHeight(
          weekStarts.length,
          showInlineEvents: false,
        );
        final minSheetHeight = math.min(
          _defaultMinSheetHeight,
          math.max(
            _minimumSheetHeight,
            constraints.maxHeight - fullCalendarHeight,
          ),
        );
        final maxSheetHeight = math.min(
          constraints.maxHeight - 16,
          math.max(
            minSheetHeight + 160,
            constraints.maxHeight - compactCalendarHeight,
          ),
        );

        final minChildSize = (minSheetHeight / constraints.maxHeight).clamp(
          0.20,
          0.55,
        );
        final maxChildSize = (maxSheetHeight / constraints.maxHeight).clamp(
          minChildSize + 0.01,
          0.92,
        );
        final inlineEventsToggleExtent =
            minChildSize +
            ((maxChildSize - minChildSize) * _inlineEventsThreshold);

        return Stack(
          children: [
            Positioned.fill(
              child: ClipRect(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Obx(() {
                    final calendarEvents = widget.controller.events.toList();

                    return Column(
                      children: [
                        const CustomCalendarHeaderSection(),
                        const SizedBox(height: 8),
                        ...List.generate(weekStarts.length, (i) {
                          return CustomCalendarWeekCell(
                            date: weekStarts[i],
                            calendarMonth: widget.date.month,
                            events: calendarEvents,
                            controller: widget.controller,
                            showInlineEvents: _showInlineEvents,
                          );
                        }),
                      ],
                    );
                  }),
                ),
              ),
            ),
            NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                final shouldShowInlineEvents =
                    notification.extent < inlineEventsToggleExtent;
                if (shouldShowInlineEvents == _showInlineEvents) {
                  return false;
                }

                setState(() {
                  _showInlineEvents = shouldShowInlineEvents;
                });
                return false;
              },
              child: DraggableScrollableSheet(
                initialChildSize: minChildSize,
                minChildSize: minChildSize,
                maxChildSize: maxChildSize,
                snap: true,
                snapAnimationDuration: const Duration(milliseconds: 200),
                builder: (_, scrollController) {
                  return _CalendarEventSheet(
                    controller: widget.controller,
                    scrollController: scrollController,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  double _calendarHeight(int weekCount, {required bool showInlineEvents}) {
    final weekHeight = showInlineEvents
        ? _expandedWeekHeight
        : _compactWeekHeight;
    return _calendarHeaderHeight + (weekCount * weekHeight);
  }
}

class _CalendarEventSheet extends StatelessWidget {
  const _CalendarEventSheet({
    required this.controller,
    required this.scrollController,
  });

  final CustomCalendarController controller;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.g02)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x146F6F6F),
            blurRadius: 16,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          const SliverToBoxAdapter(
            child: AppBottomSheetHandle(topPadding: 8, bottomPadding: 14),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                final selectedDate = controller.currentDateTime;
                return Text(
                  _formatSelectedDate(selectedDate),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.60,
                  ),
                );
              }),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 4)),
          Obx(() {
            final events = controller.getEventsByDay(
              controller.currentDateTime,
            );
            if (events.isEmpty) {
              return const SliverToBoxAdapter(
                child: CustomCalendarEventCard(null),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate((_, index) {
                return CustomCalendarEventCard(events[index]);
              }, childCount: events.length),
            );
          }),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  String _formatSelectedDate(DateTime date) {
    return "${date.month}월 ${date.day}일 (${AppUtils.weekDay2Text(date.weekday)})";
  }
}
