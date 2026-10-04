import 'dart:async';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/models/event_detail.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/event/views/event_detail_view.dart';
import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:get/get.dart';

/// Wait for splash initialization before opening a cold-start event link.
class EventDeepLinkService extends GetxService {
  EventDeepLinkService({
    Future<RequestResult<EventDetail>> Function(int)? fetchDetail,
    void Function(EventDetail)? showDetail,
    void Function(String)? showError,
  }) : _fetchDetail = fetchDetail ?? _fetchEventDetail,
       _showDetail = showDetail ?? _showEventDetail,
       _showError = showError ?? AppUtils.showSnackBar;

  final Future<RequestResult<EventDetail>> Function(int) _fetchDetail;
  final void Function(EventDetail) _showDetail;
  final void Function(String) _showError;
  bool _navigationReady = false;
  int? _pendingEventId;
  int? _loadingEventId;
  int _request = 0;

  void markNavigationReady() {
    _navigationReady = true;
    final eventId = _pendingEventId;
    _pendingEventId = null;
    if (eventId != null) unawaited(openEvent(eventId));
  }

  Future<void> openEvent(int eventId) async {
    if (!_navigationReady) {
      _pendingEventId = eventId;
      return;
    }
    if (_loadingEventId == eventId || Get.currentRoute == '/events/$eventId') {
      return;
    }
    final request = ++_request;
    _loadingEventId = eventId;
    try {
      final result = await _fetchDetail(eventId);
      // A newer link takes precedence over an earlier, slower API request.
      if (request != _request) return;
      if (result is RequestSuccess<EventDetail> &&
          result.data.status != 'PENDING') {
        _showDetail(result.data);
      } else {
        _showError('행사 정보를 찾을 수 없어요. 다시 시도해 주세요.');
      }
    } catch (_) {
      if (request == _request) {
        _showError('행사 정보를 불러오지 못했어요. 다시 시도해 주세요.');
      }
    } finally {
      if (request == _request) _loadingEventId = null;
    }
  }

  @override
  void onClose() {
    _request++;
    _navigationReady = false;
    super.onClose();
  }

  static Future<RequestResult<EventDetail>> _fetchEventDetail(int id) =>
      Get.find<ApiClient>().getEventDetail(id);

  static void _showEventDetail(EventDetail detail) {
    final eventRx = detail.event.obs;
    Get.to(
      () => EventDetailView(
        eventRx: eventRx,
        onBookmarkTap: () =>
            Get.find<HomeViewController>().onBookmarkButtonClick(eventRx),
      ),
      routeName: '/events/${detail.event.id}',
    );
  }
}
