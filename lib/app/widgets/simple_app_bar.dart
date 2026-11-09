import 'package:duty_it/app/widgets/app_asset_icon.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/widgets/section_divider.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SimpleAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? endChildren;
  final double bottomMargin;

  const SimpleAppBar({
    super.key,
    required this.title,
    this.endChildren,
    this.bottomMargin = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25),
        Row(
          children: [
            IconButton(
              tooltip: '뒤로 가기',
              onPressed: () => Get.back(),
              constraints: const BoxConstraints.tightFor(width: 48, height: 48),
              padding: EdgeInsets.zero,
              icon: AppAssetIcon(
                asset: Assets.icons.backLeft.path,
                width: 40,
                height: 40,
              ),
            ),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: context.colors.text,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.60,
                ),
              ),
            ),
            ...?endChildren,
          ],
        ),
        SizedBox(height: 8),
        SectionDivider(),
        SizedBox(height: bottomMargin),
      ],
    );
  }
}
