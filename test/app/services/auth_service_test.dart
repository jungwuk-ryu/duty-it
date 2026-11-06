import 'dart:async';
import 'dart:io';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/models/app_user.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../helpers/fake_firebase_auth.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  const authBoxName = 'authServiceTestBox';
  late FakeFirebaseAuth auth;

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
    auth = FakeFirebaseAuth()..signInAs('A');
    await GetStorage(authBoxName).erase();
  });

  tearDown(() async {
    Get.reset();
    await auth.changes.close();
  });

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
        firebaseAuth: auth,
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
        firebaseAuth: auth,
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
        firebaseAuth: auth..signInAs(null),
        storageFactory: (_) => GetStorage(authBoxName),
        analyticsUserIdSetter: (_) async {},
      ),
    );

    final user = await service.ensureAppUserLoaded();

    expect(user, isNull);
    expect(loadCount, 0);
  });

  test('restores the shared member ID from an authenticated cache', () async {
    await GetStorage(authBoxName).write('app_user', {
      'uid': 'A',
      'profile': const AppUser(id: 42, email: 'private@example.test').toJson(),
    });
    final ids = <String?>[];
    final service = Get.put(
      AuthService(
        firebaseAuth: auth,
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
          firebaseAuth: auth..signInAs(null),
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

  test(
    'never restores a profile saved by another uid or one with no owner',
    () async {
      final box = GetStorage(authBoxName);
      const privateProfile = AppUser(id: 42, email: 'private@example.test');
      for (final stale in [
        {'uid': 'A', 'profile': privateProfile.toJson()},
        privateProfile.toJson(),
      ]) {
        await box.write('app_user', stale);
        auth.signInAs('B');
        final ids = <String?>[];
        final service = Get.put(
          AuthService(
            firebaseAuth: auth,
            storageFactory: (_) => box,
            analyticsUserIdSetter: (id) async => ids.add(id),
          ),
        );
        await service.syncAnalyticsUserId();
        expect(service.appUser, isNull);
        expect(box.hasData('app_user'), isFalse);
        expect(ids, [null]);
        await Get.delete<AuthService>(force: true);
      }
    },
  );

  test(
    'account switch starts a fresh profile load without waiting for the previous uid',
    () async {
      final pendingA = Completer<RequestResult<AppUser>>();
      final pendingB = Completer<RequestResult<AppUser>>();
      final ids = <String?>[];
      var loads = 0;
      final service = Get.put(
        AuthService(
          firebaseAuth: auth,
          currentUserLoader: () =>
              ++loads == 1 ? pendingA.future : pendingB.future,
          storageFactory: (_) => GetStorage(authBoxName),
          analyticsUserIdSetter: (id) async => ids.add(id),
        ),
      );

      final old = service.ensureAppUserLoaded();
      auth.signInAs('B');
      final current = service.ensureAppUserLoaded();
      expect(loads, 2);
      pendingA.complete(RequestSuccess(const AppUser(id: 42)));
      expect(await old, isNull);
      expect(service.appUser, isNull);
      expect(GetStorage(authBoxName).hasData('app_user'), isFalse);
      pendingB.complete(RequestSuccess(const AppUser(id: 84)));
      expect((await current)?.id, 84);
      expect(ids, [null, '84']);
      final saved = GetStorage(authBoxName).read('app_user');
      expect(saved['uid'], 'B');
      expect(saved['profile']['id'], 84);
      auth.signInAs(null);
      expect(service.appUser, isNull);
      expect(GetStorage(authBoxName).hasData('app_user'), isFalse);
    },
  );

  test(
    'cached profile reads recheck the account after a delayed analytics call',
    () async {
      final writing = Completer<void>();
      final release = Completer<void>();
      final service = Get.put(
        AuthService(
          firebaseAuth: auth,
          storageFactory: (_) => GetStorage(authBoxName),
          analyticsUserIdSetter: (id) async {
            if (id == '42') {
              writing.complete();
              await release.future;
            }
          },
        ),
      );
      service.appUser = const AppUser(id: 42);
      final read = service.ensureAppUserLoaded();
      await writing.future;
      auth.signInAs('B');
      expect(service.appUser, isNull);
      service.appUser = const AppUser(id: 84);
      release.complete();
      expect(await read, isNull);
      await service.syncAnalyticsUserId();
    },
  );

  test('waits for identity before returning a loaded member', () async {
    final ids = <String?>[];
    final service = Get.put(
      AuthService(
        currentUserLoader: () async => RequestSuccess(const AppUser(id: 42)),
        firebaseAuth: auth,
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
          firebaseAuth: auth,
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
          firebaseAuth: auth,
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
      final pending = Completer<RequestResult<AppUser>>();
      final ids = <String?>[];
      final service = Get.put(
        AuthService(
          currentUserLoader: () => pending.future,
          firebaseAuth: auth,
          storageFactory: (_) => GetStorage(authBoxName),
          analyticsUserIdSetter: (id) async {
            ids.add(id);
          },
        ),
      );

      final loaded = service.ensureAppUserLoaded();
      auth.signInAs(null);
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
        firebaseAuth: auth,
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
