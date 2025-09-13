import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:duty_it/app/models/alarm_settings.dart';
import 'package:duty_it/app/models/app_user.dart';
import 'package:duty_it/app/models/event.dart';
import 'package:duty_it/app/models/event_type.dart';
import 'package:duty_it/app/models/host.dart';
import 'package:duty_it/app/models/login_result.dart';
import 'package:duty_it/app/models/server_fail.dart';
import 'package:duty_it/app/models/sort_direction.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class ApiClient extends GetConnect {
  Future<RequestResult<LoginResult>>? _loginFuture;
  String? _token;

  @override
  void onInit() {
    super.onInit();

    httpClient.baseUrl = dotenv.env['server'];
    httpClient.timeout = const Duration(seconds: 15);
    httpClient.defaultContentType = 'application/json';

    httpClient.addRequestModifier<void>((request) async {
      final path = request.url.path;
      final isAuthPath = path.contains('/auth/');
      if (isAuthPath) return request;

      await _loginFuture;
      if (_token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
      }

      return request;
    });

    httpClient.addAuthenticator<void>((request) async {
      final path = request.url.path;
      if (path.contains('/auth/')) return request;

      await loginAndRefreshToken();
      if (_token == null || _token!.isEmpty) return request;

      request.headers['Authorization'] = 'Bearer $_token';
      if (kDebugMode) log(request.toString());
      return request;
    });

    httpClient.maxAuthRetries = 1;

    loginAndRefreshToken();
  }

  Map<String, String> _cleanQuery(Map<String, dynamic> raw) {
    final m = <String, String>{};
    raw.forEach((k, v) {
      if (v != null) m[k] = "$v";
    });
    return m;
  }

  RequestResult<T> _wrap<T>(Response rp, T Function(Response rp)? map) {
    if (rp.isOk || rp.statusCode == 201 || rp.statusCode == 204) {
      try {
        if (T == EmptyBody) {
          return RequestSuccess<T>(EmptyBody() as T);
        }

        return RequestSuccess<T>(map!(rp));
      } catch (e, s) {
        if (kDebugMode) rethrow;

        FirebaseCrashlytics.instance.recordError(e, s, fatal: false);

        return RequestFail(
          Response(
            statusCode: 500,
            statusText: 'DECODE_ERROR',
            bodyString: json.encode(
              ServerFail(
                code: 'DECODE_ERROR',
                message: '서버의 응답을 처리하지 못했어요.',
                timestamp: DateTime.now(),
              ).toJson(),
            ),
          ),
        );
      }
    }
    return RequestFail(rp);
  }

  Future<RequestResult<T>> _send<T>(
    Future<Response> Function() reqFn, {
    T Function(Response rp)? map,
  }) async {
    try {
      final rp = await reqFn();
      return _wrap<T>(rp, map);
    } on TimeoutException {
      return RequestFail(
        Response(
          statusCode: 408,
          statusText: 'Request Timeout',
          bodyString: json.encode(
            ServerFail(
              code: 'TIMEOUT',
              message: '요청 시간이 초과되었습니다.',
              timestamp: DateTime.now(),
            ).toJson(),
          ),
        ),
      );
    } on SocketException {
      return RequestFail(
        Response(
          statusCode: 0,
          statusText: 'Network Error',
          bodyString: json.encode(
            ServerFail(
              code: 'NETWORK_ERROR',
              message: '네트워크 연결을 확인해 주세요.',
              timestamp: DateTime.now(),
            ).toJson(),
          ),
        ),
      );
    } catch (e, s) {
      if (kDebugMode) rethrow;
      FirebaseCrashlytics.instance.recordError(e, s, fatal: false);
      return RequestFail(
        Response(
          statusCode: -1,
          statusText: 'Unhandled Exception',
          bodyString: json.encode(
            ServerFail(
              code: 'UNHANDLED',
              message: '알 수 없는 오류가 발생했어요.',
              timestamp: DateTime.now(),
            ).toJson(),
          ),
        ),
      );
    }
  }

  /// 소셜 로그인 (auth/social)
  Future<RequestResult<LoginResult>> loginAndRefreshToken() {
    if (_loginFuture != null) {
      return _loginFuture!;
    }

    var future = Future<RequestResult<LoginResult>>(() async {
      String? fbToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      return await _send(
        () async => await post('/auth/social', "$fbToken"),
        map: (rp) {
          LoginResult result = LoginResult.fromJson(
            json.decode(rp.bodyString!),
          );
          _token = result.accessToken;

          Get.find<AuthService>().appUser = result.user;

          return result;
        },
      );
    }).whenComplete(() => _loginFuture = null);

    _loginFuture = future;
    return future;
  }

  // ---------- User ----------

  /// 현재 사용자 정보 조회 (/users/me) - GET
  Future<RequestResult<AppUser>> getCurrentUser() async {
    return _send(
      () async => await get('/users/me'),
      map: (rp) {
        AppUser user = AppUser.fromJson(json.decode(rp.bodyString!));

        Get.find<AuthService>().appUser = user;

        return user;
      },
    );
  }

  Future<RequestResult<AppUser>> updateUserSettings(
    bool autoAddBookmarkToCalendar,
    AlarmSettings alarmSettings,
  ) {
    return _send(
      () async => await patch(
        '/users/settings',
        _cleanQuery({
          'autoAddBookmarkToCalendar': autoAddBookmarkToCalendar,
          'alarmSettings': json.encode(alarmSettings.toJson()),
        }),
      ),
      map: (rp) {
        AppUser user = AppUser.fromJson(json.decode(rp.bodyString!));

        Get.find<AuthService>().appUser = user;

        return user;
      },
    );
  }

  /// 닉네임 중복 확인 (/users/check-nickname?nickname=) - GET
  Future<RequestResult<bool>> isNicknameAvailable(String nickname) async {
    return _send(
      () async =>
          await get('/users/check-nickname', query: {'nickname': nickname}),
      map: (_) => true,
    );
  }

  /// 현재 사용자 닉네임 수정 (/users/nickname) - PATCH
  Future<RequestResult<bool>> updateCurrentUserNickname(String nickname) async {
    return _send(
      () async => await patch(
        '/users/nickname',
        jsonEncode({'nickname': nickname.trim()}),
      ),
      map: (_) => true,
    );
  }

  /// 회원탈퇴 (/users/{userId}) - DELETE
  Future<RequestResult<void>> withdrawUser(int userId) async {
    return _send(() async => await delete('/users/$userId'), map: (_) => true);
  }

  // ---------- Event ----------

  /// 행사 목록 조회 (/events) - GET
  Future<RequestResult<List<Event>>> getEvents({
    bool isApproved = true,
    bool includeFinished = false,
    bool isBookmarked = false,
    int page = 0,
    int size = 10,
    SortDirection sortDirection = SortDirection.DESC, // 'ASC' | 'DESC'
    String field = 'ID', // 'ID' | 'NAME'
    required List<EventType>
    types, // 'CONFERENCE' | 'SEMINAR' | 'WEBINAR' | 'WORKSHOP' | 'CONTEST' | 'ETC'
    int? hostId,
    String? searchKeyword,
  }) async {
    String query =
        "isApproved=$isApproved&includeFinished=$includeFinished&isBookmarked=$isBookmarked&page=$page&size=$size&sortDirection=${sortDirection.name}&field=$field";
    for (var type in types) {
      query += "&type=${type.name}";
    }
    if (hostId != null) {
      query += "&hostId=$hostId";
    }
    if (searchKeyword != null) {
      query += "&searchKeyword=${Uri.encodeQueryComponent(searchKeyword)}";
    }

    return _send(
      () async => await get('/events?$query'),
      map: (rp) {
        List<Event> events = [];
        for (Map ele in List.from(json.decode(rp.bodyString!)['content'])) {
          events.add(Event.fromJson(Map.from(ele)));
        }
        return events;
      },
    );
  }

  /// 북마크한 행사 달력 조회 (/events/calendar) - GET
  Future<RequestResult<List<Event>>> getEventsForCalendar({
    required int year,
    required int month,
    EventType? type, // 'CONFERENCE' | ... | 'ETC'
  }) async {
    return _send(
      () async => await get(
        '/events/calendar',
        query: _cleanQuery({'year': year, 'month': month, 'type': type?.name}),
      ),
      map: (rp) {
        List<Event> events = [];
        for (Map ele in json.decode(rp.bodyString!)) {
          events.add(Event.fromJson(ele as Map<String, dynamic>));
        }

        return events;
      },
    );
  }

  // ---------- Host ----------

  /// 주최 목록 조회 (/hosts) - GET
  Future<RequestResult<List<Host>>> getHosts({
    int page = 0,
    int size = 10,
    SortDirection? sortDirection, // 'ASC' | 'DESC'
    String? field, // 'ID' | 'NAME'
  }) async {
    return _send(
      () async => await get(
        '/hosts',
        query: _cleanQuery({
          'page': page,
          'size': size,
          'sortDirection': sortDirection?.name,
          'field': field,
        }),
      ),
      map: (rp) {
        List<Host> hosts = [];
        for (Map ele in json.decode(rp.bodyString!)['content']) {
          hosts.add(Host.fromJson(Map.from(ele)));
        }

        return hosts;
      },
    );
  }

  // ---------- Bookmark ----------

  /// 북마크 토글 (/bookmarks/{eventId}) - POST (200)
  Future<RequestResult<bool>> toggleBookmark(int eventId) async {
    return _send(
      () async => await post('/bookmarks/$eventId', null),
      map: (rp) => json.decode(rp.bodyString!)['isBookmarked'] as bool,
    );
  }

  // ---------- View ----------

  /// 조회수 증가 (/views/{eventId}) - PATCH (204)
  Future<void> increaseViewCount(int eventId) async {
    await patch('/views/$eventId', null);
  }
}

sealed class RequestResult<T> {}

class RequestSuccess<T> extends RequestResult<T> {
  final T data;

  RequestSuccess(this.data);
}

class RequestFail extends RequestResult<Never> {
  final Response? response;
  late final ServerFail? serverFail;

  RequestFail(this.response) {
    if (response != null && response!.bodyString != null) {
      try {
        serverFail = ServerFail.fromJson(json.decode(response!.bodyString!));
      } catch (e, s) {
        if (kDebugMode) print(e);
        serverFail = null;
        FirebaseCrashlytics.instance.recordError(e, s, fatal: false);
      }
    } else {
      serverFail = null;
    }
  }
}

class EmptyBody {}
