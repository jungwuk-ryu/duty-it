import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/widgets/custom_toggle_button.dart';
import 'package:flutter/widgets.dart';

class ToggleSettingItem extends StatelessWidget {
  final String text;
  final bool checked;
  final VoidCallback onToggleTap;
  final bool enabled;

  const ToggleSettingItem({
    super.key,
    required this.text,
    required this.checked,
    required this.onToggleTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            color: enabled ? AppColors.black : AppColors.cal1,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.60,
          ),
        ),
        Expanded(child: SizedBox()),
        CustomToggleButton(
            checked: checked,
            enabled: enabled,
            onTap: () {
              if (enabled) onToggleTap();
            },
          ),
      ],
    );
  }
}
