import 'dart:ui' show ImageFilter;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/enums/event_type.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';

/// The same compact event presentation used by the web's mobile list.
class EventTile extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;
  final VoidCallback onBookmarkTap;

  const EventTile({
    super.key,
    required this.event,
    required this.onTap,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    final category = event.eventType == EventType.CONFERENCE
        ? '학술대회'
        : event.eventType.displayName;
    final start = event.startAt;
    final daysUntilStart = start == null
        ? null
        : AppUtils.daysUntilKstDate(start);
    final lastDay = event.endAt ?? start;
    final ended = lastDay != null && AppUtils.daysUntilKstDate(lastDay) < 0;

    return Semantics(
      button: true,
      explicitChildNodes: true,
      label: '$category, ${event.title}, ${event.host.name}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.g02,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: AppUtils.isHttpUrl(event.thumbnail)
                          ? CachedNetworkImage(
                              imageUrl: event.thumbnail,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Center(
                                child: Image.asset(
                                  Assets.icons.nurseCap.path,
                                  width: 42,
                                  height: 42,
                                ),
                              ),
                              errorWidget: (_, __, ___) => Center(
                                child: Image.asset(
                                  Assets.icons.nurseCap.path,
                                  width: 42,
                                  height: 42,
                                ),
                              ),
                            )
                          : Center(
                              child: Image.asset(
                                Assets.icons.nurseCap.path,
                                width: 42,
                                height: 42,
                              ),
                            ),
                    ),
                  ),
                  if (ended)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: ColoredBox(
                        color: const Color(0x88000000),
                        child: Center(
                          child: Text(
                            '종료된 행사',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Positioned(top: 0, right: 0, child: _bookmarkButton(context)),
                ],
              ),
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Flexible(
                  child: Text(
                    category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (daysUntilStart != null &&
                    daysUntilStart >= 0 &&
                    !ended) ...[
                  const SizedBox(width: 7),
                  Container(width: 1, height: 12, color: AppColors.border),
                  const SizedBox(width: 7),
                  Text(
                    daysUntilStart == 0 ? 'D-day' : 'D-$daysUntilStart',
                    style: const TextStyle(
                      color: AppColors.main,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 9),
            Text(
              event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              event.host.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.g05, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bookmarkButton(BuildContext context) {
    final highContrast = MediaQuery.highContrastOf(context);

    return IconButton(
      tooltip: event.isBookmarked ? '북마크 해제' : '북마크 저장',
      onPressed: onBookmarkTap,
      iconSize: 32,
      style: IconButton.styleFrom(
        fixedSize: const Size(48, 48),
        padding: const EdgeInsets.all(8),
        backgroundColor: AppColors.transparent,
        overlayColor: Colors.white.withAlpha(72),
        shape: const CircleBorder(),
        visualDensity: VisualDensity.standard,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(22),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: highContrast ? 0 : 10,
              sigmaY: highContrast ? 0 : 10,
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
                          Colors.white.withAlpha(170),
                          Colors.white.withAlpha(68),
                          Colors.white.withAlpha(115),
                        ],
                ),
                border: Border.all(
                  color: Colors.white.withAlpha(200),
                  width: 0.8,
                ),
              ),
              child: Icon(
                event.isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: event.isBookmarked ? AppColors.main : AppColors.g07,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
