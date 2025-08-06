import 'package:duty_it/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:duty_it/gen/fonts.gen.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_auth.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
    KakaoSdk.init(javaScriptAppKey: "a09a43b25e54febe3c34cee618f23b2c");
  } else {
    KakaoSdk.init(nativeAppKey: "5b75899fba79dc8e1651fa8c98ba12f8");
  }
  

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
