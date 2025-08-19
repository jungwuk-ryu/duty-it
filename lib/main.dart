import 'package:duty_it/app/bindings/initial_bindings.dart';
import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:duty_it/gen/fonts.gen.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_auth.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dotenvFuture = dotenv.load(fileName: ".env");

  /* Firebase init start */
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  /* Firebase init end */

  if (kIsWeb) {
    KakaoSdk.init(javaScriptAppKey: "a09a43b25e54febe3c34cee618f23b2c");
  } else {
    KakaoSdk.init(nativeAppKey: "5b75899fba79dc8e1651fa8c98ba12f8");
  }

  var getStorageFuture = GetStorage.init('appSettings').then((_) {});
  await Future.wait([dotenvFuture, getStorageFuture]);

  ApiClient apiClient = ApiClient();
  Get.put(apiClient);

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
        initialBinding: InitialBindings(),
        getPages: AppPages.routes,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        ],
      ),
    ),
  );
}
