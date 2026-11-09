import 'dart:math' as math;

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/calendar/controllers/custom_calendar_controller.dart';
import 'package:duty_it/app/modules/calendar/widgets/custom_calendar_event_card.dart';
import 'package:duty_it/app/modules/calendar/widgets/custom_calendar_header_section.dart';
import 'package:duty_it/app/modules/calendar/widgets/custom_calendar_week_cell.dart';
import 'package:duty_it/app/widgets/app_bottom_sheet_handle.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:duty_it/app/widgets/adaptive_layout.dart';
import 'package:flutter/material.dart';

import 'package:get/get_state_manager/get_state_manager.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime date;
  const CustomCalendar({super.key, required this.date});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  static const double _defaultMinSheetHeight = 184;
  static const double _minimumSheetHeight = 136;
  static const double _inlineEventsThreshold = 0.35;

  bool _showInlineEvents = true;
  final _sheetController = DraggableScrollableController();
  late final CustomCalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CustomCalendarController(widget.date)..init();
  }

  DateTime _startOfWeekSunday(DateTime date) {
    final int offset = date.weekday % 7;
    return AppUtils.calendarDay(date).subtract(Duration(days: offset));
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
    _sheetController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime> weekStarts = _getWeekStartsInMonth(widget.date);

    return LayoutBuilder(
      builder: (context, constraints) {
        final fullCalendarHeight = _calendarHeight(
          context,
          weekStarts.length,
          showInlineEvents: true,
        );
        final compactCalendarHeight = _calendarHeight(
          context,
          weekStarts.length,
          showInlineEvents: false,
        );
        final layout = DuoLayoutData.of(context);
        final fold = layout.verticalFold;
        final textScale = math.max(
          1.0,
          MediaQuery.textScalerOf(context).scale(14) / 14,
        );
        final leftWidth = fold == null
            ? (constraints.maxWidth - 24) * 0.6
            : fold.left - layout.contentBounds.left - 12;
        final gap = 24.0 + (fold?.width ?? 0);
        final rightWidth = constraints.maxWidth - leftWidth - gap;
        if ((fold != null || constraints.maxWidth >= 840 * textScale) &&
            leftWidth >= 280 * textScale &&
            rightWidth >= 240 * textScale) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: leftWidth,
                child: _calendar(
                  weekStarts,
                  showInlineEvents: fullCalendarHeight <= constraints.maxHeight,
                ),
              ),
              SizedBox(width: gap),
              Expanded(
                child: _CalendarEventSheet(
                  controller: _controller,
                  showHandle: false,
                ),
              ),
            ],
          );
        }
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

        return AdaptiveContent(
          maxWidth: double.infinity,
          screenLeft: layout.contentBounds.left,
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _sheetController,
                child: _calendar(
                  weekStarts,
                  showInlineEvents: _showInlineEvents,
                ),
                builder: (context, child) => Positioned.fill(
                  bottom:
                      (_sheetController.isAttached
                              ? _sheetController.size
                              : minChildSize)
                          .clamp(minChildSize, maxChildSize) *
                      constraints.maxHeight,
                  child: child!,
                ),
              ),
              NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  if (notification.depth != 0) return false;
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
                  controller: _sheetController,
                  initialChildSize: minChildSize,
                  minChildSize: minChildSize,
                  maxChildSize: maxChildSize,
                  snap: true,
                  snapAnimationDuration: const Duration(milliseconds: 200),
                  builder: (_, scrollController) {
                    return _CalendarEventSheet(
                      controller: _controller,
                      scrollController: scrollController,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _calendarHeight(
    BuildContext context,
    int weekCount, {
    required bool showInlineEvents,
  }) =>
      MediaQuery.textScalerOf(context).scale(10) * 1.6 +
      8 +
      weekCount *
          CustomCalendarWeekCell.heightFor(
            context,
            showInlineEvents: showInlineEvents,
          );

  Widget _calendar(
    List<DateTime> weekStarts, {
    required bool showInlineEvents,
  }) => ClipRect(
    child: SingleChildScrollView(
      key: PageStorageKey('month-${widget.date}'),
      primary: false,
      child: Obx(
        () => Column(
          children: [
            const CustomCalendarHeaderSection(),
            const SizedBox(height: 8),
            for (final week in weekStarts)
              CustomCalendarWeekCell(
                date: week,
                calendarMonth: widget.date.month,
                events: _controller.events.toList(),
                controller: _controller,
                showInlineEvents: showInlineEvents,
              ),
          ],
        ),
      ),
    ),
  );
}

class _CalendarEventSheet extends StatelessWidget {
  const _CalendarEventSheet({
    required this.controller,
    this.scrollController,
    this.showHandle = true,
  });

  final CustomCalendarController controller;
  final ScrollController? scrollController;
  final bool showHandle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.mutedSurface)),
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
          if (showHandle)
            const SliverToBoxAdapter(
              child: AppBottomSheetHandle(topPadding: 8, bottomPadding: 14),
            ),
          if (!showHandle)
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                final selectedDate = controller.currentDateTime;
                return Text(
                  _formatSelectedDate(selectedDate),
                  style: TextStyle(
                    color: context.colors.text,
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
