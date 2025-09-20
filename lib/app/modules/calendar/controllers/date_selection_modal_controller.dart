import 'package:duty_it/app/modules/calendar/controllers/calendar_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateSelectionModalController extends GetxController {
  CalendarViewController get _calViewController =>
      Get.find<CalendarViewController>();

  late final DateTime baseDate;
  final RxInt _selectedMonth = RxInt(0);
  final RxInt _selectedYear = RxInt(0);
  int get selectedMonth => _selectedMonth.value;
  int get selectedYear => _selectedYear.value;
  set selectedMonth(int month) => _selectedMonth.value = month;
  set selectedYear(int year) => _selectedYear.value = year;

  @override
  void onInit() {
    super.onInit();
    baseDate = DateUtils.dateOnly(
      _calViewController.currentDate,
    ).copyWith(day: 1);
    selectedMonth = baseDate.month;
    selectedYear = baseDate.year;
  }

  void closeAndApply() {
    Get.back();
    var pagingController = _calViewController.pageController;

    var currentPage =
        (pagingController.page as int?) ?? CalendarViewController.initPage;
    var newDateTime = DateTime(selectedYear, selectedMonth);
    var monthDiff = DateUtils.monthDelta(newDateTime, baseDate);

    pagingController.jumpToPage(currentPage - monthDiff);
  }
}
