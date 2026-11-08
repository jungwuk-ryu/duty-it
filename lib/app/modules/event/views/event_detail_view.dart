import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/enums/event_type.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/models/event_detail.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/core/utils/event_time.dart';
import 'package:duty_it/app/services/event_content_service.dart';
import 'package:duty_it/app/modules/event/widgets/event_actions_menu.dart';
import 'package:duty_it/app/modules/event/widgets/event_host_card.dart';
import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/app/modules/main/controllers/main_view_controller.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/modules/event/widgets/event_detail_layout.dart';
import 'package:duty_it/app/modules/event/widgets/event_image_backdrop.dart';
import 'package:duty_it/app/modules/event/views/event_poster_viewer.dart';
import 'package:duty_it/app/widgets/duit_glass.dart';
import 'package:duty_it/app/widgets/duit_detail_scaffold.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:duty_it/app/widgets/event_poster_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailView extends StatelessWidget {
  final Rx<Event> eventRx;
  final EventDetail? initialDetail;
  final Future<void> Function() onBookmarkTap;
  final Object? posterHeroTag;

  const EventDetailView({
    super.key,
    required this.eventRx,
    this.initialDetail,
    required this.onBookmarkTap,
    this.posterHeroTag,
  });

  static Future<void>? open(
    BuildContext context, {
    required Rx<Event> eventRx,
    required Future<void> Function() onBookmarkTap,
    required Object posterHeroTag,
  }) {
    final duration = DuoMotion.durationOf(context);
    return Get.to<void>(
      () => EventDetailView(
        eventRx: eventRx,
        onBookmarkTap: onBookmarkTap,
        posterHeroTag: posterHeroTag,
      ),
      routeName: '/events/${eventRx.value.id}',
      transition: duration == Duration.zero
          ? Transition.noTransition
          : Transition.fadeIn,
      duration: duration,
      curve: Curves.easeOutCubic,
      popGesture: Theme.of(context).platform == TargetPlatform.iOS,
    );
  }

  @override
  Widget build(BuildContext context) => Obx(() {
    final thumbnail = eventRx.value.thumbnail.trim();
    return EventImageBackdrop(
      image: AppUtils.isHttpUrl(thumbnail)
          ? CachedNetworkImageProvider(thumbnail)
          : null,
      child: _EventDetailContent(
        eventRx: eventRx,
        initialDetail: initialDetail,
        onBookmarkTap: onBookmarkTap,
        posterHeroTag: posterHeroTag,
      ),
    );
  });
}

class _EventDetailContent extends StatefulWidget {
  const _EventDetailContent({
    required this.eventRx,
    required this.initialDetail,
    required this.onBookmarkTap,
    required this.posterHeroTag,
  });

  final Rx<Event> eventRx;
  final EventDetail? initialDetail;
  final Future<void> Function() onBookmarkTap;
  final Object? posterHeroTag;

  @override
  State<_EventDetailContent> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<_EventDetailContent> {
  final EventContentService _contentService = EventContentService();
  // Preserve in-flight actions when folding moves the menu between toolbars.
  final _actionsKey = GlobalKey();
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
    final initialDetail = widget.initialDetail;
    if (initialDetail != null) {
      _status = initialDetail.status;
      _viewCount = initialDetail.viewCount;
      _loading = false;
    } else {
      unawaited(_loadDetail());
    }
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
    final layout = DuoLayoutData.of(context);
    final edge = layout.verticalBarEdge;
    final media = MediaQuery.of(context);
    final sideWidth = layout.sideBarWidth(media);
    final contentInsets = EdgeInsets.only(
      left: edge == 'left' ? sideWidth : media.padding.left,
      right: edge == 'right' ? sideWidth : media.padding.right,
    );
    final menu = Obx(
      () => EventActionsMenu(
        key: _actionsKey,
        event: widget.eventRx.value,
        bookmarkBusy: _bookmarkBusy,
        onBookmarkTap: _toggleBookmark,
      ),
    );
    return DuitDetailScaffold(
      title: const SizedBox.shrink(),
      actions: menu,
      onBack: Get.back,
      body: MediaQuery.removePadding(
        context: context,
        removeLeft: true,
        removeRight: true,
        child: Obx(() {
          final event = widget.eventRx.value;
          return Column(
            children: [
              if (_loading)
                LinearProgressIndicator(
                  minHeight: 2,
                  color: context.colors.accent,
                ),
              if (_loadFailed)
                Padding(
                  padding: contentInsets,
                  child: MaterialBanner(
                    content: const Text('최신 행사 정보를 불러오지 못했어요.'),
                    backgroundColor: context.colors.subtleSurface,
                    actions: [
                      TextButton(
                        onPressed: _loadDetail,
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: EventDetailLayout(
                  contentInsets: contentInsets,
                  safeLeft: edge == 'left' ? sideWidth : media.padding.left,
                  poster: _poster(event),
                  actions: _bottomBar(event),
                  information: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _tag(
                            _category(event),
                            context.colors.mutedSurface,
                            context.colors.text,
                          ),
                          _tag(
                            _statusLabel(event),
                            context.colors.accentSurface,
                            context.colors.accent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        event.title,
                        style: TextStyle(
                          color: context.colors.text,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        event.host.name,
                        style: TextStyle(
                          color: context.colors.muted,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Divider(height: 1, color: context.colors.border),
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
                            : '${_dateTime(event.recruitmentEndAt!.seoulWallTime)}까지',
                        note: event.recruitmentStartAt == null
                            ? null
                            : '신청 시작 · ${_dateTime(event.recruitmentStartAt!.seoulWallTime)}',
                      ),
                      if (_contentResult?.availability !=
                          EventContentAvailability.unavailable) ...[
                        const SizedBox(height: 28),
                        Divider(height: 1, color: context.colors.border),
                        const SizedBox(height: 23),
                        _sectionHeading('행사 내용'),
                        const SizedBox(height: 12),
                        _contentCard(event.id),
                      ],
                      const SizedBox(height: 28),
                      Divider(height: 1, color: context.colors.border),
                      const SizedBox(height: 23),
                      _sectionHeading('주최 안내'),
                      const SizedBox(height: 14),
                      _hostCard(event),
                      if (_viewCount != null) ...[
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Icon(
                              Icons.visibility_outlined,
                              size: 16,
                              color: context.colors.muted,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              '조회 $_viewCount',
                              style: TextStyle(
                                color: context.colors.muted,
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
                          color: context.colors.subtleSurface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '자세한 내용과 신청은 주최 페이지에서 확인해 주세요.',
                          style: TextStyle(
                            color: context.colors.muted,
                            fontSize: 12,
                            height: 1.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _poster(Event event) {
    final hasImage = AppUtils.isHttpUrl(event.thumbnail);
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Builder(
        builder: (source) => Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              excludeFromSemantics: true,
              onTap: hasImage ? () => _showPoster(source, event) : null,
              child: EventPosterImage(
                imageUrl: event.thumbnail,
                heroTag: widget.posterHeroTag,
              ),
            ),
            if (hasImage)
              PositionedDirectional(
                end: 12,
                bottom: 12,
                child: DuitGlass(
                  radius: 24,
                  child: IconButton(
                    tooltip: '포스터 전체 보기',
                    onPressed: () => _showPoster(source, event),
                    icon: Icon(
                      Icons.open_in_full_rounded,
                      size: 20,
                      color: context.colors.text,
                    ),
                  ),
                ),
              ),
          ],
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
        color: context.colors.accentSurface,
        border: Border.all(color: context.colors.accent.withAlpha(45)),
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
                Flexible(child: Text('행사 내용을 불러오는 중이에요.')),
              ],
            )
          : result.availability == EventContentAvailability.available
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 16,
                      color: context.colors.accent,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'AI로 정리했어요',
                      style: TextStyle(
                        color: context.colors.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SelectableText(
                  result.body!,
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 14,
                    height: 1.75,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'AI가 행사 자료를 바탕으로 정리한 내용으로, 일부 정보가 정확하지 않을 수 있어요. 신청 전 주최 페이지에서 확인해 주세요.',
                  style: TextStyle(
                    color: context.colors.muted,
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
                        'https://www.dutyit.net/events/$eventId?openIn=web',
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

  void _showPoster(BuildContext source, Event event) => EventPosterViewer.show(
    source,
    image: CachedNetworkImageProvider(event.thumbnail),
    title: event.title,
    host: event.host.name,
  );

  Widget _bottomBar(Event event) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            OutlinedButton(
              onPressed: _bookmarkBusy ? null : _toggleBookmark,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(50, 48),
                padding: EdgeInsets.zero,
                side: BorderSide(color: context.colors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Icon(
                event.isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: event.isBookmarked
                    ? context.colors.accent
                    : context.colors.secondaryText,
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
    return EventHostCard(
      host: event.host,
      onTap: event.host.id > 0
          ? () {
              Get.find<HomeViewController>().showHostEvents(event.host);
              Get.find<MainViewController>().changeTab(0);
              Get.until(
                (route) => route.settings.name == Routes.MAIN || route.isFirst,
              );
            }
          : null,
    );
  }

  Widget _sectionHeading(String title, {String? trailing}) => OverflowBar(
    alignment: MainAxisAlignment.spaceBetween,
    overflowAlignment: OverflowBarAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          color: context.colors.text,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      if (trailing != null)
        Text(
          trailing,
          style: TextStyle(color: context.colors.muted, fontSize: 11),
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
      Icon(icon, size: 21, color: context.colors.muted),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: context.colors.muted, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: context.colors.text,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.6,
              ),
            ),
            if (note != null) ...[
              const SizedBox(height: 4),
              Text(
                note,
                style: TextStyle(
                  color: context.colors.muted,
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
    final start = event.startAt?.seoulWallTime;
    final end = event.endAt?.seoulWallTime;
    if (start == null && end == null) return '주최 페이지에서 확인해 주세요';
    if (start == null) return '${_dateTime(end!)}까지';
    if (end == null || start.isAtSameMomentAs(end)) return _dateTime(start);
    if (DateUtils.isSameDay(start, end)) {
      return '${_dateTime(start)} – ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    }
    return '${_dateTime(start)} – ${_dateTime(end)}';
  }
}
