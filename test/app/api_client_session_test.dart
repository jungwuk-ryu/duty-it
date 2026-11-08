import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/models/app_user.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _User extends Fake implements User {
  _User(this.uid);
  @override
  final String uid;
  @override
  Future<String?> getIdToken([bool forceRefresh = false]) async => uid;
}

class _Auth extends AuthService {
  @override
  // ignore: must_call_super
  void onInit() {}

  @override
  AppUser? appUser;
  @override
  Future<void> syncAnalyticsUserId() async {}
}

void main() {
  for (final nextUid in ['A', 'B']) {
    test(
      'a delayed 401 cannot replay a bookmark after signing in again as $nextUid',
      () async {
        final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
        addTearDown(() => server.close(force: true));
        dotenv.testLoad(fileInput: 'server=http://127.0.0.1:${server.port}');
        final logout = Completer<void>();
        final sent = Completer<void>();
        final headers = <String?>[];
        var loginCount = 0;
        server.listen((request) async {
          final response = request.response;
          response.headers.contentType = ContentType.json;
          if (request.uri.path == '/v1/auth/social') {
            final uid = await utf8.decoder.bind(request).join();
            response.write(
              jsonEncode({
                'accessToken': 'access-$uid-${++loginCount}',
                'user': {'id': uid == 'A' ? 1 : 2},
              }),
            );
          } else {
            headers.add(request.headers.value(HttpHeaders.authorizationHeader));
            if (headers.length == 1) {
              sent.complete();
              await logout.future;
            }
            if (headers.length == 1 ||
                request.headers.value(HttpHeaders.authorizationHeader) ==
                    null ||
                request.uri.path.endsWith('/9')) {
              response.statusCode = 401;
              response.write(
                '{"code":"UNAUTHORIZED","message":"expired","timestamp":"2026-11-06"}',
              );
            } else {
              response.write('{"isBookmarked":true}');
            }
          }
          await response.close();
        });

        User? user = _User('A');
        Get.put<AuthService>(_Auth());
        addTearDown(Get.reset);
        final api = ApiClient(currentFirebaseUser: () => user)..onInit();
        expect(await api.loginAndRefreshToken(), isA<RequestSuccess>());
        final oldMutation = api.toggleBookmark(9);
        await sent.future;
        if (nextUid == 'A') api.invalidateSession(); // Normal logout.
        user = _User(nextUid);
        // The first request of a new session cannot borrow the old bearer.
        expect(await api.toggleBookmark(7), isA<RequestSuccess>());
        logout.complete();
        expect(await oldMutation, isA<RequestFail>());
        expect(await api.toggleBookmark(8), isA<RequestSuccess>());
        expect(headers, [
          'Bearer access-A-1',
          null,
          'Bearer access-$nextUid-2',
          'Bearer access-$nextUid-2',
        ]);
      },
    );
  }
}
