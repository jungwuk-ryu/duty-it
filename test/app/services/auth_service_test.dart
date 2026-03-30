import 'dart:io';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/models/app_user.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');

  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return Directory.systemTemp.path;
      }
      return null;
    });

    await GetStorage.init(AuthService.storageBoxName);
  });

  setUp(() async {
    Get.reset();
    await GetStorage(AuthService.storageBoxName).erase();
  });

  tearDown(Get.reset);

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
  });

  test('loads app user when login state is true and cache is empty', () async {
    var loadCount = 0;
    final service = Get.put(
      AuthService(
        currentUserLoader: () async {
          loadCount++;
          return RequestSuccess(
            AppUser(
              id: 1,
              nickname: '듀잇',
            ),
          );
        },
        loggedInChecker: () => true,
      ),
    );

    final user = await service.ensureAppUserLoaded();

    expect(user?.id, 1);
    expect(service.appUser?.nickname, '듀잇');
    expect(loadCount, 1);
  });

  test('deduplicates concurrent app user loads', () async {
    var loadCount = 0;
    final service = Get.put(
      AuthService(
        currentUserLoader: () async {
          loadCount++;
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return RequestSuccess(const AppUser(id: 7));
        },
        loggedInChecker: () => true,
      ),
    );

    final results = await Future.wait([
      service.ensureAppUserLoaded(),
      service.ensureAppUserLoaded(),
    ]);

    expect(results[0]?.id, 7);
    expect(results[1]?.id, 7);
    expect(loadCount, 1);
  });

  test('skips loading when login state is false', () async {
    var loadCount = 0;
    final service = Get.put(
      AuthService(
        currentUserLoader: () async {
          loadCount++;
          return RequestSuccess(const AppUser(id: 3));
        },
        loggedInChecker: () => false,
      ),
    );

    final user = await service.ensureAppUserLoaded();

    expect(user, isNull);
    expect(loadCount, 0);
  });
}
