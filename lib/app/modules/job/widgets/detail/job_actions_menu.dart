import 'package:duty_it/app/core/extensions/job_posting_x.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/widgets/duit_detail_actions_menu.dart';
import 'package:duty_it/app/widgets/duit_glass_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class JobActionsMenu extends StatefulWidget {
  const JobActionsMenu({
    super.key,
    required this.job,
    required this.onBookmarkTap,
  });

  final JobPosting job;
  final Future<void> Function() onBookmarkTap;

  @override
  State<JobActionsMenu> createState() => _JobActionsMenuState();
}

class _JobActionsMenuState extends State<JobActionsMenu> {
  bool _shareBusy = false;
  bool _bookmarkBusy = false;

  @override
  Widget build(BuildContext context) {
    final hasLink = widget.job.externalPostingUri != null;
    return DuitDetailActionsMenu(
      tooltip: '채용 더보기',
      items: [
        DuitGlassMenuItem(
          label: '링크 복사',
          leadingIcon: const Icon(Icons.link_rounded, size: 20),
          onPressed: hasLink ? _copyLink : null,
        ),
        DuitGlassMenuItem(
          label: '공유',
          leadingIcon: const Icon(Icons.ios_share_rounded, size: 20),
          onPressed: hasLink && !_shareBusy ? _share : null,
        ),
        DuitGlassMenuItem(
          label: widget.job.isBookmarked ? '북마크 해제' : '북마크',
          leadingIcon: Icon(
            widget.job.isBookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            size: 20,
          ),
          onPressed: _bookmarkBusy ? null : _bookmark,
        ),
      ],
    );
  }

  void _message(String text) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _copyLink() async {
    if (!mounted) return;
    final uri = widget.job.externalPostingUri;
    if (uri == null) return;
    try {
      await Clipboard.setData(ClipboardData(text: uri.toString()));
      _message('채용 링크를 복사했어요.');
    } catch (_) {
      _message('링크를 복사하지 못했어요. 다시 시도해 주세요.');
    }
  }

  Future<void> _share() async {
    if (!mounted) return;
    final uri = widget.job.externalPostingUri;
    if (_shareBusy || uri == null) return;
    setState(() => _shareBusy = true);
    try {
      final box = context.findRenderObject() as RenderBox?;
      await Share.share(
        '${widget.job.title}\n$uri',
        subject: widget.job.title,
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      );
    } catch (_) {
      _message('공유 화면을 열지 못했어요. 링크 복사를 이용해 주세요.');
    } finally {
      if (mounted) setState(() => _shareBusy = false);
    }
  }

  Future<void> _bookmark() async {
    if (!mounted || _bookmarkBusy) return;
    setState(() => _bookmarkBusy = true);
    try {
      await widget.onBookmarkTap();
    } catch (_) {
      _message('북마크를 수정하지 못했어요. 다시 시도해 주세요.');
    } finally {
      if (mounted) setState(() => _bookmarkBusy = false);
    }
  }
}
