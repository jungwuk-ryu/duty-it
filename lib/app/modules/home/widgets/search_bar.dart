import 'dart:math' as math;

import 'package:duty_it/app/widgets/app_asset_icon.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool filled;

  const HomeSearchBar({
    super.key,
    required this.controller,
    this.hintText = '찾으시는 행사가 있나요?',
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: math.max(
        48,
        MediaQuery.textScalerOf(context).scale(16) * 1.4 + 16,
      ),
      decoration: BoxDecoration(
        color: filled ? context.colors.mutedSurface : context.colors.surface,
        border: filled ? null : Border.all(color: context.colors.border),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 16),
            AppAssetIcon(
              asset: Assets.icons.search.path,
              height: 16,
              width: 16,
              color: context.colors.icon,
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  isCollapsed: true,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: context.colors.muted,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) => value.text.isEmpty
                  ? const SizedBox(width: 12)
                  : IconButton(
                      tooltip: '검색어 지우기',
                      onPressed: controller.clear,
                      constraints: const BoxConstraints.tightFor(
                        width: 48,
                        height: 48,
                      ),
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.cancel_rounded,
                        color: context.colors.disabled,
                        size: 18,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
