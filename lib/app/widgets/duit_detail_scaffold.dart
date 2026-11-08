import 'dart:math' as math;

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/widgets/duit_top_app_bar.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/material.dart';

/// Shared detail chrome, with actions moved to Duo's hardware-side rail.
class DuitDetailScaffold extends StatelessWidget {
  const DuitDetailScaffold({
    super.key,
    required this.title,
    required this.actions,
    required this.onBack,
    required this.body,
    this.bottomNavigationBar,
  });

  final Widget title;
  final Widget actions;
  final VoidCallback onBack;
  final Widget body;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final layout = DuoLayoutData.of(context);
    final edge = layout.verticalBarEdge;
    final media = MediaQuery.of(context);
    const toolbarHeight = 64.0;
    const actionExtent = 48.0;
    final sideInset = (layout.sideBarWidth(media) - actionExtent) / 2;
    final bodyTop = media.padding.top + toolbarHeight;
    return Scaffold(
      backgroundColor: context.colors.canvas,
      appBar: AppBar(
        backgroundColor: context.colors.canvas,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: toolbarHeight,
        leadingWidth: 80,
        centerTitle: true,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: DuitAppBarActions(
            children: [
              IconButton(
                tooltip: '뒤로 가기',
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: context.colors.text,
                  size: 22,
                ),
                style: IconButton.styleFrom(
                  minimumSize: const Size.square(44),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: onBack,
              ),
            ],
          ),
        ),
        title: DefaultTextStyle.merge(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: context.colors.text,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
          child: title,
        ),
        actions: [
          if (edge == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DuitAppBarActions(children: [actions]),
            )
          else
            const SizedBox(width: 80),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          body,
          if (edge != null)
            Positioned(
              left: edge == 'left' ? sideInset : null,
              right: edge == 'right' ? sideInset : null,
              top: math.max(0.0, layout.sideControlsTop(media) - bodyTop) + 8,
              width: actionExtent,
              height: actionExtent,
              child: DuitAppBarActions(vertical: true, children: [actions]),
            ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
