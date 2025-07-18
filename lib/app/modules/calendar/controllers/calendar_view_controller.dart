import 'package:get/get.dart';
import 'package:myapp/app/core/constants/app_colors.dart';
import 'package:myapp/app/modules/calendar/models/calendar_event.dart';

class CalendarViewController extends GetxController {
  final Rx<DateTime> _currentDate = DateTime.now().obs;
  get currentDate => _currentDate.value;
  set currentDate(value) => _currentDate.value = value;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
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
