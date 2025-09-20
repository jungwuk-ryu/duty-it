import 'package:cached_network_image/cached_network_image.dart';
import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/models/event.dart';
import 'package:duty_it/app/modules/home/widgets/event_bookmark_button.dart';
import 'package:duty_it/app/widgets/tap_scale.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EventCard extends StatelessWidget {
  final Rx<Event> eventRx;

  Event get event => eventRx.value;

  const EventCard({super.key, required this.eventRx});

  @override
  Widget build(BuildContext context) {
    final cardBorderRadius = BorderRadius.circular(8.r);
    double cardHeight = 164.h;

    return TapScale(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          launchUrlString(event.uri);

          var apiClient = Get.find<ApiClient>();
          apiClient.increaseViewCount(event.id);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: cardHeight,
                  decoration: BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: cardBorderRadius,
                    border: BoxBorder.all(
                      width: 1,
                      color: const Color(0xFFF5F5F5),
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: event.thumbnail,
                    imageBuilder: (context, imageProvider) => Container(
                      width: double.infinity,
                      height: cardHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xffD9D9D9),
                        borderRadius: cardBorderRadius,
                        border: BoxBorder.all(
                          width: 1,
                          color: const Color(0xFFD0D0D0),
                        ),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
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
                  visible: DateUtils.dateOnly(
                    event.endAt ?? DateTime.now(),
                  ).isBefore(DateUtils.dateOnly(DateTime.now())),
                  child: Container(
                    width: double.infinity,
                    height: cardHeight,
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
            SizedBox(height: 16.h),
            Text(
              event.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1.20,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: EventMetaItem(
                    name: "카테고리",
                    value: event.eventType.displayName,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: EventMetaItem(name: "주최", value: event.host.name),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            EventMetaItem(
              name: "일시",
              value:
                  "${AppUtils.formatDateTime(event.startAt ?? DateTime.now())} ~ ${AppUtils.formatDateTime(event.endAt ?? DateTime.now())}",
            ),
            SizedBox(height: 4.h),
            EventMetaItem(
              name: "모집",
              value:
                  "${AppUtils.formatDateTime(event.recruitmentStartAt ?? DateTime.now())} ~ ${AppUtils.formatDateTime(event.recruitmentEndAt ?? DateTime.now())}",
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}

class EventMetaItem extends StatelessWidget {
  final String name;
  final String value;

  const EventMetaItem({super.key, required this.name, required this.value});

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
          WidgetSpan(child: SizedBox(width: 8.w)),
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
