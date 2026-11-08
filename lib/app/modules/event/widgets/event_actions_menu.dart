import 'dart:math' as math;

import 'package:device_calendar_plus/device_calendar_plus.dart' as device;
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/utils/event_actions.dart';
import 'package:duty_it/app/core/utils/event_time.dart';
import 'package:duty_it/app/services/calendar_service.dart';
import 'package:duty_it/app/widgets/duit_glass_menu.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

enum _EventAction { copy, share, bookmark, calendar }

class EventActionsMenu extends StatefulWidget {
  final Event event;
  final bool bookmarkBusy;
  final Future<void> Function() onBookmarkTap;

  const EventActionsMenu({
    super.key,
    required this.event,
    required this.bookmarkBusy,
    required this.onBookmarkTap,
  });

  @override
  State<EventActionsMenu> createState() => _EventActionsMenuState();
}

class _EventActionsMenuState extends State<EventActionsMenu> {
  final _triggerFocus = FocusNode();
  bool _calendarBusy = false;
  bool _shareBusy = false;

  @override
  void dispose() {
    _triggerFocus.dispose();
    super.dispose();
  }

  void _message(String text, {SnackBarAction? action}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(text),
        action: action,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: action == null ? 3 : 6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    // AppBar consumes its horizontal insets before building action buttons.
    // The overlay still needs the navigator's original safe area.
    final insets = MediaQuery.viewPaddingOf(
      Navigator.maybeOf(context)?.context ?? context,
    );
    final layout = DuoLayoutData.of(context);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final bounds = layout.contentBounds;
    final fromLeft =
        layout.verticalBarEdge == 'left' ||
        (layout.verticalBarEdge == null && rtl);
    var left = math.max(insets.left, bounds.isEmpty ? 0.0 : bounds.left);
    var right = math.min(
      media.size.width - insets.right,
      bounds.isEmpty ? media.size.width : bounds.right,
    );
    if (layout.verticalBarEdge == 'left') {
      left = math.max(left, layout.sideBarWidth(media));
    } else if (layout.verticalBarEdge == 'right') {
      right = math.min(right, media.size.width - layout.sideBarWidth(media));
    }
    // The dropdown stays beside its toolbar, clear of the physical fold.
    for (final fold in layout.divisions) {
      if (fold.height <= fold.width) continue;
      if (fromLeft && fold.left > left && fold.left < right) {
        right = fold.left;
      }
      if (!fromLeft && fold.right > left && fold.right < right) {
        left = fold.right;
      }
    }
    final width = math.min(
      math.max(0.0, right - left - 32),
      60 + media.textScaler.scale(150),
    );
    return DuitGlassMenu(
      width: width,
      childFocusNode: _triggerFocus,
      builder: (context, menu, _) => Semantics(
        expanded: menu.isOpen,
        child: IconButton(
          focusNode: _triggerFocus,
          tooltip: '행사 더보기',
          icon: Icon(Icons.more_horiz_rounded, color: context.colors.text),
          style: IconButton.styleFrom(
            minimumSize: layout.verticalBarEdge == null
                ? null
                : const Size.square(44),
            backgroundColor: menu.isOpen
                ? context.colors.mutedSurface
                : Colors.transparent,
          ),
          onPressed: () {
            if (menu.isOpen) {
              menu.close();
              return;
            }
            final box = context.findRenderObject()! as RenderBox;
            final x = box.localToGlobal(Offset.zero).dx;
            final trailing = fromLeft ? x : x + box.size.width - width;
            final menuLeft = trailing.clamp(
              left + 16,
              math.max(left + 16, right - 16 - width),
            );
            menu.open(position: Offset(menuLeft - x, box.size.height + 4));
          },
        ),
      ),
      items: [
        _item(_EventAction.copy, Icons.link_rounded, '링크 복사'),
        _item(
          _EventAction.share,
          Icons.ios_share_rounded,
          '공유',
          enabled: !_shareBusy,
        ),
        _item(
          _EventAction.bookmark,
          widget.event.isBookmarked
              ? Icons.bookmark_rounded
              : Icons.bookmark_border_rounded,
          widget.event.isBookmarked ? '북마크 해제' : '북마크',
          enabled: !widget.bookmarkBusy,
        ),
        _item(
          _EventAction.calendar,
          Icons.event_available_outlined,
          _calendarBusy ? '캘린더 확인 중…' : '캘린더에 추가',
          enabled: !_calendarBusy,
        ),
      ],
    );
  }

  Future<void> _select(_EventAction action) async {
    if (!mounted) return;
    switch (action) {
      case _EventAction.copy:
        await _copyLink();
      case _EventAction.share:
        await _share();
      case _EventAction.bookmark:
        await widget.onBookmarkTap();
      case _EventAction.calendar:
        await _addToCalendar();
    }
  }

  Widget _item(
    _EventAction action,
    IconData icon,
    String label, {
    bool enabled = true,
  }) => DuitGlassMenuItem(
    label: label,
    leadingIcon: Icon(icon, size: 20),
    onPressed: enabled ? () => _select(action) : null,
  );

  Future<void> _copyLink() async {
    try {
      await Clipboard.setData(
        ClipboardData(text: eventShareUrl(widget.event.id)),
      );
      if (mounted) _message('행사 링크를 복사했어요.');
    } catch (_) {
      if (mounted) _message('링크를 복사하지 못했어요. 다시 시도해 주세요.');
    }
  }

  Future<void> _share() async {
    if (_shareBusy) return;
    setState(() => _shareBusy = true);
    try {
      final box = context.findRenderObject() as RenderBox?;
      await Share.share(
        '${widget.event.title}\n${eventShareUrl(widget.event.id)}',
        subject: widget.event.title,
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      );
    } catch (_) {
      if (mounted) _message('공유 화면을 열지 못했어요. 링크 복사를 이용해 주세요.');
    } finally {
      if (mounted) setState(() => _shareBusy = false);
    }
  }

  Future<void> _addToCalendar() async {
    if (_calendarBusy) return;
    final event = widget.event;
    final draft = EventCalendarDraft.fromEvent(event);
    if (draft == null) {
      _message('행사 일시가 없어 캘린더에 추가할 수 없어요.');
      return;
    }
    setState(() => _calendarBusy = true);
    try {
      final service = Get.find<CalendarService>();
      if (!await service.requestPermission()) {
        if (!mounted) return;
        final openSettings = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('캘린더 접근을 허용해 주세요'),
            content: const Text('기기 캘린더에 행사를 저장하려면 캘린더 권한이 필요해요.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('닫기'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('설정 열기'),
              ),
            ],
          ),
        );
        if (openSettings == true) await openAppSettings();
        return;
      }

      final existingId = await service.findRegisteredEventId(
        event.id.toString(),
      );
      if (!mounted) return;
      if (existingId != null) {
        _showSaved(existingId, created: false);
        return;
      }
      final calendars = await service.getWritableCalendars();
      if (!mounted) return;
      String? calendarId;
      if (calendars.isEmpty) {
        final create = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('저장할 캘린더가 없어요'),
            content: const Text('이 기기에 ‘듀잇’ 캘린더를 만들고 행사를 추가할까요?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('만들고 추가'),
              ),
            ],
          ),
        );
        if (create != true || !mounted) return;
        calendarId = await service.createLocalCalendar();
      } else {
        calendarId = await showModalBottomSheet<String>(
          context: context,
          useSafeArea: true,
          isScrollControlled: true,
          backgroundColor: context.colors.surface,
          showDragHandle: true,
          builder: (_) => _CalendarPicker(calendars: calendars, draft: draft),
        );
      }
      if (calendarId == null || !mounted) return;
      final saved = await service.addEvent(
        calendarId: calendarId,
        title: draft.title,
        startDate: draft.start,
        endDate: draft.end,
        id: event.id.toString(),
        description: draft.description,
      );
      if (mounted) _showSaved(saved.eventId, created: saved.created);
    } catch (_) {
      if (mounted) _message('캘린더에 저장하지 못했어요. 권한과 캘린더를 확인해 주세요.');
    } finally {
      if (mounted) setState(() => _calendarBusy = false);
    }
  }

  void _showSaved(String eventId, {required bool created}) {
    _message(
      created ? '기기 캘린더에 추가했어요.' : '이미 캘린더에 추가된 행사예요.',
      action: SnackBarAction(
        label: '보기',
        textColor: AppColors.white,
        onPressed: () async {
          try {
            await Get.find<CalendarService>().showEventModal(eventId);
          } catch (_) {
            if (mounted) _message('저장된 일정은 기기 캘린더 앱에서 확인해 주세요.');
          }
        },
      ),
    );
  }
}

class _CalendarPicker extends StatefulWidget {
  final List<device.Calendar> calendars;
  final EventCalendarDraft draft;

  const _CalendarPicker({required this.calendars, required this.draft});

  @override
  State<_CalendarPicker> createState() => _CalendarPickerState();
}

class _CalendarPickerState extends State<_CalendarPicker> {
  late String _selected = widget.calendars.first.id;

  String? _accountLabel(device.Calendar calendar) {
    final name = calendar.accountName?.trim();
    if (name == null || name.isEmpty) return null;
    if (name.toLowerCase() == 'local' ||
        calendar.accountType?.toLowerCase() == 'local') {
      return '이 기기에 저장';
    }
    return name;
  }

  String _date(DateTime utc) {
    final kst = utc.seoulWallTime;
    return '${kst.year}.${kst.month}.${kst.day} ${kst.hour.toString().padLeft(2, '0')}:${kst.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * .72,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '캘린더에 추가',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              widget.draft.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              '${_date(widget.draft.start)} – ${_date(widget.draft.end)} (KST)',
              style: TextStyle(fontSize: 12, color: context.colors.muted),
            ),
            const SizedBox(height: 20),
            const Text(
              '저장할 캘린더',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: widget.calendars
                    .map(
                      (calendar) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        selected: _selected == calendar.id,
                        selectedColor: context.colors.accent,
                        leading: const Icon(Icons.calendar_month_outlined),
                        title: Text(calendar.name),
                        subtitle: _accountLabel(calendar) == null
                            ? null
                            : Text(_accountLabel(calendar)!),
                        trailing: Icon(
                          _selected == calendar.id
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                        ),
                        onTap: () => setState(() => _selected = calendar.id),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: AppColors.main,
                foregroundColor: AppColors.white,
              ),
              onPressed: () => Navigator.pop(context, _selected),
              child: const Text('선택한 캘린더에 추가'),
            ),
          ],
        ),
      ),
    ),
  );
}
