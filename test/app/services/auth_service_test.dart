import 'dart:async';
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
  const authBoxName = 'authServiceTestBox';

  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (methodCall) async {
          if (methodCall.method == 'getApplicationDocumentsDirectory') {
            return Directory.systemTemp.path;
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
  });

  test('loads app user when login state is true and cache is empty', () async {
    var loadCount = 0;
    final service = Get.put(
      AuthService(
        currentUserLoader: () async {
          loadCount++;
          return RequestSuccess(AppUser(id: 1, nickname: '듀잇'));
        },
        loggedInChecker: () => true,
        storageFactory: (_) => GetStorage(authBoxName),
        analyticsUserIdSetter: (_) async {},
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
        storageFactory: (_) => GetStorage(authBoxName),
        analyticsUserIdSetter: (_) async {},
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
        storageFactory: (_) => GetStorage(authBoxName),
        analyticsUserIdSetter: (_) async {},
      ),
    );

    final user = await service.ensureAppUserLoaded();

    expect(user, isNull);
    expect(loadCount, 0);
  });

  test('restores the shared member ID from an authenticated cache', () async {
    await GetStorage(authBoxName).write(
      'app_user',
      const AppUser(id: 42, email: 'private@example.test').toJson(),
    );
    final ids = <String?>[];
    final service = Get.put(
      AuthService(
        loggedInChecker: () => true,
        storageFactory: (_) => GetStorage(authBoxName),
        analyticsUserIdSetter: (id) async {
          ids.add(id);
        },
      ),
    );

    await service.syncAnalyticsUserId();
    expect(ids, ['42']);
  });

  test(
    'clears a persisted Analytics ID for a guest with a stale cache',
    () async {
      await GetStorage(
        authBoxName,
      ).write('app_user', const AppUser(id: 42).toJson());
      final ids = <String?>[];
      final service = Get.put(
        AuthService(
          loggedInChecker: () => false,
          storageFactory: (_) => GetStorage(authBoxName),
          analyticsUserIdSetter: (id) async {
            ids.add(id);
          },
        ),
      );

      await service.syncAnalyticsUserId();
      expect(service.appUser, isNull);
      expect(ids, [null]);
    },
  );

  test('waits for identity before returning a loaded member', () async {
    final ids = <String?>[];
    final service = Get.put(
      AuthService(
        currentUserLoader: () async => RequestSuccess(const AppUser(id: 42)),
        loggedInChecker: () => true,
        storageFactory: (_) => GetStorage(authBoxName),
        analyticsUserIdSetter: (id) async {
          ids.add(id);
        },
      ),
    );

    await service.ensureAppUserLoaded();
    service.appUser = const AppUser(id: 42, nickname: 'changed');
    await service.syncAnalyticsUserId();
    expect(ids, [null, '42']);
  });

  test(
    'serializes a slow identity update before account switch and logout',
    () async {
      final ids = <String?>[];
      final pending = Completer<void>();
      final started = Completer<void>();
      final service = Get.put(
        AuthService(
          loggedInChecker: () => true,
          storageFactory: (_) => GetStorage(authBoxName),
          analyticsUserIdSetter: (id) async {
            if (id == '42') {
              started.complete();
              await pending.future;
            }
            ids.add(id);
          },
        ),
      );
      await service.syncAnalyticsUserId();

      service.appUser = const AppUser(id: 42);
      await started.future;
      service.appUser = const AppUser(id: 84);
      service.appUser = null;
      final cleared = service.syncAnalyticsUserId();
      pending.complete();
      await cleared;
      expect(ids, [null, '42', '84', null]);
    },
  );

  test(
    'an Analytics failure does not fail login or prevent clearing',
    () async {
      final ids = <String?>[];
      final service = Get.put(
        AuthService(
          currentUserLoader: () async => RequestSuccess(const AppUser(id: 42)),
          loggedInChecker: () => true,
          storageFactory: (_) => GetStorage(authBoxName),
          analyticsUserIdSetter: (id) async {
            if (id == '42') throw StateError('Analytics unavailable');
            ids.add(id);
          },
        ),
      );

      expect((await service.ensureAppUserLoaded())?.id, 42);
      service.appUser = null;
      await service.syncAnalyticsUserId();
      expect(ids.last, isNull);
    },
  );

  test(
    'a member load completed after logout cannot restore its identity',
    () async {
      var loggedIn = true;
      final pending = Completer<RequestResult<AppUser>>();
      final ids = <String?>[];
      final service = Get.put(
        AuthService(
          currentUserLoader: () => pending.future,
          loggedInChecker: () => loggedIn,
          storageFactory: (_) => GetStorage(authBoxName),
          analyticsUserIdSetter: (id) async {
            ids.add(id);
          },
        ),
      );

      final loaded = service.ensureAppUserLoaded();
      loggedIn = false;
      service.appUser = null;
      pending.complete(RequestSuccess(const AppUser(id: 42)));
      expect(await loaded, isNull);
      await service.syncAnalyticsUserId();
      expect(ids, [null]);
    },
  );

  test('a previous member load cannot replace a new account', () async {
    final pending = Completer<RequestResult<AppUser>>();
    final ids = <String?>[];
    final service = Get.put(
      AuthService(
        currentUserLoader: () => pending.future,
        loggedInChecker: () => true,
        storageFactory: (_) => GetStorage(authBoxName),
        analyticsUserIdSetter: (id) async {
          ids.add(id);
        },
      ),
    );

    final loaded = service.ensureAppUserLoaded();
    service.appUser = const AppUser(id: 84);
    pending.complete(RequestSuccess(const AppUser(id: 42)));
    expect((await loaded)?.id, 84);
    await service.syncAnalyticsUserId();
    expect(ids.last, '84');
    expect(ids, isNot(contains('42')));
  });
}
