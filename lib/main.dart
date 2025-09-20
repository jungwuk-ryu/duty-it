import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/bindings/initial_bindings.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/notifications/repositories/notification_repository.dart';
import 'package:duty_it/firebase_options.dart';
import 'package:duty_it/gen/fonts.gen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_auth.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  var dotenvFuture = dotenv.load(fileName: ".env");

  /* Firebase init start */
  await _initFirebase();

  // 권한 요청
  FirebaseMessaging.instance.requestPermission(
    alert: true, badge: true, sound: true,
  ).then((v) => 
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, badge: true, sound: true,
  ));

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  handleFirebaseForegroundMessages(FirebaseMessaging.onMessage);

  /* Firebase init end */

  if (kIsWeb) {
    KakaoSdk.init(javaScriptAppKey: "a09a43b25e54febe3c34cee618f23b2c");
  } else {
    KakaoSdk.init(nativeAppKey: "5b75899fba79dc8e1651fa8c98ba12f8");
  }

  await Future.wait([dotenvFuture]);

  ApiClient apiClient = ApiClient();
  Get.put(apiClient);

  runApp(
    ScreenUtilInit(
      designSize: Size(360, 760),
      child: GetMaterialApp(
        theme: ThemeData(
          fontFamily: FontFamily.pretendard,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.main,
            brightness: Brightness.light,
            background: AppColors.main,
          ).copyWith(surface: Colors.white, background: Colors.white),
          primaryColor: AppColors.main,
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: AppColors.white),
          drawerTheme: DrawerThemeData(backgroundColor: AppColors.white)
        ),
        debugShowCheckedModeBanner: false,
        title: "듀잇 - Du it!",
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

Future<void> _initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initFirebase();
  
  final repo = NotificationRepository();
  await repo.addNotification(message);
}

Future<void> handleFirebaseForegroundMessages(Stream<RemoteMessage> stream) async {
  await for (var message in stream) {
    if (!Get.isRegistered<NotificationRepository>()) return;
    await Get.find<NotificationRepository>().addNotification(message);
  }
}