import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/theme/app_theme.dart';
import 'package:duty_it/app/core/theme/app_system_ui.dart';
import 'package:duty_it/app/core/models/events_response.dart';
import 'package:duty_it/app/core/utils/event_deep_link.dart';
import 'package:duty_it/app/core/utils/app_orientation.dart';
import 'package:duty_it/app/modules/home/cache/home_view_cache.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/services/event_deep_link_service.dart';
import 'package:duty_it/firebase_options.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppOrientation.configureStartup();
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
  await Future.wait([dotenvFuture]);

  await GetStorage.init(AuthService.storageBoxName);
  final auth = Get.put(AuthService(), permanent: true);
  await auth.syncAnalyticsUserId();

  if (kIsWeb == false) {
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    initPlatformState();
  }

  /* App Links & Universal Links */
  EventDeepLinkService.ensureRegistered();
  unawaited(_initDeepLinks());

  runApp(
    GetMaterialApp(
      useInheritedMediaQuery: true,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      title: "듀잇 - Du it!",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      builder: (context, child) {
        return AppSystemUi(
          child: DuoLayout(
            child: Overlay(
              initialEntries: [OverlayEntry(builder: (_) => child!)],
            ),
          ),
        );
      },
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
    ),
  );
}

Future<void> _initDeepLinks() async {
  final appLinks = AppLinks();

  final initial = await appLinks.getInitialLink();
  final initialStr = initial?.toString();
  if (initial != null) _handleUri(initial);

  final DateTime initTime = DateTime.now();
  bool skipped = false;

  appLinks.uriLinkStream.listen((uri) {
    final s = uri.toString();

    // Dedupe
    if (initialStr != null &&
        initialStr == s &&
        !skipped &&
        DateTime.now().difference(initTime) < const Duration(seconds: 5)) {
      skipped = true;
      return;
    }

    _handleUri(uri);
  });
}

void _handleUri(Uri uri) {
  final eventId = eventIdFromDeepLink(uri);
  if (eventId != null) {
    unawaited(EventDeepLinkService.ensureRegistered().openEvent(eventId));
    unawaited(
      FirebaseAnalytics.instance.logEvent(
        name: 'deep_link_event_detail',
        parameters: {'id': eventId.toString()},
      ),
    );
    return;
  }

  // https://www.dutyit.net/visitEvent/123
  if (uri.scheme == 'https' &&
      uri.host.toLowerCase() == 'www.dutyit.net' &&
      uri.pathSegments.isNotEmpty &&
      uri.pathSegments.first == 'visitEvent') {
    final id = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
    if (id != null && id.isNotEmpty) {
      launchUrl(uri);

      FirebaseAnalytics.instance.logEvent(
        name: 'deep_link_visitEvent',
        parameters: {'id': id},
      );
      return;
    }
  }
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
      minimumFetchInterval: 60,
      stopOnTerminate: false,
      enableHeadless: true,
      requiresBatteryNotLow: true,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
      requiredNetworkType: NetworkType.ANY,
      startOnBoot: true,
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

  if (!Get.isRegistered<AuthService>()) Get.lazyPut(() => AuthService());

  final auth = FirebaseAuth.instance;
  final uid = (await auth.authStateChanges().first)?.uid;
  var sessionChanged = false;
  final subscription = auth.authStateChanges().listen((user) {
    if (user?.uid != uid) sessionChanged = true;
  });
  ApiClient? headlessClient;
  try {
    await HomeViewCache().refresh(
      uid: uid,
      isCurrent: () => !sessionChanged && uid == auth.currentUser?.uid,
      load: (path) async {
        final client = Get.isRegistered<ApiClient>()
            ? Get.find<ApiClient>()
            : (headlessClient = ApiClient(background: true)..onStart());
        final result = await client.getEventsByUrl(path);
        return result is RequestSuccess<EventsResponse> ? result.data : null;
      },
    );
  } finally {
    await subscription.cancel();
    headlessClient?.onDelete();
    headlessClient?.dispose();
  }
}
