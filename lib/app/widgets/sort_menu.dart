import 'dart:math' as math;

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/enums/sort_option.dart';
import 'package:duty_it/app/widgets/duit_glass.dart';
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
    return MenuAnchor(
      childFocusNode: _triggerFocus,
      consumeOutsideTap: true,
      crossAxisUnconstrained: false,
      alignmentOffset: Offset(-width, 4),
      style: const MenuStyle(
        alignment: AlignmentDirectional.bottomEnd,
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        elevation: WidgetStatePropertyAll(8),
        shadowColor: WidgetStatePropertyAll(Color(0x42000000)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
      builder: (context, menu, _) => PopScope(
        canPop: !menu.isOpen,
        onPopInvokedWithResult: (popped, _) {
          if (!popped && menu.isOpen) menu.close();
        },
        child: Semantics(
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
              minimumSize: const Size(44, 44),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              foregroundColor: menu.isOpen ? AppColors.black : AppColors.g06,
              backgroundColor: menu.isOpen ? AppColors.g02 : Colors.transparent,
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
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      menuChildren: [
        SizedBox(
          width: width,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: reduceMotion ? 1 : .94, end: 1),
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            builder: (_, scale, child) => Transform.scale(
              alignment: AlignmentDirectional.topEnd.resolve(
                Directionality.of(context),
              ),
              scale: scale,
              child: child,
            ),
            child: DuitGlass(
              radius: 20,
              showShadow: false,
              child: Material(
                type: MaterialType.transparency,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final option in widget.options) _option(option),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _option(T option) {
    final selected = option == widget.selected;
    return MergeSemantics(
      child: Semantics(
        checked: selected,
        inMutuallyExclusiveGroup: true,
        child: MenuItemButton(
          autofocus: selected,
          onPressed: () {
            if (!mounted || selected) return;
            HapticFeedback.selectionClick();
            widget.onSelected(option);
          },
          style: MenuItemButton.styleFrom(
            minimumSize: const Size(0, 44),
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
            foregroundColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          leadingIcon: SizedBox(
            width: 18,
            child: selected
                ? const Icon(
                    Icons.check_rounded,
                    size: 17,
                    color: AppColors.main,
                  )
                : null,
          ),
          child: Text(
            option.displayName,
            style: TextStyle(
              fontSize: 15,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
