import 'package:duty_it/app/core/models/app_user.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _LegacyAutoAddUser extends AuthService {
  // This stub does not initialize production storage or login providers.
  @override
  // ignore: must_call_super
  void onInit() {}
  @override
  bool isLoggined() => true;
  @override
  AppUser get appUser => const AppUser(id: 1, autoAddBookmarkToCalendar: true);
  @override
  Future<AppUser?> ensureAppUserLoaded() async => appUser;
}

class _Analytics extends Fake implements FirebaseAnalytics {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #logEvent) return Future<void>.value();
    return super.noSuchMethod(invocation);
  }
}

class _Bookmarks extends HomeViewController {
  _Bookmarks() : super(analytics: _Analytics());
  int changes = 0;
  @override
  Future<bool> toggleBookmark(Event event) async {
    changes++;
    return !event.isBookmarked;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(Get.reset);

  test(
    'legacy automatic setting cannot create or delete a device event on bookmark',
    () async {
      Get.put<AuthService>(_LegacyAutoAddUser());
      // CalendarService and navigation are deliberately absent: bookmarks no
      // longer need either permission prompts or device calendar operations.
      final controller = _Bookmarks();
      final event = const Event(id: 42).obs;
      await controller.onBookmarkButtonClick(event);
      expect(event.value.isBookmarked, isTrue);
      await controller.onBookmarkButtonClick(event);
      expect(event.value.isBookmarked, isFalse);
      expect(controller.changes, 2);
    },
  );
}
