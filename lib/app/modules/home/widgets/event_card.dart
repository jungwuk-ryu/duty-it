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
    // Identify this card instance, even if another list contains the same event.
    final posterHeroTag = ('home', ObjectKey(eventRx));
    return Obx(
      () => EventTile(
        event: event,
        posterHeroTag: posterHeroTag,
        onTap: () => _onTap(context, posterHeroTag),
        onBookmarkTap: () async {
          HapticFeedback.mediumImpact();
          await Get.find<HomeViewController>().onBookmarkButtonClick(eventRx);
        },
      ),
    );
  }

  void _onTap(BuildContext context, Object posterHeroTag) {
    EventDetailView.open(
      context,
      eventRx: eventRx,
      posterHeroTag: posterHeroTag,
      onBookmarkTap: () =>
          Get.find<HomeViewController>().onBookmarkButtonClick(eventRx),
    );
  }
}
