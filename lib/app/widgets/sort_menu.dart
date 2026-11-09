import 'dart:math' as math;

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/enums/sort_option.dart';
import 'package:duty_it/app/widgets/duit_glass_menu.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SortMenu<T extends SortOption> extends StatefulWidget {
  const SortMenu({
    super.key,
    required this.selected,
    required this.options,
    required this.onSelected,
  });

  final T selected;
  final List<T> options;
  final ValueChanged<T> onSelected;

  @override
  State<SortMenu<T>> createState() => _SortMenuState<T>();
}

class _SortMenuState<T extends SortOption> extends State<SortMenu<T>> {
  final _triggerFocus = FocusNode();

  @override
  void dispose() {
    _triggerFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final layout = DuoLayoutData.of(context);
    final bounds = layout.contentBounds;
    // FoldSafeHeader places these controls in the leading pane.
    final insets = MediaQuery.viewPaddingOf(context);
    final paneLeft = bounds.isEmpty ? insets.left : bounds.left;
    final paneWidth = bounds.isEmpty
        ? MediaQuery.sizeOf(context).width - insets.horizontal
        : (layout.verticalFold?.left ?? bounds.right) - bounds.left;
    final width = math.min(
      math.max(0.0, paneWidth - 32),
      60 + MediaQuery.textScalerOf(context).scale(150),
    );
    final reduceMotion = DuoMotion.durationOf(context) == Duration.zero;
    return DuitGlassMenu(
      width: width,
      childFocusNode: _triggerFocus,
      builder: (context, menu, _) => Semantics(
        expanded: menu.isOpen,
        child: TextButton(
          focusNode: _triggerFocus,
          onPressed: () {
            if (menu.isOpen) {
              menu.close();
            } else {
              final box = context.findRenderObject()! as RenderBox;
              final x = box.localToGlobal(Offset.zero).dx;
              final trailing = Directionality.of(context) == TextDirection.ltr
                  ? x + box.size.width - width
                  : x;
              // A wrapped trigger can sit at the start of the fold pane.
              final left = trailing.clamp(
                paneLeft + 16,
                math.max(paneLeft + 16, paneLeft + paneWidth - 16 - width),
              );
              menu.open(position: Offset(left - x, box.size.height + 4));
            }
          },
          style: TextButton.styleFrom(
            minimumSize: const Size(48, 48),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            foregroundColor: menu.isOpen
                ? context.colors.text
                : context.colors.icon,
            backgroundColor: menu.isOpen
                ? context.colors.mutedSurface
                : Colors.transparent,
            shape: const StadiumBorder(),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.selected.shortName,
                semanticsLabel: '정렬, ${widget.selected.displayName}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5),
              AnimatedRotation(
                turns: menu.isOpen ? 0.5 : 0,
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 150),
                child: const Icon(Icons.keyboard_arrow_down_rounded, size: 17),
              ),
            ],
          ),
        ),
      ),
      items: [for (final option in widget.options) _option(option)],
    );
  }

  Widget _option(T option) {
    final selected = option == widget.selected;
    return MergeSemantics(
      child: Semantics(
        checked: selected,
        inMutuallyExclusiveGroup: true,
        child: DuitGlassMenuItem(
          label: option.displayName,
          selected: selected,
          onPressed: () {
            if (!mounted || selected) return;
            HapticFeedback.selectionClick();
            widget.onSelected(option);
          },
          leadingIcon: SizedBox(
            width: 18,
            child: selected
                ? Icon(
                    Icons.check_rounded,
                    size: 17,
                    color: context.colors.accent,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
