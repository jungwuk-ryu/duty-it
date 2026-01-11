import 'package:duty_it/app/core/models/events_response.dart';
import 'package:get_storage/get_storage.dart';

class HomeViewCache {
  static final String boxName = "homeContainer";
  static const int _cacheValidityInDays = 7;
  static const String _eventListKey = "event_list";
  static const String _eventsUrlKey = "request_url";
  static const String _eventsLastUpdateCacheKey = "last_update";

  final GetStorage _box = GetStorage(boxName);

  EventsResponse? getEvents() {
    final Map? listCache = _box.read(_eventListKey);
    final int? lastUpdateMills = _box.read(_eventsLastUpdateCacheKey);
    final DateTime? lastUpdate = lastUpdateMills != null
        ? DateTime.fromMillisecondsSinceEpoch(lastUpdateMills)
        : null;
    final bool isValid =
        lastUpdate != null &&
        DateTime.now().difference(lastUpdate).inDays < _cacheValidityInDays &&
        listCache != null;

    if (!isValid) return null;

    return EventsResponse.fromJson(Map<String, dynamic>.from(listCache));
  }

  Future<void> saveEvents(EventsResponse rep) async {
    await Future.wait([
      _box.write(_eventListKey, rep.toJson()),
      if (rep.reqUrl != null) _box.write(_eventsUrlKey, rep.reqUrl),
      _box.write(
        _eventsLastUpdateCacheKey,
        DateTime.now().millisecondsSinceEpoch,
      ),
    ]);
  }

  String? getEventsUrl() {
    return _box.read(_eventsUrlKey);
  }
}
