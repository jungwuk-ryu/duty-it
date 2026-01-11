import 'package:duty_it/app/routes/app_pages.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';

class AppUtils {
  AppUtils._();

  static void showSnackBar(String content, {Widget? mainButton}) {
    Get.showSnackbar(
      GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.g07.withAlpha(165),
        barBlur: 2,
        borderRadius: 8,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
        mainButton: mainButton,
      ),
    );
  }

  static String weekDay2Text(int weekDay) {
    final List<String> texts = ['월', '화', '수', '목', '금', '토', '일'];
    return texts[weekDay - 1];
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

  static bool isDateWithin(DateTime target, DateTime start, DateTime end) {
    if (hasTime(target)) target = dateTime2Date(target);
    if (hasTime(start)) start = dateTime2Date(start);
    if (hasTime(end)) end = dateTime2Date(end);

    return (start.isBefore(target) || AppUtils.isSameDay(start, target)) &&
        !end.isBefore(target);
  }

  static bool hasTime(DateTime dt) {
    return dt.microsecond != 0 ||
        dt.millisecond != 0 ||
        dt.second != 0 ||
        dt.minute != 0 ||
        dt.hour != 0;
  }

  /// 2025년 00월 00일(일) 형태
  static String formatDateTime(DateTime dt) {
    final mm = dt.month.toString().padLeft(2, '0');
    final dd = dt.day.toString().padLeft(2, '0');
    return '${dt.year}년 $mm월 $dd일(${weekDay2Text(dt.weekday)})';
  }

  static Future<void> resetApp() async {
    await Get.deleteAll(force: true);
    Get.offAllNamed(Routes.SPLASH);
  }
  
  static Uri setDuitUtmSource(Uri uri) {
    return uri.replace(
      queryParameters: {
        ... uri.queryParameters,
        'utm_source': 'www.dutyit.net'
      }
    );
  }

  static String setDuitUtmSourceString(String uri) {
    return setDuitUtmSource(Uri.parse(uri)).toString();
  }
}
