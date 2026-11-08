// ignore_for_file: depend_on_referenced_packages

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/models/event_detail.dart';
import 'package:duty_it/app/modules/event/views/event_detail_view.dart';
import 'package:duty_it/app/modules/login/bindings/login_binding.dart';
import 'package:duty_it/app/modules/login/views/login_view.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class _Auth extends AuthService {
  bool loggedIn = false;

  @override
  // The fixture supplies auth state without production storage or providers.
  // ignore: must_call_super
  void onInit() {}
  @override
  bool isLoggined() => loggedIn;
}

class _Api extends ApiClient {
  @override
  void onInit() {}
  @override
  Future<void> increaseViewCount(int eventId) async {}
}

class _Launcher extends UrlLauncherPlatform with MockPlatformInterfaceMixin {
  final calls = <(String, PreferredLaunchMode)>[];

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    calls.add((url, options.mode));
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const analytics = MethodChannel('plugins.flutter.io/firebase_analytics');
  late UrlLauncherPlatform previousLauncher;
  late _Launcher launcher;
  late _Auth auth;

  setUpAll(() async {
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(analytics, (_) async => null);
  });
  setUp(() {
    Get.reset();
    Get.testMode = true;
    previousLauncher = UrlLauncherPlatform.instance;
    launcher = _Launcher();
    UrlLauncherPlatform.instance = launcher;
    auth = Get.put<AuthService>(_Auth()) as _Auth;
    Get.put<ApiClient>(_Api());
  });
  tearDown(() {
    UrlLauncherPlatform.instance = previousLauncher;
    Get.reset();
  });

  for (final loggedIn in [false, true]) {
    testWidgets('organizer CTA checks the current login state ($loggedIn)', (
      tester,
    ) async {
      // Start with the opposite state to catch a stale check from page build.
      auth.loggedIn = !loggedIn;
      const event = Event(
        id: 0,
        title: '행사',
        uri: 'https://organizer.example/apply?event=7',
      );
      await tester.pumpWidget(
        GetMaterialApp(
          getPages: [
            GetPage(
              name: Routes.LOGIN,
              page: () => const LoginView(),
              binding: LoginBinding(),
            ),
          ],
          home: EventDetailView(
            eventRx: event.obs,
            initialDetail: const EventDetail(
              event: event,
              status: 'RECRUITING',
              viewCount: 0,
            ),
            onBookmarkTap: () async {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      auth.loggedIn = loggedIn;
      await tester.tap(find.text('주최 페이지에서 자세히 보기'));
      await tester.pumpAndSettle();

      if (loggedIn) {
        expect(find.byType(LoginView), findsNothing);
        expect(launcher.calls, hasLength(1));
        final (url, mode) = launcher.calls.single;
        final uri = Uri.parse(url);
        expect(uri.host, 'organizer.example');
        expect(uri.queryParameters['event'], '7');
        expect(uri.queryParameters['utm_source'], 'www.dutyit.net');
        expect(mode, PreferredLaunchMode.externalApplication);
      } else {
        expect(Get.currentRoute, Routes.LOGIN);
        expect(find.byType(LoginView), findsOneWidget);
        expect(launcher.calls, isEmpty);
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.byType(EventDetailView), findsOneWidget);
        expect(launcher.calls, isEmpty);
      }
      expect(tester.takeException(), isNull);
    });
  }
}
