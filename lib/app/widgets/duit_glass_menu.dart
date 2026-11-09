import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/widgets/duit_glass.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/material.dart';

/// Shared dropdown chrome; callers retain their trigger and pane positioning.
class DuitGlassMenu extends StatelessWidget {
  const DuitGlassMenu({
    super.key,
    required this.width,
    required this.builder,
    required this.items,
    this.childFocusNode,
  });

  final double width;
  final MenuAnchorChildBuilder builder;
  final List<Widget> items;
  final FocusNode? childFocusNode;

  @override
  Widget build(BuildContext context) {
    final highContrast = MediaQuery.highContrastOf(context);
    final reduceMotion = DuoMotion.durationOf(context) == Duration.zero;
    return MenuAnchor(
      childFocusNode: childFocusNode,
      consumeOutsideTap: true,
      crossAxisUnconstrained: false,
      alignmentOffset: Offset(-width, 4),
      style: MenuStyle(
        alignment: AlignmentDirectional.bottomEnd,
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        elevation: const WidgetStatePropertyAll(6),
        shadowColor: const WidgetStatePropertyAll(Color(0x4D19212A)),
        side: WidgetStatePropertyAll(
          BorderSide(
            color: highContrast ? context.colors.icon : const Color(0x46757C84),
            width: highContrast ? 1 : .75,
          ),
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
      builder: (context, menu, child) => PopScope(
        canPop: !menu.isOpen,
        onPopInvokedWithResult: (popped, _) {
          if (!popped && menu.isOpen) menu.close();
        },
        child: builder(context, menu, child),
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
                    children: items,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DuitGlassMenuItem extends StatelessWidget {
  const DuitGlassMenuItem({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.selected = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? leadingIcon;
  final bool selected;

  @override
  Widget build(BuildContext context) => MenuItemButton(
    autofocus: selected,
    onPressed: onPressed,
    style: MenuItemButton.styleFrom(
      minimumSize: const Size(0, 48),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      foregroundColor: context.colors.text,
      disabledForegroundColor: context.colors.disabled,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    leadingIcon: leadingIcon,
    child: Text(
      label,
      style: TextStyle(
        fontSize: 15,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
      ),
    ),
  );
}
