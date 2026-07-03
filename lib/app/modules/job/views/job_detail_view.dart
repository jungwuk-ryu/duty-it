import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/extensions/job_posting_x.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/modules/job/controllers/job_detail_view_controller.dart';
import 'package:duty_it/app/modules/job/widgets/detail/job_detail_bottom_bar.dart';
import 'package:duty_it/app/modules/job/widgets/detail/job_detail_chip_wrap.dart';
import 'package:duty_it/app/modules/job/widgets/detail/job_detail_footer.dart';
import 'package:duty_it/app/modules/job/widgets/detail/job_detail_info_row.dart';
import 'package:duty_it/app/modules/job/widgets/detail/job_detail_media.dart';
import 'package:duty_it/app/modules/job/widgets/detail/job_detail_section.dart';
import 'package:duty_it/app/modules/job/widgets/detail/job_detail_summary_card.dart';
import 'package:duty_it/app/modules/job/widgets/detail/job_detail_tab_bar.dart';
import 'package:duty_it/app/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobDetailView extends StatefulWidget {
  const JobDetailView({super.key});

  @override
  State<JobDetailView> createState() => _JobDetailViewState();
}

class _JobDetailViewState extends State<JobDetailView> {
  final JobDetailViewController controller =
      Get.find<JobDetailViewController>();
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(4, (_) => GlobalKey());
  int _selectedTabIndex = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SimpleAppBar(title: '채용', bottomMargin: 0),
            Expanded(
              child: Obx(() {
                final job = controller.job;

                return Stack(
                  children: [
                    NotificationListener<ScrollNotification>(
                      onNotification: _handleScrollNotification,
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          SliverToBoxAdapter(child: _HeaderContent(job: job)),
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: JobDetailTabHeaderDelegate(
                              selectedIndex: _selectedTabIndex,
                              onTap: _scrollToSection,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                JobDetailMedia(imageUrl: job.attachFileUrlText),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    24,
                                    24,
                                    24,
                                    0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _section(
                                        0,
                                        _buildRecruitmentSection(job),
                                      ),
                                      _section(
                                        1,
                                        _buildWorkConditionSection(job),
                                      ),
                                      _section(2, _buildPreferenceSection(job)),
                                      _section(3, _buildWelfareSection(job)),
                                      _buildEtcSection(job),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: JobDetailFooter(
                                sourceType: job.sourceType,
                              ),
                            ),
                          ),
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

  void _scrollToSection(int index) {
    setState(() => _selectedTabIndex = index);
    final context = _sectionKeys[index].currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      alignment: 0.04,
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      _syncSelectedTabWithScroll();
    }
    return false;
  }

  void _syncSelectedTabWithScroll() {
    var nextIndex = _selectedTabIndex;
    for (var i = 0; i < _sectionKeys.length; i++) {
      final context = _sectionKeys[i].currentContext;
      if (context == null) continue;

      final renderObject = context.findRenderObject();
      if (renderObject is! RenderBox) continue;

      final top = renderObject.localToGlobal(Offset.zero).dy;
      if (top <= 360) nextIndex = i;
    }

    if (nextIndex != _selectedTabIndex && mounted) {
      setState(() => _selectedTabIndex = nextIndex);
    }
  }

  Widget _section(int index, Widget child) {
    return KeyedSubtree(key: _sectionKeys[index], child: child);
  }

  JobDetailSection _buildRecruitmentSection(JobPosting job) {
    return JobDetailSection(
      title: '모집요강',
      rows: <JobDetailInfoRowData?>[
        _row('모집 인원', job.recruitmentCountText),
        _row('모집 직종', job.jobCategoryText),
        _optionalRow('직종 키워드', job.keywordText),
        _row('경력', job.careerText),
        _optionalRow('자격 면허', job.certificateText),
        _optionalRow('관련 직종', job.relatedJobText),
        _row('학력', job.educationText),
        _optionalRow('전형방법', job.selectionMethodText),
        _optionalRow('접수방법', job.receiptMethodText),
        _optionalRow('제출서류', job.submitDocumentText),
        _optionalRow('직무내용', job.jobContentText),
      ].whereType<JobDetailInfoRowData>().toList(),
    );
  }

  JobDetailSection _buildWorkConditionSection(JobPosting job) {
    return JobDetailSection(
      title: '근무조건',
      rows: [
        _row('고용 형태', job.employmentTypeText),
        _row('근무 시간', job.workTimeText),
        _row('사회 보험', job.fourInsText),
        _row('임금 조건', job.salaryText),
        _row('근무 형태', job.workTypeText),
        _row('퇴직 급여', job.retirePayText),
        _row('근무 예정지', job.locationText),
      ],
      children: [
        if (_optionalRow('인근 전철역', job.nearLineText) case final row?)
          JobDetailInfoRow(row: row),
        if (_optionalRow('채용 담당 부서', job.chargerDepartmentText) case final row?)
          JobDetailInfoRow(row: row),
        if (_optionalRow('문의 전화', job.contactTelnoText) case final row?)
          JobDetailInfoRow(row: row),
      ],
    );
  }

  JobDetailSection _buildPreferenceSection(JobPosting job) {
    return JobDetailSection(
      title: '우대사항',
      rows: [
        _row('전공', job.majorText),
        _row('컴퓨터 활용 능력', job.computerAbilityText),
        _row('외국어 능력', job.foreignLanguageText),
        _row('우대조건', job.preferredConditionText),
        _row('기타 우대사항', job.etcPreferredConditionText),
      ],
    );
  }

  JobDetailSection _buildWelfareSection(JobPosting job) {
    return JobDetailSection(
      title: '복리후생',
      rows: const [],
      children: [
        if (job.welfareTags.isNotEmpty) _chipInfoRow('복리후생', job.welfareTags),
        if (_optionalRow('기타 복리후생', job.etcWelfareText) case final row?)
          JobDetailInfoRow(row: row),
        if (_optionalRow('장애인 편의시설', job.disabilityConvenienceText)
            case final row?)
          JobDetailInfoRow(row: row),
      ],
    );
  }

  JobDetailSection _buildEtcSection(JobPosting job) {
    return JobDetailSection(
      title: '기타사항',
      rows: [
        _row('병역 특례 복무자 채용', job.militaryServiceText),
        _row('그 밖의 희망사항', job.etcHopeText),
        _row('구인인증번호', job.wantedAuthNoText),
        _row('등록일', job.postedAtText),
        _row('마감일', job.expiresAtText, valueColor: AppColors.main),
        _row('정보 출처', job.sourceText),
      ],
    );
  }

  JobDetailInfoRowData _row(String label, String? value, {Color? valueColor}) {
    return JobDetailInfoRowData(
      label: label,
      value: value == null || value.isEmpty ? '-' : value,
      valueColor: valueColor,
    );
  }

  JobDetailInfoRowData? _optionalRow(
    String label,
    String? value, {
    Color? valueColor,
  }) {
    if (value == null || value.isEmpty) return null;
    return JobDetailInfoRowData(
      label: label,
      value: value,
      valueColor: valueColor,
    );
  }

  Widget _chipInfoRow(String label, List<String> chips) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 118,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.g05,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.60,
              ),
            ),
          ),
          Expanded(child: JobDetailChipWrap(chips: chips)),
        ],
      ),
    );
  }
}

class _HeaderContent extends StatelessWidget {
  final JobPosting job;

  const _HeaderContent({required this.job});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        ],
      ),
    );
  }
}
