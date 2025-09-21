import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/widgets/tap_scale.dart';
import 'package:flutter/cupertino.dart';

class AppNormalButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;

  const AppNormalButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TapScale(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color ?? AppColors.main,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.20,
            ),
          ),
        ),
      ),
    );
  }
}
