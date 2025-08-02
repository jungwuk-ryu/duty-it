import 'package:duty_it/app/modules/calendar/controllers/calendar_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateSelectionModalController extends GetxController {
  CalendarViewController get _calViewController =>
      Get.find<CalendarViewController>();
  late final DateTime baseDateTime;
  int selectedItemIndex = 0;

  @override
  void onInit() {
    super.onInit();
    baseDateTime = _calViewController.currentDate;
  }

  @override
  void onClose() {
    var pagingController = _calViewController.pageController;
    pagingController.jumpToPage(
      ((pagingController.page as int?) ?? CalendarViewController.initPage) +
          selectedItemIndex,
    );
    super.onClose();
  }

  DateTime getSelectedDateTime() {
    return getDateTimeByIndex(selectedItemIndex);
  }

  DateTime getDateTimeByIndex(int index) {
    return DateUtils.addMonthsToMonthDate(baseDateTime, index);
  }
}
