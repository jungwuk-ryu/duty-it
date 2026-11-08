import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/widgets/app_asset_icon.dart';
import 'package:duty_it/app/widgets/duit_glass.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class DuitTopAppBar extends StatelessWidget {
  final bool showNotifications;
  final bool hasNewNotification;
  final VoidCallback onNotificationsTap;
  final VoidCallback onMenuTap;
  final bool actionsOnly;

  const DuitTopAppBar({
    super.key,
    required this.showNotifications,
    required this.hasNewNotification,
    required this.onNotificationsTap,
    required this.onMenuTap,
    this.actionsOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final actions = DuitAppBarActions(
      showNotifications: showNotifications,
      hasNewNotification: hasNewNotification,
      onNotificationsTap: onNotificationsTap,
      onMenuTap: onMenuTap,
      vertical: actionsOnly,
    );
    if (actionsOnly) return actions;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Image.asset(Assets.icons.logo.path, width: 16, height: 16),
          const SizedBox(width: 7),
          Text(
            '듀잇',
            style: TextStyle(
              color: context.colors.text,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 1.60,
            ),
          ),
          const Spacer(),
          if (DuoLayoutData.of(context).verticalBarEdge == null) actions,
        ],
      ),
    );
  }
}

/// The original app bar assets and actions in either toolbar orientation.
class DuitAppBarActions extends StatelessWidget {
  const DuitAppBarActions({
    super.key,
    required this.showNotifications,
    required this.hasNewNotification,
    required this.onNotificationsTap,
    required this.onMenuTap,
    this.vertical = false,
  });
  final bool showNotifications;
  final bool hasNewNotification;
  final VoidCallback onNotificationsTap;
  final VoidCallback onMenuTap;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final buttons = [
      if (showNotifications)
        _button(
          '알림',
          onNotificationsTap,
          Assets.icons.bell.path,
          14,
          18,
          showBadge: hasNewNotification,
        ),
      _button('메뉴', onMenuTap, Assets.icons.hamburger.path, 18, 14),
    ];
    return DuitGlass(
      // Inline toolbar controls sit on an opaque header, so they need no shadow.
      showShadow: vertical,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: vertical
            ? Column(mainAxisSize: MainAxisSize.min, children: buttons)
            : Row(mainAxisSize: MainAxisSize.min, children: buttons),
      ),
    );
  }

  Widget _button(
    String label,
    VoidCallback onTap,
    String asset,
    double width,
    double height, {
    bool showBadge = false,
  }) => Semantics(
    label: label,
    button: true,
    child: Tooltip(
      message: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: SizedBox.square(
          dimension: 44,
          child: Center(
            child: Badge(
              isLabelVisible: showBadge,
              smallSize: 5,
              backgroundColor: AppColors.main,
              child: AppAssetIcon(asset: asset, width: width, height: height),
            ),
          ),
        ),
      ),
    ),
  );
}
