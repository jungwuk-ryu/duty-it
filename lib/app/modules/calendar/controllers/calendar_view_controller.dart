import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/calendar/controllers/date_selection_modal_controller.dart';
import 'package:duty_it/app/modules/calendar/models/calendar_event.dart';
import 'package:duty_it/app/modules/calendar/widgets/date_selection_bottom_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../models/event.dart';

class CalendarViewController extends GetxController {
  final Rx<DateTime> _currentDate = DateTime.now().obs;
  DateTime get currentDate => _currentDate.value;
  set currentDate(value) => _currentDate.value = value;

  static const int initPage = 2000;
  PageController pageController = PageController(initialPage: initPage);

  void showDateSelectionBottomModal() {
    Get.put(DateSelectionModalController());
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => DateSelectionBottomModal(),
    ).whenComplete(() => Get.delete<DateSelectionModalController>());
  }

  Future<List<CalendarEvent>> getCalendarEvents(DateTime date) async {
    var apiClient = Get.find<ApiClient>();
    RequestResult<List<Event>> reqResult = await apiClient.getEventsForCalendar(
      year: date.year,
      month: date.month,
    );
    if (reqResult is RequestFail) {
      AppUtils.showSnackBar(
        '${date.year}년 ${date.month}월 캘린더를 불러오지 못했어요.\n${reqResult.serverFail?.message ?? ''}',
      );
      return [];
    }

    var reqSuccess = reqResult as RequestSuccess<List<Event>>;
    List<Event> events = reqSuccess.data;
    List<CalendarEvent> cEvents = [];

    for (Event event in events) {
      cEvents.add(
        CalendarEvent(
          title: event.title,
          startDate: event.startAt ?? DateTime.now(),
          endDate: event.endAt ?? DateTime.now(),
          color: AppColors.cal1,
        ),
      );
    }

    return cEvents;
  }
}
