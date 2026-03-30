import 'dart:io';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/models/app_user.dart';
import 'package:duty_it/app/modules/settings/controllers/settings_view_controller.dart';
import 'package:duty_it/app/modules/settings/models/alarm_settings.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FakeApiClient extends ApiClient {
  FakeApiClient({
    required this.onUpdateUserSettings,
  });

  final Future<RequestResult<AppUser>> Function(bool, AlarmSettings)
  onUpdateUserSettings;

  @override
  void onInit() {}

  @override
  Future<RequestResult<AppUser>> updateUserSettings(
    bool autoAddBookmarkToCalendar,
    AlarmSettings alarmSettings,
  ) {
    return onUpdateUserSettings(autoAddBookmarkToCalendar, alarmSettings);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  const authBoxName = 'settingsAuthServiceTestBox';

  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return Directory.systemTemp.path;
      }
      return null;
    });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (methodCall) async {
      if (methodCall.method == 'HapticFeedback.vibrate') {
        return null;
      }
      return null;
    });

    await GetStorage.init(authBoxName);
  });

  setUp(() async {
    Get.reset();
    await GetStorage(authBoxName).erase();
  });

  tearDown(Get.reset);

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  test('toggleAutoAdd hydrates missing user before updating settings', () async {
    bool? capturedAutoAdd;
    AlarmSettings? capturedAlarmSettings;

    Get.put(
      AuthService(
        loggedInChecker: () => true,
        currentUserLoader: () async => RequestSuccess(
          const AppUser(
            id: 1,
            autoAddBookmarkToCalendar: false,
            alarmSettings: AlarmSettings(bookmark: true),
          ),
        ),
        storageFactory: (_) => GetStorage(authBoxName),
      ),
    );
    Get.put<ApiClient>(
      FakeApiClient(
        onUpdateUserSettings: (autoAdd, alarmSettings) async {
          capturedAutoAdd = autoAdd;
          capturedAlarmSettings = alarmSettings;
          return RequestSuccess(
            AppUser(
              id: 1,
              autoAddBookmarkToCalendar: autoAdd,
              alarmSettings: alarmSettings,
            ),
          );
        },
      ),
    );

    final controller = SettingsViewController();

    await controller.toggleAutoAdd();

    expect(capturedAutoAdd, isTrue);
    expect(capturedAlarmSettings?.bookmark, isTrue);
  });

  test('toggleBookmarkNoti hydrates missing user before updating settings', () async {
    bool? capturedAutoAdd;
    AlarmSettings? capturedAlarmSettings;

    Get.put(
      AuthService(
        loggedInChecker: () => true,
        currentUserLoader: () async => RequestSuccess(
          const AppUser(
            id: 3,
            autoAddBookmarkToCalendar: true,
            alarmSettings: AlarmSettings(bookmark: false),
          ),
        ),
        storageFactory: (_) => GetStorage(authBoxName),
      ),
    );
    Get.put<ApiClient>(
      FakeApiClient(
        onUpdateUserSettings: (autoAdd, alarmSettings) async {
          capturedAutoAdd = autoAdd;
          capturedAlarmSettings = alarmSettings;
          return RequestSuccess(
            AppUser(
              id: 3,
              autoAddBookmarkToCalendar: autoAdd,
              alarmSettings: alarmSettings,
            ),
          );
        },
      ),
    );

    final controller = SettingsViewController();

    await controller.toggleBookmarkNoti();

    expect(capturedAutoAdd, isTrue);
    expect(capturedAlarmSettings?.bookmark, isTrue);
  });
}
