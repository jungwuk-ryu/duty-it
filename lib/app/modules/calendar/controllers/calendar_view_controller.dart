import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/calendar/controllers/date_selection_modal_controller.dart';
import 'package:duty_it/app/modules/calendar/models/calendar_event.dart';
import 'package:duty_it/app/modules/calendar/widgets/date_selection_bottom_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
    date = DateTime(2025, 07, 18);

    return [
      CalendarEvent(
        title: "어떤 세미나",
        startDate: date,
        endDate: date.add(Duration(days: 2)),
        color: AppColors.cal2,
      ),
      CalendarEvent(
        title: "어떤 세미나2",
        startDate: date,
        endDate: date.add(Duration(days: 1)),
        color: AppColors.cal1,
      ),
      CalendarEvent(
        title: "어떤 세미나3",
        startDate: date,
        endDate: date.add(Duration(days: 2)),
        color: AppColors.cal1,
      ),
      CalendarEvent(
        title: "어떤 세미나4",
        startDate: date,
        endDate: date.add(Duration(days: 3)),
        color: AppColors.cal1,
      ),
      CalendarEvent(
        title: "어떤 세미나5",
        startDate: date.add(Duration(days: 3)),
        endDate: date.add(Duration(days: 5)),
        color: AppColors.cal2,
      ),
      CalendarEvent(
        title: "어떤 세미나6",
        startDate: date.add(Duration(days: 7)),
        endDate: date.add(Duration(days: 10)),
        color: AppColors.cal3,
      ),
    ];
  }
}
