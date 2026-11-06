import 'package:duty_it/app/core/models/events_response.dart';
import 'package:get_storage/get_storage.dart';

class HomeViewCache {
  static const String boxName = 'homeContainer';
  static const _snapshotKey = 'events_snapshot_v2';
  static const _maxAge = Duration(days: 7);
  final GetStorage _box = GetStorage(boxName);

  Map<String, dynamic>? _snapshot(String? uid) {
    final row = _box.read(_snapshotKey);
    if (row is! Map<String, dynamic> ||
        !row.containsKey('uid') ||
        row['uid'] != uid) {
      return null;
    }
    final savedAt = row['savedAt'];
    if (savedAt is! int ||
        DateTime.now().difference(
              DateTime.fromMillisecondsSinceEpoch(savedAt),
            ) >=
            _maxAge) {
      return null;
    }
    return row;
  }

  EventsResponse? getEvents(String? uid) {
    final data = _snapshot(uid)?['response'];
    return data is Map<String, dynamic> ? EventsResponse.fromJson(data) : null;
  }

  // GetConnect prepends the configured API base URL. Replay only the event
  // query, never a cached absolute host or another endpoint.
  String? getEventsPath(String? uid) {
    final url = _snapshot(uid)?['requestUrl'];
    if (url is! String) return null;
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.path.endsWith('/v2/events')) return null;
    return uri.hasQuery ? '/v2/events?${uri.query}' : '/v2/events';
  }

  Future<void> refresh({
    required String? uid,
    required bool Function() isCurrent,
    required Future<EventsResponse?> Function(String path) load,
  }) async {
    final snapshot = _snapshot(uid);
    if (snapshot == null || !isCurrent()) return;
    final path = getEventsPath(uid);
    if (path == null) return;
    final response = await load(path);
    if (response != null &&
        isCurrent() &&
        identical(snapshot, _snapshot(uid))) {
      await saveEvents(uid, response);
    }
  }

  Future<void> saveEvents(String? uid, EventsResponse response) async {
    // The previous keys had no recorded owner and cannot be migrated safely.
    final legacyKeys = ['event_list', 'request_url', 'last_update'];
    await Future.wait([
      _box.write(_snapshotKey, {
        'uid': uid,
        'savedAt': DateTime.now().millisecondsSinceEpoch,
        'response': response.toJson(),
        'requestUrl': response.reqUrl,
      }),
      for (final key in legacyKeys)
        if (_box.hasData(key)) _box.remove(key),
    ]);
  }
}
