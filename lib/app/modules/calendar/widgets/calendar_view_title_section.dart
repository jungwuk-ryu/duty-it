import 'package:duty_it/app/widgets/app_asset_icon.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class CalendarViewTitleSection extends StatelessWidget {
  final DateTime dt;

  const CalendarViewTitleSection({super.key, required this.dt});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "${dt.month}월",
          style: TextStyle(
            color: context.colors.text,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            height: 1.60,
          ),
        ),
        SizedBox(width: 7),
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${dt.year}',
                  style: TextStyle(
                    color: context.colors.muted,
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    height: 1.60,
                  ),
                ),
                SizedBox(width: 4),
                AppAssetIcon(
                  asset: Assets.icons.go.path,
                  width: 16,
                  height: 16,
                ),
              ],
            ),
            SizedBox(height: 7),
          ],
        ),
      ],
    );
  }
}
