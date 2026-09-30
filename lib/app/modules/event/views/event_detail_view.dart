import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/enums/event_type.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/models/event_detail.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/services/event_content_service.dart';
import 'package:duty_it/app/modules/event/widgets/event_actions_menu.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailView extends StatefulWidget {
  final Rx<Event> eventRx;
  final Future<void> Function() onBookmarkTap;

  const EventDetailView({
    super.key,
    required this.eventRx,
    required this.onBookmarkTap,
  });

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
  final EventContentService _contentService = EventContentService();
  bool _loading = true;
  bool _loadFailed = false;
  bool _bookmarkBusy = false;
  bool _bookmarkTouched = false;
  String? _status;
  int? _viewCount;
  EventContentResult? _contentResult;

  @override
  void initState() {
    super.initState();
    final eventId = widget.eventRx.value.id;
    unawaited(_recordView(eventId));
    unawaited(
      FirebaseAnalytics.instance.logSelectContent(
        contentType: 'event',
        itemId: eventId.toString(),
      ),
    );
    unawaited(_loadDetail());
    unawaited(_loadContent(eventId));
  }

  @override
  void dispose() {
    _contentService.close();
    super.dispose();
  }

  Future<void> _loadContent(int eventId) async {
    setState(() => _contentResult = null);
    final result = await _contentService.fetch(eventId);
    if (mounted) setState(() => _contentResult = result);
  }

  Future<void> _recordView(int eventId) async {
    try {
      await Get.find<ApiClient>().increaseViewCount(eventId);
    } catch (_) {
      // View telemetry must not block reading an event.
    }
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loading = true;
      _loadFailed = false;
    });
    RequestResult<EventDetail>? result;
    try {
      result = await Get.find<ApiClient>().getEventDetail(
        widget.eventRx.value.id,
      );
    } catch (_) {
      // Keep the event data already loaded in the list when detail refresh fails.
    }
    if (!mounted) return;
    if (result is RequestSuccess<EventDetail>) {
      final detail = result.data;
      widget.eventRx.value = _bookmarkTouched
          ? detail.event.copyWith(
              isBookmarked: widget.eventRx.value.isBookmarked,
            )
          : detail.event;
      setState(() {
        _status = detail.status;
        _viewCount = detail.viewCount;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
        _loadFailed = true;
      });
    }
  }

  Future<void> _toggleBookmark() async {
    if (_bookmarkBusy) return;
    setState(() => _bookmarkBusy = true);
    try {
      _bookmarkTouched = true;
      HapticFeedback.mediumImpact();
      await widget.onBookmarkTap();
    } finally {
      if (mounted) setState(() => _bookmarkBusy = false);
    }
  }

  Future<void> _openUrl(String value, {bool inApp = false}) async {
    final uri = Uri.tryParse(value);
    if (uri == null ||
        !uri.hasAuthority ||
        (uri.scheme != 'https' && uri.scheme != 'http')) {
      AppUtils.showSnackBar('링크를 열 수 없어요.');
      return;
    }
    try {
      final opened = await launchUrl(
        uri,
        mode: inApp
            ? LaunchMode.inAppBrowserView
            : LaunchMode.externalApplication,
      );
      if (!opened) AppUtils.showSnackBar('링크를 열 수 없어요.');
    } catch (_) {
      AppUtils.showSnackBar('링크를 열 수 없어요.');
    }
  }

  Future<void> _openOrganizer(String value) async {
    final uri = Uri.tryParse(value);
    if (uri == null ||
        !uri.hasAuthority ||
        (uri.scheme != 'https' && uri.scheme != 'http')) {
      AppUtils.showSnackBar('링크를 열 수 없어요.');
      return;
    }
    await _openUrl(AppUtils.setDuitUtmSource(uri).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          tooltip: '뒤로 가기',
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.black),
          onPressed: Get.back,
        ),
        title: const Text(
          '행사 상세',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Obx(
            () => EventActionsMenu(
              event: widget.eventRx.value,
              bookmarkBusy: _bookmarkBusy,
              onBookmarkTap: _toggleBookmark,
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.border),
        ),
      ),
      body: Obx(() {
        final event = widget.eventRx.value;
        return Column(
          children: [
            if (_loading)
              const LinearProgressIndicator(
                minHeight: 2,
                color: AppColors.main,
              ),
            if (_loadFailed)
              MaterialBanner(
                content: const Text('최신 행사 정보를 불러오지 못했어요.'),
                backgroundColor: AppColors.canvas,
                actions: [
                  TextButton(
                    onPressed: _loadDetail,
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _poster(event),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _tag(_category(event), AppColors.g02, AppColors.black),
                        _tag(
                          _statusLabel(event),
                          AppColors.sub,
                          AppColors.main,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      event.title,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      event.host.name,
                      style: const TextStyle(
                        color: AppColors.g05,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: 23),
                    _sectionHeading('일정 안내', trailing: '한국 시간 (KST)'),
                    const SizedBox(height: 20),
                    _scheduleRow(
                      Icons.event_outlined,
                      '행사 일시',
                      _eventPeriod(event),
                    ),
                    const SizedBox(height: 22),
                    _scheduleRow(
                      Icons.schedule_outlined,
                      '신청 마감',
                      event.recruitmentEndAt == null
                          ? '주최 페이지에서 확인해 주세요'
                          : '${_dateTime(event.recruitmentEndAt!)}까지',
                      note: event.recruitmentStartAt == null
                          ? null
                          : '신청 시작 · ${_dateTime(event.recruitmentStartAt!)}',
                    ),
                    if (_contentResult?.availability !=
                        EventContentAvailability.unavailable) ...[
                      const SizedBox(height: 28),
                      const Divider(height: 1, color: AppColors.border),
                      const SizedBox(height: 23),
                      _sectionHeading('행사 내용'),
                      const SizedBox(height: 12),
                      _contentCard(event.id),
                    ],
                    const SizedBox(height: 28),
                    const Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: 23),
                    _sectionHeading('주최 안내'),
                    const SizedBox(height: 14),
                    _hostCard(event),
                    if (_viewCount != null) ...[
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Icon(
                            Icons.visibility_outlined,
                            size: 16,
                            color: AppColors.g05,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            '조회 $_viewCount',
                            style: const TextStyle(
                              color: AppColors.g05,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.canvas,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '자세한 내용과 신청은 주최 페이지에서 확인해 주세요.',
                        style: TextStyle(
                          color: AppColors.g05,
                          fontSize: 12,
                          height: 1.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _bottomBar(event),
          ],
        );
      }),
    );
  }

  Widget _poster(Event event) {
    final hasImage = AppUtils.isHttpUrl(event.thumbnail);
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: AppColors.canvas,
              child: hasImage
                  ? CachedNetworkImage(
                      imageUrl: event.thumbnail,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorWidget: (_, __, ___) => const Icon(
                        Icons.event_note_rounded,
                        size: 64,
                        color: AppColors.g04,
                      ),
                    )
                  : const Icon(
                      Icons.event_note_rounded,
                      size: 64,
                      color: AppColors.g04,
                    ),
            ),
            if (hasImage)
              Positioned(
                right: 12,
                bottom: 12,
                child: _posterExpandButton(event),
              ),
          ],
        ),
      ),
    );
  }

  Widget _posterExpandButton(Event event) {
    final highContrast = MediaQuery.highContrastOf(context);
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(24),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: highContrast ? 0 : 12,
            sigmaY: highContrast ? 0 : 12,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: highContrast
                    ? [Colors.white, Colors.white]
                    : [
                        Colors.white.withAlpha(150),
                        Colors.white.withAlpha(58),
                        Colors.white.withAlpha(96),
                      ],
              ),
              border: Border.all(
                color: Colors.white.withAlpha(190),
                width: 0.8,
              ),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: IconButton(
                tooltip: '포스터 전체 보기',
                onPressed: () => _showPoster(event),
                style: IconButton.styleFrom(
                  foregroundColor: AppColors.black,
                  overlayColor: Colors.white.withAlpha(90),
                  shape: const CircleBorder(),
                ),
                icon: const Icon(Icons.open_in_full_rounded, size: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _contentCard(int eventId) {
    final result = _contentResult;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.sub,
        border: Border.all(color: AppColors.main.withAlpha(45)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: result == null
          ? const Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('행사 내용을 불러오는 중이에요.'),
              ],
            )
          : result.availability == EventContentAvailability.available
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 16,
                      color: AppColors.main,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'AI로 정리했어요',
                      style: TextStyle(
                        color: AppColors.main,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SelectableText(
                  result.body!,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    height: 1.75,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'AI가 행사 자료를 바탕으로 정리한 내용으로, 일부 정보가 정확하지 않을 수 있어요. 신청 전 주최 페이지에서 확인해 주세요.',
                  style: TextStyle(
                    color: AppColors.g05,
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('행사 내용을 불러오지 못했어요.'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    TextButton(
                      onPressed: () => _loadContent(eventId),
                      child: const Text('다시 시도'),
                    ),
                    TextButton.icon(
                      onPressed: () => _openUrl(
                        'https://www.dutyit.net/events/$eventId',
                        inApp: true,
                      ),
                      icon: const Icon(Icons.open_in_new_rounded, size: 17),
                      label: const Text('웹에서 보기'),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  void _showPoster(Event event) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog.fullscreen(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            title: const Text('행사 포스터'),
            backgroundColor: AppColors.white,
            leading: IconButton(
              tooltip: '닫기',
              onPressed: () => Navigator.of(dialogContext).pop(),
              icon: const Icon(Icons.close_rounded),
            ),
          ),
          body: InteractiveViewer(
            minScale: 1,
            maxScale: 4,
            child: Center(
              child: CachedNetworkImage(
                imageUrl: event.thumbnail,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBar(Event event) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            OutlinedButton(
              onPressed: _bookmarkBusy ? null : _toggleBookmark,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(50, 48),
                padding: EdgeInsets.zero,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Icon(
                event.isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: event.isBookmarked ? AppColors.main : AppColors.g07,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => _openOrganizer(event.uri),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.main,
                  foregroundColor: AppColors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text(
                  '주최 페이지에서 자세히 보기',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hostCard(Event event) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.canvas,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: !AppUtils.isHttpUrl(event.host.thumbnail)
                ? const Icon(Icons.business_outlined, color: AppColors.g06)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: event.host.thumbnail,
                      fit: BoxFit.contain,
                      errorWidget: (_, __, ___) => const Icon(
                        Icons.business_outlined,
                        color: AppColors.g06,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              event.host.name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeading(String title, {String? trailing}) => Row(
    children: [
      Text(
        title,
        style: const TextStyle(
          color: AppColors.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      const Spacer(),
      if (trailing != null)
        Text(
          trailing,
          style: const TextStyle(color: AppColors.g05, fontSize: 11),
        ),
    ],
  );

  Widget _scheduleRow(
    IconData icon,
    String label,
    String value, {
    String? note,
  }) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 21, color: AppColors.g05),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: AppColors.g05, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.6,
              ),
            ),
            if (note != null) ...[
              const SizedBox(height: 4),
              Text(
                note,
                style: const TextStyle(
                  color: AppColors.g05,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    ],
  );

  Widget _tag(String text, Color background, Color foreground) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(100),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: foreground,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  String _category(Event event) => switch (event.eventType) {
    EventType.CONFERENCE => '컨퍼런스/학술대회',
    EventType.CONTEST => '콘테스트',
    _ => event.eventType.displayName,
  };

  String _statusLabel(Event event) {
    switch (_status) {
      case 'FINISHED':
        return '종료';
      case 'ACTIVE':
        return '진행 중';
      case 'EVENT_WAITING':
        return '시작 대기';
      case 'RECRUITING':
        final deadline = event.recruitmentEndAt;
        if (deadline == null) return '모집 중';
        final days = AppUtils.daysUntilKstDate(deadline);
        if (days < 0) return '신청 마감';
        return days == 0 ? '모집 중 · D-Day' : '모집 중 · D-$days';
      case 'RECRUITMENT_WAITING':
        return '모집 대기';
      case 'PENDING':
        return '승인 대기';
    }
    final end = event.endAt ?? event.startAt;
    return end != null && AppUtils.daysUntilKstDate(end) < 0 ? '종료' : '행사 안내';
  }

  String _dateTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '${AppUtils.formatDateTime(value).replaceFirst('(', ' (')} $hour:$minute';
  }

  String _eventPeriod(Event event) {
    final start = event.startAt;
    final end = event.endAt;
    if (start == null && end == null) return '주최 페이지에서 확인해 주세요';
    if (start == null) return '${_dateTime(end!)}까지';
    if (end == null || start.isAtSameMomentAs(end)) return _dateTime(start);
    if (DateUtils.isSameDay(start, end)) {
      return '${_dateTime(start)} – ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    }
    return '${_dateTime(start)} – ${_dateTime(end)}';
  }
}
