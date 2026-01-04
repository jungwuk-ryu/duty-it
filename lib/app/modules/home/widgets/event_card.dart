import 'package:cached_network_image/cached_network_image.dart';
import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/modules/home/widgets/event_bookmark_button.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/widgets/adaptive_layout.dart';
import 'package:duty_it/app/widgets/tap_scale.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EventCard extends StatelessWidget {
  final Rx<Event> eventRx;
  Event get event => eventRx.value;

  const EventCard({super.key, required this.eventRx});

  @override
  Widget build(BuildContext context) {
    return TapScale(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _onTap,
        child: AdaptiveLayout(
          phone: _EventCardForPhone(eventRx: eventRx),
          tablet: _EventCardForTablet(eventRx: eventRx),
        ),
      ),
    );
  }

  void _onTap() {
    if (!Get.find<AuthService>().isLoggined()) {
      Get.toNamed(Routes.LOGIN);
      return;
    }
    
    launchUrlString(AppUtils.setDuitUtmSourceString(event.uri));

    var apiClient = Get.find<ApiClient>();
    apiClient.increaseViewCount(event.id);

    FirebaseAnalytics.instance.logSelectContent(contentType: 'event', itemId: event.id.toString());
  }
}

class _EventCardForTablet extends StatelessWidget {
  final Rx<Event> eventRx;

  const _EventCardForTablet({required this.eventRx});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Expanded(child: _EventCardImageSection(eventRx: eventRx)),
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 8),
                  _EventCardMetaSection(event: eventRx.value),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }
}

class _EventCardForPhone extends StatelessWidget {
  final Rx<Event> eventRx;

  const _EventCardForPhone({required this.eventRx});
  Event get event => eventRx.value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _EventCardImageSection(eventRx: eventRx),
        SizedBox(height: 16),
        _EventCardMetaSection(event: event),
        SizedBox(height: 24),
      ],
    );
  }
}

class _EventCardImageSection extends StatelessWidget {
  final Rx<Event> eventRx;
  Event get event => eventRx.value;

  const _EventCardImageSection({required this.eventRx});

  @override
  Widget build(BuildContext context) {
    final cardBorderRadius = BorderRadius.circular(8);
    final bool eventEnded;
    if (event.endAt != null) {
      eventEnded = DateUtils.dateOnly(event.endAt!).isBefore(DateUtils.dateOnly(DateTime.now()));
    } else {
      eventEnded = DateUtils.dateOnly(event.startAt!).isBefore(DateUtils.dateOnly(DateTime.now()));
    }

    return AspectRatio(
      aspectRatio: 400 / 200,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xffD9D9D9),
              borderRadius: cardBorderRadius,
              border: BoxBorder.all(width: 1, color: const Color(0xFFF5F5F5)),
            ),
            child: CachedNetworkImage(
              imageUrl: event.thumbnail,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  color: const Color(0xffD9D9D9),
                  borderRadius: cardBorderRadius,
                  border: BoxBorder.all(
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
          Visibility(
            visible: eventEnded,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: cardBorderRadius,
              ),
              child: Center(
                child: Text(
                  '종료된 행사',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.60,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: EventBookmarkButton(eventRx: eventRx),
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
        style: TextStyle(fontSize: 12),
        children: [
          TextSpan(
            text: name,
            style: TextStyle(fontWeight: FontWeight.w400, color: AppColors.g05),
          ),
          WidgetSpan(child: SizedBox(width: 8)),
          TextSpan(
            text: value,
            style: TextStyle(
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

class _EventCardMetaSection extends StatelessWidget {
  final Event event;

  const _EventCardMetaSection({required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1.20,
          ),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: _EventMetaItem(
                name: "카테고리",
                value: event.eventType.displayName,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: _EventMetaItem(name: "주최", value: event.host.name),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        _EventMetaItem(
          name: "일시",
          value: _formatPeriod(event.startAt, event.endAt),
        ),
        Visibility(
          visible:
              !(event.recruitmentStartAt == null &&
                  event.recruitmentEndAt == null),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              _EventMetaItem(
                name: "모집",
                value: _formatPeriod(
                  event.recruitmentStartAt,
                  event.recruitmentEndAt,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatPeriod(DateTime? start, DateTime? end) {
    String? startStr = start != null ? AppUtils.formatDateTime(start) : null;
    String? endStr = end != null ? AppUtils.formatDateTime(end) : null;

    String ret;

    if (start != null && end != null) {
      if (startStr == endStr) {
        ret = "$startStr";
      } else {
        ret = "$startStr ~ $endStr";
      }
    } else if (start == null && end == null) {
      ret = "정보 없음";
    } else if (start != null) {
      ret = "$startStr";
    } else {
      // Only end date
      ret = " ~ $endStr";
    }

    return ret;
  }
}
