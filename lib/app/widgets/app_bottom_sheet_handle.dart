import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/widgets.dart';

class AppBottomSheetHandle extends StatelessWidget {
  const AppBottomSheetHandle({
    super.key,
    this.topPadding = 8,
    this.bottomPadding = 16,
  });

  final double topPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Center(
        child: SizedBox(
          width: 48,
          height: 4,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.g04,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ),
    );
  }
}
