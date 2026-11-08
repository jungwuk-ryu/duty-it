import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class JobDetailTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const JobDetailTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const tabs = ['모집요강', '근무조건', '우대사항', '복리후생'];
  static const double _height = 40;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.surface,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: context.colors.border)),
        ),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = selectedIndex == index;
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(index),
                child: SizedBox(
                  height: _height,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        tabs[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isSelected
                              ? context.colors.text
                              : context.colors.icon,
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          height: 1.20,
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          height: 4,
                          color: isSelected
                              ? context.colors.accent
                              : AppColors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class JobDetailTabHeaderDelegate extends SliverPersistentHeaderDelegate {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const JobDetailTabHeaderDelegate({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  double get minExtent => JobDetailTabBar._height;

  @override
  double get maxExtent => JobDetailTabBar._height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return JobDetailTabBar(selectedIndex: selectedIndex, onTap: onTap);
  }

  @override
  bool shouldRebuild(covariant JobDetailTabHeaderDelegate oldDelegate) {
    return selectedIndex != oldDelegate.selectedIndex ||
        onTap != oldDelegate.onTap;
  }
}
