import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/modules/event/views/event_detail_view.dart';
import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/app/widgets/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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
    Get.to(
      () => EventDetailView(
        eventRx: eventRx,
        onBookmarkTap: () =>
            Get.find<HomeViewController>().onBookmarkButtonClick(eventRx),
      ),
    );
  }
}
