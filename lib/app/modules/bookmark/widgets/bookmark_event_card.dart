import 'package:cached_network_image/cached_network_image.dart';
import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/bookmark/controllers/bookmark_view_controller.dart';
import 'package:duty_it/app/widgets/tap_scale.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BookmarkEventCard extends GetView<BookmarkViewController> {
  final Rx<Event> eventRx;

  const BookmarkEventCard({super.key, required this.eventRx});

  Event get event => eventRx.value;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _onTap,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EventImageSection(
                eventRx: eventRx,
                onBookmarkTap: () => controller.unbookmarkEvent(eventRx),
              ),
              const SizedBox(height: 16),
              Obx(
                () => Text(
                  event.title,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.20,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: _EventMetaItem(
                        name: '카테고리',
                        value: event.eventType.displayName,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _EventMetaItem(
                          name: '주최',
                          value: event.host.name,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => _EventMetaItem(
                  name: '일시',
                  value: _formatPeriod(event.startAt, event.endAt),
                ),
              ),
              Obx(
                () => Visibility(
                  visible:
                      !(event.recruitmentStartAt == null &&
                          event.recruitmentEndAt == null),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      _EventMetaItem(
                        name: '모집',
                        value: _formatPeriod(
                          event.recruitmentStartAt,
                          event.recruitmentEndAt,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap() {
    launchUrlString(AppUtils.setDuitUtmSourceString(event.uri));
    Get.find<ApiClient>().increaseViewCount(event.id);
    FirebaseAnalytics.instance.logSelectContent(
      contentType: 'event',
      itemId: event.id.toString(),
    );
  }

  String _formatPeriod(DateTime? start, DateTime? end) {
    final startStr = start != null ? AppUtils.formatDateTime(start) : null;
    final endStr = end != null ? AppUtils.formatDateTime(end) : null;

    if (start != null && end != null) {
      return startStr == endStr ? '$startStr' : '$startStr ~ $endStr';
    }
    if (start == null && end == null) return '정보 없음';
    if (start != null) return '$startStr';
    return ' ~ $endStr';
  }
}

class _EventImageSection extends StatelessWidget {
  final Rx<Event> eventRx;
  final Future<void> Function() onBookmarkTap;

  const _EventImageSection({
    required this.eventRx,
    required this.onBookmarkTap,
  });

  Event get event => eventRx.value;

  @override
  Widget build(BuildContext context) {
    final cardBorderRadius = BorderRadius.circular(8);

    return AspectRatio(
      aspectRatio: 400 / 200,
      child: Stack(
        children: [
          Obx(
            () => Container(
              decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                borderRadius: cardBorderRadius,
                border: Border.all(width: 1, color: const Color(0xFFF5F5F5)),
              ),
              child: CachedNetworkImage(
                imageUrl: event.thumbnail,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffD9D9D9),
                    borderRadius: cardBorderRadius,
                    border: Border.all(
                      width: 1,
                      color: const Color(0xFFD0D0D0),
                    ),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                progressIndicatorBuilder: (_, __, ___) =>
                    Center(child: Image.asset(Assets.icons.nurseCap.path)),
                errorWidget: (_, __, ___) =>
                    Center(child: Image.asset(Assets.icons.nurseCap.path)),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                HapticFeedback.mediumImpact();
                await onBookmarkTap();
              },
              child: Image.asset(
                Assets.icons.bookmarkRed.path,
                width: 40,
                height: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventMetaItem extends StatelessWidget {
  final String name;
  final String value;

  const _EventMetaItem({required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(fontSize: 12),
        children: [
          TextSpan(
            text: name,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: AppColors.g05,
            ),
          ),
          const WidgetSpan(child: SizedBox(width: 8)),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              color: AppColors.black,
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
      maxLines: 1,
    );
  }
}
