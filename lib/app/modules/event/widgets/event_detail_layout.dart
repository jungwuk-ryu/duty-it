import 'dart:math' as math;

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/widgets.dart';

/// Stack the poster on phones; give it its own pane when the detail route is wide.
class EventDetailLayout extends StatelessWidget {
  const EventDetailLayout({
    super.key,
    required this.poster,
    required this.information,
    required this.safeLeft,
    required this.actions,
    this.contentInsets = EdgeInsets.zero,
  });
  final Widget poster;
  final Widget information;
  final double safeLeft;
  final Widget actions;

  /// Reserve space for side controls without cutting the footer's background.
  final EdgeInsets contentInsets;

  @override
  Widget build(BuildContext context) {
    final layout = DuoLayoutData.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        const inset = 20.0;
        const gutter = 24.0;
        final width =
            constraints.maxWidth - contentInsets.horizontal - 2 * inset;
        final bounds = Rect.fromLTWH(
          safeLeft + inset,
          0,
          width,
          constraints.maxHeight,
        );
        final fold = layout.withContentBounds(bounds).verticalFold;
        final leftPane = fold == null
            ? width * 0.4
            : fold.left - bounds.left - gutter / 2;
        final gap = gutter + (fold?.width ?? 0);
        final rightPane = width - leftPane - gap;
        final textScale = math.max(
          1.0,
          MediaQuery.textScalerOf(context).scale(14) / 14,
        );
        final useColumns =
            (fold != null || width >= 680) &&
            leftPane >= 180 &&
            rightPane >= 280 * textScale;
        Widget content;
        var actionsPadding = EdgeInsets.zero;
        if (useColumns) {
          content = Row(
            textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: leftPane, child: poster),
              SizedBox(width: gap),
              Expanded(child: information),
            ],
          );
          actionsPadding = EdgeInsets.only(left: leftPane + gap);
        } else {
          content = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              poster,
              const SizedBox(height: gutter),
              information,
            ],
          );
          if (fold != null) {
            actionsPadding = leftPane >= rightPane
                ? EdgeInsets.only(right: rightPane + gap)
                : EdgeInsets.only(left: leftPane + gap);
            content = Padding(padding: actionsPadding, child: content);
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: contentInsets,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(inset, inset, inset, 32),
                  child: content,
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.surface,
                border: Border(top: BorderSide(color: context.colors.border)),
              ),
              child: Padding(
                padding: contentInsets
                    .add(actionsPadding)
                    .add(const EdgeInsets.symmetric(horizontal: inset)),
                child: actions,
              ),
            ),
          ],
        );
      },
    );
  }
}
