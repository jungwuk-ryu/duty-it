import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        Container(
          height: 164.h,
          decoration: BoxDecoration(
            color: Color(0xffD9D9D9),
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          "행사 제목 자리 입니다. 행사 제목 자리 입니다. 행사 제목 자리입니다.",
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600, height: 1.20),
        ),
        SizedBox(height: 4.h),
        Row(children: [

        ],),
        Row(
          children: [
            Expanded(child: EventMetaItem(name: "카테고리", value: "컨퍼런스 / 학술대회")),
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
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xff949494),
            ),
          ),
          WidgetSpan(child: SizedBox(width: 8.w)),
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Color(0xff333333),
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
      maxLines: 1,
    );
  }
}
