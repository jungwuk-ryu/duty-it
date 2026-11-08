import 'dart:ui' show SemanticsRole;

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/widgets/duit_glass.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';

final mainTabs = [
  (label: '행사', icon: Assets.icons.paper.path),
  (label: '채용', icon: Assets.icons.job.path),
  (label: '북마크', icon: Assets.icons.bookmark.path),
  (label: '캘린더', icon: Assets.icons.calendar.path),
];

class MainTabIcon extends StatelessWidget {
  const MainTabIcon({super.key, required this.index, required this.color});

  final int index;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Tint after image sampling to avoid Android bitmap edge seams.
    return ColorFiltered(
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      child: Image.asset(mainTabs[index].icon, width: 20, height: 20),
    );
  }
}

class MainTabBar extends StatefulWidget {
  const MainTabBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    this.axis = Axis.horizontal,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Axis axis;

  @override
  State<MainTabBar> createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar> {
  int? _pressed;
  double? _dragPosition;

  @override
  void didUpdateWidget(MainTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.axis != widget.axis) {
      _pressed = null;
      _dragPosition = null;
    }
  }

  void _clearTouch() {
    if (_pressed == null && _dragPosition == null) return;
    setState(() {
      _pressed = null;
      _dragPosition = null;
    });
  }

  void _select(int index) {
    _clearTouch();
    widget.onSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    final vertical = widget.axis == Axis.vertical;
    final position =
        _dragPosition ?? (_pressed ?? widget.selectedIndex).toDouble();
    final touching = _dragPosition != null || _pressed != null;
    final duration = DuoMotion.durationOf(context);
    final feedbackDuration = duration == Duration.zero
        ? Duration.zero
        : const Duration(milliseconds: 120);
    final rtl = Directionality.of(context) == TextDirection.rtl;

    final bar = Semantics(
      role: SemanticsRole.tabBar,
      container: true,
      explicitChildNodes: true,
      child: DuitGlass(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double slotAt(double x) {
                final offset = rtl ? constraints.maxWidth - x : x;
                return (offset * mainTabs.length / constraints.maxWidth - 0.5)
                    .clamp(0.0, mainTabs.length - 1.0);
              }

              return Listener(
                // An accepted horizontal drag also reports an end on pointer cancellation.
                onPointerCancel: (_) => _clearTouch(),
                child: GestureDetector(
                  excludeFromSemantics: true,
                  // Vertical rails remain scrollable when the keyboard reduces
                  // their height. Taps share the same lens and press feedback.
                  onHorizontalDragStart: vertical
                      ? null
                      : (e) => setState(() {
                          _pressed = null;
                          _dragPosition = slotAt(e.localPosition.dx);
                        }),
                  onHorizontalDragUpdate: vertical
                      ? null
                      : (e) => setState(() {
                          _dragPosition = slotAt(e.localPosition.dx);
                        }),
                  onHorizontalDragEnd: vertical
                      ? null
                      : (_) {
                          final index = _dragPosition?.round();
                          _clearTouch();
                          if (index != null && index != widget.selectedIndex) {
                            widget.onSelected(index);
                          }
                        },
                  onHorizontalDragCancel: vertical ? null : _clearTouch,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: _selectionLens(
                          position: position,
                          touching: touching,
                          travel: _dragPosition == null
                              ? duration
                              : Duration.zero,
                          feedback: feedbackDuration,
                        ),
                      ),
                      Material(
                        type: MaterialType.transparency,
                        child: Flex(
                          direction: widget.axis,
                          crossAxisAlignment: vertical
                              ? CrossAxisAlignment.stretch
                              : CrossAxisAlignment.center,
                          children: [
                            for (var i = 0; i < mainTabs.length; i++)
                              Expanded(
                                child: _tab(
                                  context,
                                  i,
                                  active: i == position.round(),
                                  lifted: touching && i == position.round(),
                                  feedback: feedbackDuration,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
    if (!vertical) return bar;
    // A finite height also allows this bar inside the rail's IntrinsicHeight.
    final slotHeight =
        (20 + 3 + MediaQuery.textScalerOf(context).scale(11) * 1.2 + 16).clamp(
          64.0,
          double.infinity,
        );
    return SizedBox(height: slotHeight * mainTabs.length + 8, child: bar);
  }

  Widget _selectionLens({
    required double position,
    required bool touching,
    required Duration travel,
    required Duration feedback,
  }) => AnimatedAlign(
    duration: travel,
    curve: Curves.easeOutCubic,
    alignment: widget.axis == Axis.vertical
        ? Alignment(0, 2 * position / (mainTabs.length - 1) - 1)
        : AlignmentDirectional(2 * position / (mainTabs.length - 1) - 1, 0),
    child: FractionallySizedBox(
      widthFactor: widget.axis == Axis.vertical ? 1 : 1 / mainTabs.length,
      heightFactor: widget.axis == Axis.vertical ? 1 / mainTabs.length : 1,
      child: AnimatedScale(
        scale: touching && feedback != Duration.zero ? 1.035 : 1,
        duration: feedback,
        child: const DuitGlass(
          style: DuitGlassStyle.selection,
          showShadow: false,
          child: SizedBox.expand(),
        ),
      ),
    ),
  );

  Widget _tab(
    BuildContext context,
    int i, {
    required bool active,
    required bool lifted,
    required Duration feedback,
  }) => MergeSemantics(
    child: Semantics(
      role: SemanticsRole.tab,
      selected: i == widget.selectedIndex,
      hint: MaterialLocalizations.of(context)
          .tabLabel(tabIndex: i + 1, tabCount: mainTabs.length),
      child: InkWell(
        customBorder: const StadiumBorder(),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        onTapDown: (_) => setState(() => _pressed = i),
        onTapCancel: () => setState(() => _pressed = null),
        onTap: () => _select(i),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: widget.axis == Axis.vertical ? 64 : 48,
          ),
          child: TweenAnimationBuilder<Color?>(
            duration: feedback,
            tween: ColorTween(
              end: active ? const Color(0xFFA63129) : AppColors.g07,
            ),
            builder: (context, color, _) => Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  duration: feedback,
                  scale: lifted && feedback != Duration.zero ? 1.1 : 1,
                  child: MainTabIcon(index: i, color: color ?? AppColors.g07),
                ),
                const SizedBox(height: 3),
                Text(
                  mainTabs[i].label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
