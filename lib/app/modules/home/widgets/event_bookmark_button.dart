import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

class EventBookmarkButton extends StatelessWidget {
  final Rx<Event> eventRx;

  Event get event => eventRx.value;
  bool get isBookmarked => event.isBookmarked;
  HomeViewController get _controller => Get.find<HomeViewController>();

  const EventBookmarkButton({super.key, required this.eventRx});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        HapticFeedback.mediumImpact();
        await _controller.onBookmarkButtonClick(eventRx);
      },
      child: Obx(
        () => Image.asset(
          isBookmarked
              ? Assets.icons.bookmarkRed.path
              : Assets.icons.bookmark.path,
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
