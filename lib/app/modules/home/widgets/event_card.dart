import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/widgets/event_tile.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EventCard extends StatelessWidget {
  final Rx<Event> eventRx;
  Event get event => eventRx.value;

  const EventCard({super.key, required this.eventRx});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => EventTile(
        event: event,
        onTap: _onTap,
        onBookmarkTap: () async {
          HapticFeedback.mediumImpact();
          await Get.find<HomeViewController>().onBookmarkButtonClick(eventRx);
        },
      ),
    );
  }

  void _onTap() {
    if (!Get.find<AuthService>().isLoggined()) {
      Get.toNamed(Routes.LOGIN);
      return;
    }

    launchUrlString(AppUtils.setDuitUtmSourceString(event.uri));
    Get.find<ApiClient>().increaseViewCount(event.id);
    FirebaseAnalytics.instance.logSelectContent(
      contentType: 'event',
      itemId: event.id.toString(),
    );
  }
}
