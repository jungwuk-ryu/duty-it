import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/widgets.dart';

class CustomToggleButton extends StatelessWidget {
  final bool checked;
  final VoidCallback onTap;

  const CustomToggleButton({
    super.key,
    required this.checked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 22,
        padding: EdgeInsets.symmetric(horizontal: 1),
        decoration: ShapeDecoration(
          color: checked ? AppColors.main : AppColors.g05,
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
