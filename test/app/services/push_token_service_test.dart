import 'dart:async';

import 'package:duty_it/app/services/push_token_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _Device {
  String? uid = 'A';
  final auth = StreamController<String?>.broadcast(sync: true);
  final tokens = StreamController<String>.broadcast(sync: true);
  final requests = <String>[];
  String? nativeToken;
  Future<String?> Function()? lookup;
  Future<bool> Function()? patch;
  Future<bool> Function()? remove;
  int rotations = 0;

  late final service = PushTokenService(
    currentUid: () => uid,
    authChanges: auth.stream,
    tokenChanges: tokens.stream,
    loadToken: () async => lookup == null ? nativeToken : await lookup!(),
    register: (token) async {
      requests.add('PATCH $uid $token');
      return await patch?.call() ?? true;
    },
    unregister: (token) async {
      requests.add('DELETE $uid $token');
      return await remove?.call() ?? true;
    },
    deleteToken: () async {
      rotations++;
    },
  );
  void changeUser(String? next) {
    uid = next;
    auth.add(next);
  }

  void refresh(String token) {
    nativeToken = token;
    tokens.add(token);
  }

  void close() {
    service.onClose();
    auth.close();
    tokens.close();
  }
}

void main() {
  testWidgets(
    'waits for a token, backs off after server failure and syncs rotation',
    (tester) async {
      final device = _Device();
      var accepted = false;
      device.patch = () async => accepted;
      device.service.onInit();
      await tester.pump();
      expect(device.requests, isEmpty);
      device.nativeToken = 'token1';
      await tester.pump(const Duration(seconds: 1));
      expect(device.requests, ['PATCH A token1']);
      accepted = true;
      await tester.pump(const Duration(seconds: 1));
      expect(device.requests.length, 1);
      await tester.pump(const Duration(seconds: 1));
      device.refresh('token2');
      await tester.pump();
      device.refresh('token2');
      await tester.pump();
      expect(device.requests, [
        'PATCH A token1',
        'PATCH A token1',
        'PATCH A token2',
      ]);
      device.close();
      await tester.pump(const Duration(minutes: 10));
      expect(device.requests.length, 3);
    },
  );

  testWidgets('ignores an old account token lookup and guest refresh events', (
    tester,
  ) async {
    final device = _Device();
    final delayed = Completer<String?>();
    device.lookup = () => delayed.future;
    device.service.onInit();
    await tester.pump();
    device.changeUser(null);
    device.refresh('guest-token');
    await tester.pump();
    device.lookup = null;
    device.nativeToken = 'new-token';
    device.changeUser('B');
    await tester.pump();
    delayed.complete('old-token');
    await tester.pump();
    expect(device.requests, ['PATCH B new-token']);
    device.close();
  });

  testWidgets(
    'finishes an in-flight register before logout removes the same token',
    (tester) async {
      final device = _Device()..nativeToken = 'one';
      final patch = Completer<bool>();
      device.patch = () => patch.future;
      device.service.onInit();
      await tester.pump();
      final removed = device.service.unregisterForLogout();
      device.refresh('another');
      await tester.pump();
      expect(device.requests, ['PATCH A one']);
      patch.complete(true);
      await tester.pump();
      expect(await removed, isTrue);
      expect(device.requests, ['PATCH A one', 'DELETE A one']);
      device.changeUser(null);
      device.changeUser('A');
      await tester.pump();
      expect(device.requests.last, 'PATCH A another');
      device.close();
    },
  );

  testWidgets(
    'retires the token after the logout budget with no late DELETE as another user',
    (tester) async {
      final device = _Device()..nativeToken = 'one';
      final patch = Completer<bool>();
      device.patch = () => patch.future;
      device.service.onInit();
      await tester.pump();
      final removed = device.service.unregisterForLogout();
      await tester.pump(const Duration(seconds: 3));
      expect(await removed, isFalse);
      expect(device.rotations, 1);
      device.changeUser(null);
      device.patch = null;
      device.nativeToken = 'fresh';
      device.changeUser('B');
      patch.complete(true);
      await tester.pump();
      expect(device.requests, ['PATCH A one', 'PATCH B fresh']);
      device.close();
    },
  );
}
