import 'package:duty_it/app/widgets/app_asset_icon.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class HomeSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const HomeSearchBar({
    super.key,
    required this.controller,
    this.hintText = '찾으시는 행사가 있나요?',
  });

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.border),
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
                controller: widget.controller,
                onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  isCollapsed: true,
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: context.colors.muted,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(width: 12),
            if (widget.controller.text.isNotEmpty)
              Padding(
                padding: EdgeInsetsGeometry.only(right: 12),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      widget.controller.clear();
                    });
                  },
                  child: Icon(
                    Icons.cancel_rounded,
                    color: context.colors.disabled,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
