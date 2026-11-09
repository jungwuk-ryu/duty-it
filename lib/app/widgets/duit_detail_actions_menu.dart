import 'dart:math' as math;

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/widgets/duit_glass_menu.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:duty_it/app/widgets/duit_top_app_bar.dart';
import 'package:flutter/material.dart';

/// Detail dropdown anchored below a toolbar or inward beside Duo's rail.
class DuitDetailActionsMenu extends StatefulWidget {
  const DuitDetailActionsMenu({
    super.key,
    required this.tooltip,
    required this.items,
  });

  final String tooltip;
  final List<Widget> items;

  @override
  State<DuitDetailActionsMenu> createState() => _DuitDetailActionsMenuState();
}

class _DuitDetailActionsMenuState extends State<DuitDetailActionsMenu> {
  final _triggerFocus = FocusNode();

  @override
  void dispose() {
    _triggerFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    // AppBar consumes its horizontal insets before building action buttons.
    // The overlay still needs the navigator's original safe area.
    final insets = MediaQuery.viewPaddingOf(
      Navigator.maybeOf(context)?.context ?? context,
    );
    final layout = DuoLayoutData.of(context);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final bounds = layout.contentBounds;
    final fromLeft =
        layout.verticalBarEdge == 'left' ||
        (layout.verticalBarEdge == null && rtl);
    var left = math.max(insets.left, bounds.isEmpty ? 0.0 : bounds.left);
    var right = math.min(
      media.size.width - insets.right,
      bounds.isEmpty ? media.size.width : bounds.right,
    );
    if (layout.verticalBarEdge == 'left') {
      left = math.max(left, layout.sideBarWidth(media));
    } else if (layout.verticalBarEdge == 'right') {
      right = math.min(right, media.size.width - layout.sideBarWidth(media));
    }
    // The dropdown stays beside its toolbar, clear of the physical fold.
    for (final fold in layout.divisions) {
      if (fold.height <= fold.width) continue;
      if (fromLeft && fold.left > left && fold.left < right) {
        right = fold.left;
      }
      if (!fromLeft && fold.right > left && fold.right < right) {
        left = fold.right;
      }
    }
    final width = math.min(
      math.max(0.0, right - left - 32),
      60 + media.textScaler.scale(150),
    );
    return DuitGlassMenu(
      width: width,
      childFocusNode: _triggerFocus,
      builder: (context, menu, _) => Semantics(
        expanded: menu.isOpen,
        child: IconButton(
          focusNode: _triggerFocus,
          tooltip: widget.tooltip,
          icon: Icon(Icons.more_horiz_rounded, color: context.colors.text),
          style: IconButton.styleFrom(
            minimumSize: const Size.square(DuitAppBarActions.buttonExtent),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: menu.isOpen
                ? context.colors.mutedSurface
                : Colors.transparent,
          ),
          onPressed: () {
            if (menu.isOpen) {
              menu.close();
              return;
            }
            final box = context.findRenderObject()! as RenderBox;
            final x = box.localToGlobal(Offset.zero).dx;
            final trailing = switch (layout.verticalBarEdge) {
              'left' => x + box.size.width + 8,
              'right' => x - width - 8,
              _ => fromLeft ? x : x + box.size.width - width,
            };
            final menuLeft = trailing.clamp(
              left + 16,
              math.max(left + 16, right - 16 - width),
            );
            // Side controls open inward at the trigger's height. Reusing the
            // top toolbar's below-button offset detaches the menu from its rail.
            menu.open(
              position: Offset(
                menuLeft - x,
                layout.verticalBarEdge == null ? box.size.height + 4 : 0,
              ),
            );
          },
        ),
      ),
      items: widget.items,
    );
  }
}
