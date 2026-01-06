import 'package:background_fetch/background_fetch.dart';
import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/models/events_response.dart';
import 'package:duty_it/app/modules/home/cache/home_view_cache.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
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
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  FirebaseMessaging.instance
      .requestPermission(alert: true, badge: true, sound: true)
      .then(
        (v) => FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
              alert: true,
              badge: true,
              sound: true,
            ),
      );

  /* Firebase init end */

  if (kIsWeb) {
    KakaoSdk.init(javaScriptAppKey: "a09a43b25e54febe3c34cee618f23b2c");
  } else {
    KakaoSdk.init(nativeAppKey: "5b75899fba79dc8e1651fa8c98ba12f8");
  }

  await Future.wait([dotenvFuture]);

  if (kIsWeb == false) {
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    initPlatformState();
  }

  runApp(
    GetMaterialApp(
      useInheritedMediaQuery: true,
      theme: ThemeData(
        fontFamily: FontFamily.pretendard,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.main,
          brightness: Brightness.light,
          background: AppColors.main,
        ).copyWith(surface: Colors.white, background: Colors.white),
        primaryColor: AppColors.main,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.white,
        ),
        drawerTheme: DrawerThemeData(backgroundColor: AppColors.white),
      ),
      debugShowCheckedModeBanner: false,
      title: "듀잇 - Du it!",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      builder: (context, child) {
        return Overlay(initialEntries: [OverlayEntry(builder: (_) => child!)]);
      },
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
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
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    BackgroundFetch.finish(taskId);
    return;
  }

  try {
    await _backgroundJob();
  } finally {
    BackgroundFetch.finish(taskId);
  }
}

// Configure BackgroundFetch.
Future<void> initPlatformState() async {
  await BackgroundFetch.configure(
    BackgroundFetchConfig(
      minimumFetchInterval: 60 * 5,
      stopOnTerminate: false,
      enableHeadless: true,
      requiresBatteryNotLow: true,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
      requiredNetworkType: NetworkType.ANY,
    ),
    (String taskId) async {
      try {
        await _backgroundJob();
      } finally {
        BackgroundFetch.finish(taskId);
      }
    },
    (String taskId) async {
      // Time out handler
      BackgroundFetch.finish(taskId);
    },
  );
}

Future<void> _backgroundJob() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    dotenv.load(fileName: ".env"),
    GetStorage.init(AuthService.storageBoxName),
    GetStorage.init(HomeViewCache.boxName),
    _initFirebase(),
  ]);

  Get.lazyPut(() => AuthService());

  var cache = HomeViewCache();
  String? cacheUrl = cache.getEventsUrl();
  if (cacheUrl == null) return;

  var client = ApiClient(background: true);
  RequestResult<EventsResponse> result = await client.getEventsByUrl(cacheUrl);
  if (result is RequestFail) return;

  EventsResponse rep = (result as RequestSuccess).data;
  await cache.saveEvents(rep);
}
