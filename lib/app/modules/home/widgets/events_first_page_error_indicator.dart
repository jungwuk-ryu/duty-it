import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/app/widgets/app_normal_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EventsFirstPageErrorIndicator extends StatelessWidget {
  const EventsFirstPageErrorIndicator({
    super.key,
    required this.controller,
  });

  final HomeViewController controller;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 300),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('행사 목록을 불러오지 못했어요', textAlign: TextAlign.center),
          SizedBox(height: 20),
          AppNormalButton(
            text: '다시 시도',
            onTap: () async {
              await controller.fetchNextPage(clearPage: true);
            },
          ),
          SizedBox(height: 10),
          AppNormalButton(
            text: '서비스 상태 확인',
            color: AppColors.g05,
            onTap: () {
              launchUrlString("https://status.dutyit.net");
            },
          ),
        ],
      ),
    );
  }
}