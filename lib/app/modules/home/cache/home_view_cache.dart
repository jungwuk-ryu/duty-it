import 'package:duty_it/app/core/models/events_response.dart';
import 'package:get_storage/get_storage.dart';

class HomeViewCache {
  static final String boxName = "homeContainer";
  static final String eventListKey = "event_list";
  static final String eventsUrlKey = "request_url";
  static final String eventsLastUpdateCacheKey = "last_update";

  final GetStorage _box = GetStorage(boxName);

  EventsResponse? getEvents() {
    final Map? listCache = _box.read(eventListKey);
    final int? lastUpdateMills = _box.read(eventsLastUpdateCacheKey);
    final DateTime? lastUpdate = lastUpdateMills != null
        ? DateTime.fromMillisecondsSinceEpoch(lastUpdateMills)
        : null;
    final bool isValid =
        lastUpdate != null &&
        DateTime.now().difference(lastUpdate).inDays < 7 &&
        listCache != null;

    if (!isValid) return null;

    return EventsResponse.fromJson(Map<String, dynamic>.from(listCache));
  }

  Future<void> saveEvents(EventsResponse rep) async {
    await Future.wait([
      _box.write(eventListKey, rep.toJson()),
      if (rep.reqUrl != null) _box.write(eventsUrlKey, rep.reqUrl),
      _box.write(
        eventsLastUpdateCacheKey,
        DateTime.now().millisecondsSinceEpoch,
      ),
    ]);
  }

  String? getEventsUrl() {
    return _box.read(eventsUrlKey);
  }
}
