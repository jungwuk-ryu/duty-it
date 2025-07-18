import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:myapp/app/core/constants/app_colors.dart';

class AppUtils {
  AppUtils._();

  static void showSnackBar(String content) {
    Get.showSnackbar(
      GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.g07,
        borderRadius: 8.r,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        snackPosition: SnackPosition.BOTTOM,
        messageText: Center(
          child: Text(
            content,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  static String weekDay2Text(int weekDay) {
    final List<String> texts = ['월', '화', '수', '목', '금', '토', '일'];
    return texts[weekDay % 7];
  }

  static bool isSameDay(DateTime dt1, DateTime dt2) {
    return dt1.day == dt2.day && dt1.month == dt2.month && dt1.year == dt2.year;
  }

  static DateTime dateTime2Date(DateTime dt) {
    return dt.copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
  }

  static bool isDateWithin (DateTime target, DateTime start, DateTime end) {
    return (start.isBefore(target) ||
                    AppUtils.isSameDay(start, target)) &&
                !end.isBefore(target);
  }
}
