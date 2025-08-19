import 'dart:async';

import 'package:duty_it/app/core/events/app_event.dart';
import 'package:duty_it/app/core/events/event_bookmark_event.dart';
import 'package:duty_it/app/services/app_event_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_review/in_app_review.dart';

class InAppReviewService extends GetxService with WidgetsBindingObserver {
  static const Duration _timerDuration = Duration(seconds: 10);
  static const String _requestCountKey = "review_req_count";
  static const String _bookmarkCountKey = "bookmark_count";
  static const String _foregroundTimeKey = "foreground_time";

  final InAppReview inAppReview = InAppReview.instance;
  Timer? timer;
  late final GetStorage _box;

  RxInt requestCount = RxInt(0);
  RxInt bookmarkCount = RxInt(0);
  RxInt foregroundTime = RxInt(0);

  WidgetsBinding get binding => WidgetsBinding.instance;
  bool get isForeground => binding.lifecycleState == AppLifecycleState.resumed;

  @override
  void onInit() async {
    super.onInit();

    await GetStorage.init('inAppReview');
    _box = GetStorage('inAppReview');

    binding.addObserver(this);

    requestCount.value = _box.read<int>(_requestCountKey) ?? 0;
    bookmarkCount.value = _box.read<int>(_bookmarkCountKey) ?? 0;
    foregroundTime.value = _box.read<int>(_foregroundTimeKey) ?? 0;

    debounce(requestCount, (v) {
      _box.write(_requestCountKey, v);
    }, time: Duration(milliseconds: 500));

    debounce(bookmarkCount, (v) {
      _box.write(_bookmarkCountKey, v);
    }, time: Duration(milliseconds: 500));

    ever(foregroundTime, (v) {
      _box.write(_foregroundTimeKey, v);
    });

    var eventService = Get.find<AppEventService>();
    eventService.addListener(EventBookmarkEvent, _handleEventBookmarkEvent);

    _startTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (isForeground) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  void _handleEventBookmarkEvent(AppEvent e) async {
    bookmarkCount += 1;
    showPopup();
    _startTimer();
  }

  Future<bool> showPopup() async {
    bool canShow = await _shouldShow();
    if (!canShow) return false;

    requestCount++;
    if (!kIsWeb) inAppReview.requestReview();
    return true;
  }

  Future<bool> _shouldShow() async {
    if (kDebugMode) {
      print(
        "${bookmarkCount.value} 북마크, ${requestCount.value}회 요청, ${Duration(seconds: foregroundTime.value).inMinutes}분 사용",
      );
    }

    if (!kIsWeb && !await inAppReview.isAvailable()) return false;
    if (bookmarkCount.value == 3) return true;
    if (requestCount.value == 1 &&
        Duration(seconds: foregroundTime.value).inMinutes > 30 &&
        bookmarkCount.value >= 8) {
      // 북마크 8번 이상, 요청 횟수 1회, 30분 이상 앱 사용
      return true;
    }
    return false;
  }

  void _startTimer() {
    if (bookmarkCount < 3 && requestCount < 2) {
      return; // 북마크 3회 이상, 리뷰 요청 2회 미만일 경우에만 체류시간 측정
    }

    timer?.cancel();

    timer = Timer.periodic(_timerDuration, _timerTick);
  }

  void _stopTimer() {
    timer?.cancel();
    timer = null;
  }

  void _timerTick(Timer t) {
    if (!isForeground) {
      _stopTimer();
      return;
    }

    foregroundTime += _timerDuration.inSeconds;
  }
}
