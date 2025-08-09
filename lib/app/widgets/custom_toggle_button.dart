import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/widgets.dart';

class CustomToggleButton extends StatelessWidget {
  final bool checked;
  final VoidCallback onTap;
  final bool enabled;

  const CustomToggleButton({
    super.key,
    required this.checked,
    required this.onTap, this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (enabled) onTap();
      },
      child: Container(
        width: 44,
        height: 22,
        padding: EdgeInsets.symmetric(horizontal: 1),
        decoration: ShapeDecoration(
          color: enabled ? (checked ? AppColors.main : AppColors.g05) : AppColors.g02,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.50),
          ),
        ),
        child: Row(
          mainAxisAlignment: checked ? MainAxisAlignment.end : MainAxisAlignment.start, 
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: ShapeDecoration(
                color: AppColors.white,
                shape: OvalBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
