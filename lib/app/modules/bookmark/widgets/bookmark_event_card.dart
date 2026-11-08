import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/modules/bookmark/controllers/bookmark_view_controller.dart';
import 'package:duty_it/app/modules/event/views/event_detail_view.dart';
import 'package:duty_it/app/widgets/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BookmarkEventCard extends GetView<BookmarkViewController> {
  final Rx<Event> eventRx;

  const BookmarkEventCard({super.key, required this.eventRx});

  Event get event => eventRx.value;

  @override
  Widget build(BuildContext context) {
    final posterHeroTag = ('bookmark', ObjectKey(eventRx));
    return Obx(
      () => EventTile(
        event: event,
        posterHeroTag: posterHeroTag,
        onTap: () => _onTap(context, posterHeroTag),
        onBookmarkTap: () async {
          HapticFeedback.mediumImpact();
          await controller.unbookmarkEvent(eventRx);
        },
      ),
    );
  }

  void _onTap(BuildContext context, Object posterHeroTag) {
    EventDetailView.open(
      context,
      eventRx: eventRx,
      posterHeroTag: posterHeroTag,
      onBookmarkTap: () => controller.unbookmarkEvent(eventRx),
    );
  }
}
