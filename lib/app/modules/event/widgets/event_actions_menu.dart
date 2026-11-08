import 'package:device_calendar_plus/device_calendar_plus.dart' as device;
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/utils/event_actions.dart';
import 'package:duty_it/app/core/utils/event_time.dart';
import 'package:duty_it/app/services/calendar_service.dart';
import 'package:duty_it/app/widgets/duit_glass_menu.dart';
import 'package:duty_it/app/widgets/duit_detail_actions_menu.dart';
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
  bool _calendarBusy = false;
  bool _shareBusy = false;

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
    return DuitDetailActionsMenu(
      tooltip: '행사 더보기',
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

  BuildContext get _overlayContext =>
      Navigator.of(context, rootNavigator: true).context;

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
          context: _overlayContext,
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
          context: _overlayContext,
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
          context: _overlayContext,
          useSafeArea: true,
          isScrollControlled: true,
          useRootNavigator: true,
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
