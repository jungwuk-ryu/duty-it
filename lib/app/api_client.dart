import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:duty_it/app/core/models/events_response.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/core/models/job_postings_response.dart';
import 'package:duty_it/app/modules/settings/models/alarm_settings.dart';
import 'package:duty_it/app/modules/settings/models/notification_subscription.dart';
import 'package:duty_it/app/modules/notifications/models/app_notification.dart';
import 'package:duty_it/app/core/models/app_user.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/models/event_detail.dart';
import 'package:duty_it/app/core/enums/event_type.dart';
import 'package:duty_it/app/core/enums/job_employment_type.dart';
import 'package:duty_it/app/core/models/host.dart';
import 'package:duty_it/app/core/enums/work_region.dart';
import 'package:duty_it/app/modules/login/models/login_result.dart';
import 'package:duty_it/app/core/models/server_fail.dart';
import 'package:duty_it/app/core/enums/sort_direction.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class ApiClient extends GetConnect {
  ApiClient({bool background = false, User? Function()? currentFirebaseUser})
    : _background = background,
      _currentUser = currentFirebaseUser ?? _firebaseUser;

  static User? _firebaseUser() => FirebaseAuth.instance.currentUser;
  final User? Function() _currentUser;
  final bool _background;
  final _requestSessionKey = Object();
  int _generation = 0;
  int _loginAttempt = 0;
  (String?, int) get _session => (_currentUser()?.uid, _generation);
  String? _loginUid;
  Future<RequestResult<LoginResult>>? _loginFuture;
  String? _tokenUid;
  String? _token;

  // GetConnect recreates the request on a 401. Keep both attempts bound to
  // the account that initiated the operation, including anonymous requests.
  String? _requestUid() {
    final session = Zone.current[_requestSessionKey] as (String?, int)?;
    if (session != _session) throw const _SessionChanged();
    return session?.$1;
  }

  @override
  void onInit() {
    super.onInit();

    httpClient.baseUrl = dotenv.env['server'];
    httpClient.timeout = const Duration(seconds: 15);
    httpClient.defaultContentType = 'application/json';
    httpClient.userAgent = buildUserAgent();

    httpClient.addRequestModifier<void>((request) async {
      final path = request.url.path;
      final isAuthPath = path.contains('/v1/auth/');
      if (isAuthPath) return request;

      final uid = _requestUid();
      final deviceRequest = path.contains('/v1/users/device/');
      if (deviceRequest && uid != null && uid != _tokenUid) {
        await loginAndRefreshToken();
      } else if (_loginUid == uid) {
        await _loginFuture;
      }
      _requestUid();
      if (deviceRequest &&
          (uid == null || uid != _tokenUid || _token == null)) {
        throw const _SessionChanged();
      }
      request.headers.remove('Authorization');
      if (uid != null && uid == _tokenUid && _token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
      }
      return request;
    });

    httpClient.addAuthenticator<void>((request) async {
      if (!request.url.path.contains('/v1/auth/') && _requestUid() != null) {
        await loginAndRefreshToken();
      }
      return request;
    });

    httpClient.maxAuthRetries = 1;

    loginAndRefreshToken();
  }

  void invalidateSession() {
    _generation++;
    _loginAttempt++;
    _loginUid = null;
    _loginFuture = null;
    _tokenUid = null;
    _token = null;
  }

  @override
  void onClose() {
    invalidateSession();
    super.onClose();
  }

  String buildUserAgent() {
    final platform = kIsWeb
        ? 'web'
        : Platform.isAndroid
        ? 'android'
        : Platform.isIOS
        ? 'ios'
        : 'unknown';

    return 'Duit-Client/1.0.0 (flutter; $platform${_background ? '; background' : ''}; ${kDebugMode ? 'debug' : 'release'})';
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
      final session = _session;
      final rp = await runZoned(
        reqFn,
        zoneValues: {_requestSessionKey: session},
      );
      if (_session != session) return RequestFail(null);
      return _wrap<T>(rp, map);
    } on _SessionChanged {
      return RequestFail(null);
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

  // ---------- Alarm ----------

  /// 알람 목록 조회 (alarms)
  Future<RequestResult<List<AppNotification>>> getNotificationList(
    int page, {
    int size = 10,
  }) async {
    return await _send(
      () async => await get(
        '/v2/alarms',
        query: {
          'page': "$page",
          'size': '$size',
          'sortDirection': 'DESC',
          'field': 'ID',
        },
      ),
      map: (rp) {
        List<AppNotification> list = [];

        var body = rp.body;
        if (body is! Map) return list;

        var rawList = body['content'];
        for (Map data in rawList) {
          list.add(AppNotification.fromJson(Map<String, dynamic>.from(data)));
        }

        return list;
      },
    );
  }

  /// 알람 모두 읽음 처리 (/alarms/read-all)
  Future<RequestResult<bool>> readAllNotification() async {
    return await _send(
      () async => await patch('/v1/alarms/read-all', null),
      map: (rp) {
        if (rp.statusCode == HttpStatus.noContent) return true;
        return false;
      },
    );
  }

  /// 알람 삭제 처리 (/alarms/{alarmId})
  Future<RequestResult<bool>> deleteNotification(int alarmId) async {
    return await _send(
      () async => await delete('/v1/alarms/$alarmId'),
      map: (rp) {
        if (rp.statusCode == HttpStatus.noContent) return true;
        return false;
      },
    );
  }

  // ---------- Auth ----------

  /// 소셜 로그인 (auth/social)
  Future<RequestResult<LoginResult>> loginAndRefreshToken() {
    final firebaseUser = _currentUser();
    final uid = firebaseUser?.uid;
    if (_tokenUid != uid) {
      _tokenUid = null;
      _token = null;
    }
    if (_loginUid == uid && _loginFuture != null) return _loginFuture!;
    _loginUid = uid;
    final attempt = ++_loginAttempt;
    return _loginFuture = _login(firebaseUser, attempt).whenComplete(() {
      if (_loginAttempt == attempt) _loginFuture = null;
    });
  }

  Future<RequestResult<LoginResult>> _login(User? user, int attempt) async {
    if (user == null) return RequestFail(null);
    String? fbToken;
    try {
      fbToken = await user.getIdToken().timeout(const Duration(seconds: 15));
    } catch (ex, st) {
      FirebaseCrashlytics.instance.recordError(ex, st);
    }

    bool active() =>
        _currentUser()?.uid == user.uid && _loginAttempt == attempt;
    if (fbToken == null || !active()) return RequestFail(null);
    final result = await _send<LoginResult>(
      () => post('/v1/auth/social', fbToken),
      map: (rp) => LoginResult.fromJson(json.decode(rp.bodyString!)),
    );
    if (!active()) return RequestFail(null);
    if (result is RequestSuccess<LoginResult>) {
      _tokenUid = user.uid;
      _token = result.data.accessToken;
      final auth = Get.find<AuthService>();
      auth.appUser = result.data.user;
      await auth.syncAnalyticsUserId();
    }
    return result;
  }

  // ---------- User ----------

  /// 현재 사용자 정보 조회 (/users/me) - GET
  Future<RequestResult<AppUser>> getCurrentUser() async {
    final uid = _currentUser()?.uid;
    final result = await _send<AppUser>(
      () async => await get('/v1/users/me'),
      map: (rp) => AppUser.fromJson(json.decode(rp.bodyString!)),
    );
    await _applyCurrentUser(result, uid);
    return result;
  }

  Future<RequestResult<AppUser>> updateUserSettings(
    AlarmSettings alarmSettings,
  ) async {
    final uid = _currentUser()?.uid;
    final result = await _send<AppUser>(
      () async => await patch('/v1/users/settings', {
        // Kept for compatibility with the settings API; device saves are manual.
        'autoAddBookmarkToCalendar': false,
        'alarmSettings': alarmSettings.toJson(),
      }),
      map: (rp) => AppUser.fromJson(json.decode(rp.bodyString!)),
    );
    await _applyCurrentUser(result, uid);
    return result;
  }

  Future<void> _applyCurrentUser(
    RequestResult<AppUser> result,
    String? uid,
  ) async {
    if (uid == null || _currentUser()?.uid != uid) return;
    if (result is RequestSuccess<AppUser>) {
      final auth = Get.find<AuthService>();
      auth.appUser = result.data;
      await auth.syncAnalyticsUserId();
    }
  }

  /// 닉네임 중복 확인 (/users/check-nickname?nickname=) - GET
  Future<RequestResult<bool>> isNicknameAvailable(String nickname) async {
    return _send(
      () async =>
          await get('/v1/users/check-nickname', query: {'nickname': nickname}),
      map: (_) => true,
    );
  }

  /// 현재 사용자 닉네임 수정 (/users/nickname) - PATCH
  Future<RequestResult<bool>> updateCurrentUserNickname(String nickname) async {
    return _send(
      () async => await patch(
        '/v1/users/nickname',
        jsonEncode({'nickname': nickname.trim()}),
      ),
      map: (_) => true,
    );
  }

  /// 회원탈퇴 (/users) - DELETE
  Future<RequestResult<void>> withdrawUser() async {
    return _send(() async => await delete('/v1/users'), map: (_) => true);
  }

  /// 알림 - 사용자 기기 등록 (/users/device/{token}) - PATCH
  Future<RequestResult<void>> registerDevice(String token) {
    return _send(
      () => patch('/v1/users/device/${Uri.encodeComponent(token)}', {}),
      map: (_) => true,
    );
  }

  /// 알림 - 사용자 기기 삭제 (/users/device/{token}) - DELETE
  Future<RequestResult<void>> unregisterDevice(String token) {
    return _send(
      () => delete('/v1/users/device/${Uri.encodeComponent(token)}'),
      map: (_) => true,
    );
  }

  // ---------- Event ----------

  /// 행사 목록 조회 (/v2/events) - GET
  Future<RequestResult<EventsResponse>> getEvents({
    String? cursor,
    bool finished = false,
    bool bookmarked = false,
    int size = 10,
    String field = 'CREATED_AT',
    required List<EventType> types,
    int? hostId,
    String? searchKeyword,
  }) async {
    final query = Uri(
      queryParameters: {
        'bookmarked': bookmarked.toString(),
        'size': size.toString(),
        'field': field,
        'statusGroup': finished ? 'FINISHED' : 'ACTIVE',
        if (cursor != null) 'cursor': cursor,
        if (types.isNotEmpty) 'types': types.map((type) => type.name),
        if (hostId != null) 'hostId': hostId.toString(),
        if (searchKeyword != null) 'searchKeyword': searchKeyword,
      },
    ).query;

    return await getEventsByUrl('/v2/events?$query');
  }

  Future<RequestResult<EventsResponse>> getEventsByUrl(String url) async {
    return _send(
      () async => await get(url),
      map: (rp) {
        String bodyString = rp.bodyString!;
        EventsResponse rep = EventsResponse.fromJson(json.decode(bodyString));
        rep = rep.copyWith(reqUrl: rp.request?.url.toString());

        return rep;
      },
    );
  }

  /// 행사 상세 조회 (/v2/events/{eventId}) - GET
  Future<RequestResult<EventDetail>> getEventDetail(int eventId) async {
    return _send(
      () => get('/v2/events/$eventId'),
      map: (rp) => EventDetail.fromJson(
        json.decode(rp.bodyString!) as Map<String, dynamic>,
      ),
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
        '/v1/events/calendar',
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

  // ---------- Job ----------

  Future<RequestResult<JobPostingsResponse>> getJobPostings({
    String? cursor,
    required bool bookmarked,
    int size = 10,
    String field = 'CREATED_AT',
    required List<WorkRegion> workRegions,
    required List<JobEmploymentType> employmentTypes,
    String? searchKeyword,
  }) async {
    final query = Uri(
      queryParameters: {
        'bookmarked': bookmarked.toString(),
        'size': size.toString(),
        'field': field,
        if (cursor != null) 'cursor': cursor,
        if (workRegions.isNotEmpty)
          'workRegions': workRegions.map(
            (workRegion) => workRegion.name.toUpperCase(),
          ),
        if (employmentTypes.isNotEmpty)
          'employmentTypes': employmentTypes.map(
            (employmentType) => employmentType.apiValue,
          ),
        if (searchKeyword != null) 'searchKeyword': searchKeyword,
      },
    ).query;

    return _send(
      () async => await get('/v1/job-postings?$query'),
      map: (rp) => JobPostingsResponse.fromJson(json.decode(rp.bodyString!)),
    );
  }

  Future<RequestResult<JobPosting>> getJobPostingDetail(
    int jobPostingId,
  ) async {
    return _send(
      () async => await get('/v1/job-postings/$jobPostingId'),
      map: (rp) => JobPosting.fromJson(json.decode(rp.bodyString!)),
    );
  }

  Future<RequestResult<bool>> toggleJobBookmark(int jobPostingId) async {
    return _send(
      () async => await post('/v1/job-bookmarks/$jobPostingId', null),
      map: (rp) => json.decode(rp.bodyString!)['isBookmarked'] as bool,
    );
  }

  // ---------- Subscription ----------

  Future<RequestResult<List<NotificationSubscription>>> getSubscriptions({
    NotificationSubscriptionType? type,
  }) async {
    return _send(
      () async => await get(
        '/v1/subscriptions',
        query: _cleanQuery({'type': type?.serverValue}),
      ),
      map: (rp) {
        final body = rp.bodyString == null
            ? rp.body
            : json.decode(rp.bodyString!);
        if (body is! List) return <NotificationSubscription>[];

        return body
            .whereType<Map>()
            .map(
              (e) => NotificationSubscription.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList();
      },
    );
  }

  Future<RequestResult<NotificationSubscription>> createSubscription(
    NotificationSubscriptionDraft draft,
  ) async {
    return _send(
      () async => await post('/v1/subscriptions', draft.toCreateJson()),
      map: (rp) => NotificationSubscription.fromJson(
        Map<String, dynamic>.from(json.decode(rp.bodyString!)),
      ),
    );
  }

  Future<RequestResult<bool>> deleteSubscription(int subscriptionId) async {
    return _send(
      () async => await delete('/v1/subscriptions/$subscriptionId'),
      map: (rp) => rp.statusCode == HttpStatus.noContent,
    );
  }

  // ---------- Company ----------

  Future<RequestResult<List<NotificationCompany>>> getBookmarkedCompanies() {
    return _send(
      () async => await get('/v1/companies/bookmarked'),
      map: (rp) {
        final body = rp.bodyString == null
            ? rp.body
            : json.decode(rp.bodyString!);
        if (body is! List) return <NotificationCompany>[];

        return body
            .whereType<Map>()
            .map(
              (e) => NotificationCompany.fromJson(Map<String, dynamic>.from(e)),
            )
            .toList();
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
        '/v1/hosts',
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
      () async => await post('/v1/bookmarks/$eventId', null),
      map: (rp) => json.decode(rp.bodyString!)['isBookmarked'] as bool,
    );
  }

  // ---------- View ----------

  /// 조회수 증가 (/views/{eventId}) - PATCH (204)
  Future<void> increaseViewCount(int eventId) async {
    await _send(() => patch('/v1/views/$eventId', null), map: (_) => true);
  }
}

class _SessionChanged implements Exception {
  const _SessionChanged();
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
