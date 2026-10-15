import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/constants/app_legal.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:flutter/material.dart';

/// 직업안정법 제25조에 따른 임금체불 명단공개 사업주 안내
class JobWageDefaulterNotice extends StatelessWidget {
  final bool? wageDefaulter;
  final DateTime? checkedAt;

  const JobWageDefaulterNotice({
    super.key,
    required this.wageDefaulter,
    this.checkedAt,
  });

  @override
  Widget build(BuildContext context) {
    final isDefaulter = wageDefaulter == true;
    final checkedAt = this.checkedAt;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDefaulter ? AppColors.sub : AppColors.g01,
        borderRadius: BorderRadius.circular(8),
        border: isDefaulter ? Border.all(color: AppColors.main) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDefaulter) ...[
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.main,
                  size: 18,
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '이 구인기관은 고용노동부 임금체불 명단공개 사업주입니다.',
                    style: TextStyle(
                      color: AppColors.main,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.40,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              checkedAt == null
                  ? '「직업안정법」 제25조에 따라 안내합니다.'
                  : '「직업안정법」 제25조에 따라 안내합니다. '
                        '(명단 확인일: ${AppUtils.formatDateTime(checkedAt.toLocal())})',
              style: _bodyStyle,
            ),
          ] else
            const Text(
              '지원 전, 구인기관이 고용노동부 임금체불 명단공개 사업주인지 확인해 보세요.',
              style: _bodyStyle,
            ),
          const SizedBox(height: 6),
          Semantics(
            link: true,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => AppUtils.openWebUrl(AppLegal.wageDefaulterListUrl),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '고용노동부 임금체불 명단공개 확인하기',
                  style: TextStyle(
                    color: AppColors.linkBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.40,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.linkBlue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _bodyStyle = TextStyle(
    color: AppColors.g07,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.40,
  );
}
