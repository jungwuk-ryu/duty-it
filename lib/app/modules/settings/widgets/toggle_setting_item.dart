import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/widgets/custom_toggle_button.dart';
import 'package:flutter/widgets.dart';

class ToggleSettingItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool checked;
  final Function() onToggleTap;
  final bool enabled;

  const ToggleSettingItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.checked,
    required this.onToggleTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: enabled ? AppColors.black : AppColors.cal1,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.60,
              ),
            ),
            Visibility(
              visible: subtitle != null,
              child: Text(
                subtitle ?? "",
                style: TextStyle(
                  color: enabled ? AppColors.g05 : AppColors.cal1,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  height: 1.60,
                ),
              ),
            ),
          ],
        ),
        Expanded(child: SizedBox()),
        CustomToggleButton(
          checked: checked,
          enabled: enabled,
          onTap: () async {
            if (enabled) await onToggleTap();
          },
        ),
      ],
    );
  }
}
