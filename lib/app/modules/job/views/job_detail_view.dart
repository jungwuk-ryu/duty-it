import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/extensions/job_posting_x.dart';
import 'package:duty_it/app/modules/job/controllers/job_detail_view_controller.dart';
import 'package:duty_it/app/modules/job/widgets/detail/job_detail_bottom_bar.dart';
import 'package:duty_it/app/modules/job/widgets/detail/job_detail_footer.dart';
import 'package:duty_it/app/modules/job/widgets/detail/job_detail_info_row.dart';
import 'package:duty_it/app/modules/job/widgets/detail/job_detail_section.dart';
import 'package:duty_it/app/modules/job/widgets/detail/job_detail_summary_card.dart';
import 'package:duty_it/app/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobDetailView extends GetView<JobDetailViewController> {
  const JobDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SimpleAppBar(title: '채용', bottomMargin: 0),
            Expanded(
              child: Obx(() {
                final job = controller.job;
                final sectionRows =
                    <Widget>[
                          JobDetailSection(
                            title: '모집요강',
                            rows: [
                              if (job.jobCategoryText != null)
                                JobDetailInfoRowData(
                                  label: '직종',
                                  value: job.jobCategoryText!,
                                ),
                              if (job.careerText != null)
                                JobDetailInfoRowData(
                                  label: '경력',
                                  value: job.careerText!,
                                ),
                              if (job.educationText != null)
                                JobDetailInfoRowData(
                                  label: '학력',
                                  value: job.educationText!,
                                ),
                            ],
                          ),
                          JobDetailSection(
                            title: '근무조건',
                            rows: [
                              if (job.employmentTypeText != null)
                                JobDetailInfoRowData(
                                  label: '고용 형태',
                                  value: job.employmentTypeText!,
                                ),
                              if (job.salaryText != null)
                                JobDetailInfoRowData(
                                  label: '임금 조건',
                                  value: job.salaryText!,
                                ),
                              if (job.locationText.isNotEmpty)
                                JobDetailInfoRowData(
                                  label: '근무 예정지',
                                  value: job.locationText,
                                ),
                            ],
                          ),
                          JobDetailSection(
                            title: '기타사항',
                            rows: [
                              if (job.postedAtText != null)
                                JobDetailInfoRowData(
                                  label: '등록일',
                                  value: job.postedAtText!,
                                ),
                              if (job.expiresAtText != null)
                                JobDetailInfoRowData(
                                  label: '마감일',
                                  value: job.expiresAtText!,
                                  valueColor: AppColors.main,
                                ),
                              if (job.sourceText != null)
                                JobDetailInfoRowData(
                                  label: '정보 출처',
                                  value: job.sourceText!,
                                ),
                            ],
                          ),
                        ]
                        .whereType<JobDetailSection>()
                        .where((section) => section.rows.isNotEmpty)
                        .toList();

                return Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              job.companyName,
                              style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                height: 1.20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              job.title,
                              style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                height: 1.20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              job.closeLabel,
                              style: const TextStyle(
                                color: AppColors.main,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                height: 1.60,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: JobDetailSummaryCard(job: job),
                          ),
                          if (sectionRows.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Column(children: sectionRows),
                            ),
                          ],
                          const SizedBox(height: 24),
                          JobDetailFooter(sourceType: job.sourceType),
                        ],
                      ),
                    ),
                    if (controller.isLoading.value)
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(
                          minHeight: 2,
                          color: AppColors.main,
                          backgroundColor: AppColors.g02,
                        ),
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => JobDetailBottomBar(
          jobRx: controller.jobRx,
          onApplyTap: controller.openPostingUrl,
          isApplyEnabled: controller.job.postingUrl.isNotEmpty,
        ),
      ),
    );
  }
}
