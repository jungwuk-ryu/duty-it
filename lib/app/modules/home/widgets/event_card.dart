import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/home/widgets/event_bookmark_button.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventCard extends StatelessWidget {
  final String? imageUri;

  const EventCard({super.key, this.imageUri});

  @override
  Widget build(BuildContext context) {
    final cardBorderRadius = BorderRadius.circular(8.r);
    double cardHeight = 164.h;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        Stack(
          children: [
            Container(
              height: cardHeight,
              decoration: BoxDecoration(
                color: Color(0xffD9D9D9),
                borderRadius: cardBorderRadius,
              ),
              child: imageUri != null
                  ? Image.network(imageUri!, fit: BoxFit.fitWidth)
                  : Center(child: Image.asset(Assets.icons.nurseCap.path)),
            ),
            Visibility(
              visible: false, //TODO: 종료 여부에 따른 값 변경
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
              child: EventBookmarkButton(isBookmarked: false),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          "행사 제목 자리 입니다. 행사 제목 자리 입니다. 행사 제목 자리입니다.",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1.20,
          ),
        ),
        SizedBox(height: 4.h),
        Row(children: [

        ],),
        Row(
          children: [
            Expanded(
              child: EventMetaItem(name: "카테고리", value: "컨퍼런스 / 학술대회"),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: EventMetaItem(name: "주최", value: "상세내용 상세내용 상세내용 상세내용"),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        EventMetaItem(name: "일시", value: "2025년 00월 00일(일) ~ 2025년 00월 00일(일)"),
        SizedBox(height: 4.h),
        EventMetaItem(name: "모집", value: "5월 12일(월) 00:00 ~ 5월 26일(월) 18:00"),
        SizedBox(height: 12.h),
      ],
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
