import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/bookmark/controllers/bookmark_view_controller.dart';
import 'package:duty_it/app/widgets/event_tile.dart';
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
    return Obx(
      () => EventTile(
        event: event,
        onTap: _onTap,
        onBookmarkTap: () async {
          HapticFeedback.mediumImpact();
          await controller.unbookmarkEvent(eventRx);
        },
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
}
