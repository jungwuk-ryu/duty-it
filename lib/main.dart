import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:duty_it/gen/fonts.gen.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    ScreenUtilInit(
      designSize: Size(360, 760),
      child: GetMaterialApp(
        theme: ThemeData(
          fontFamily: FontFamily.pretendard,
          colorScheme: ColorScheme.light(surface: Colors.white),
        ),
        debugShowCheckedModeBanner: false,
        title: "듀잇 - Duty It!",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    ),
  );
}
