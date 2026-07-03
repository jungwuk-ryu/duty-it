import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/enums/job_source_type.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class JobDetailFooter extends StatelessWidget {
  final JobSourceType sourceType;

  const JobDetailFooter({super.key, required this.sourceType});

  @override
  Widget build(BuildContext context) {
    final isWork24 = sourceType == JobSourceType.work24;
    final sourceName = sourceType.displayName.isEmpty
        ? '정보 출처 미제공'
        : sourceType.displayName;

    return Container(
      width: double.infinity,
      color: AppColors.g01,
      padding: const EdgeInsets.fromLTRB(24, 11, 24, 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '정보출처',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                  height: 1.60,
                ),
              ),
              const SizedBox(height: 7),
              if (isWork24)
                Image.asset(
                  Assets.icons.work24.path,
                  width: 79,
                  height: 22,
                  fit: BoxFit.contain,
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.g03),
                  ),
                  child: Text(
                    sourceName,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.40,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: isWork24
                  ? RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          height: 1.40,
                        ),
                        children: [
                          TextSpan(text: '본 자료는 고용노동부 고용24'),
                          TextSpan(
                            text: '(www.work24.go.kr)\n',
                            style: TextStyle(color: AppColors.linkBlue),
                          ),
                          TextSpan(text: '에서 제공된 정보이며, 무단복제 및 배포를 금지합니다.'),
                        ],
                      ),
                    )
                  : Text(
                      '$sourceName에서 제공된 채용 정보입니다.',
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        height: 1.40,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
