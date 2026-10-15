import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/widgets.dart';

/// 고용노동부 임금체불 명단공개 사업주의 공고임을 목록에서 알리는 표시
class JobWageDefaulterChip extends StatelessWidget {
  const JobWageDefaulterChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.sub,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.main),
      ),
      child: const Text(
        '임금체불 명단공개 사업주',
        style: TextStyle(
          color: AppColors.main,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 1.40,
        ),
      ),
    );
  }
}
