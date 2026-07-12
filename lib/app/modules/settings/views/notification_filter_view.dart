import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/settings/controllers/notification_filter_controller.dart';
import 'package:duty_it/app/modules/settings/models/notification_subscription.dart';
import 'package:duty_it/app/widgets/app_normal_button.dart';
import 'package:duty_it/app/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationFilterView extends GetView<NotificationFilterController> {
  const NotificationFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SimpleAppBar(
              title: controller.mode.title,
              bottomMargin: 0,
              endChildren: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: controller.resetDrafts,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text(
                      '초기화',
                      style: TextStyle(
                        color: AppColors.g05,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1.60,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                  children: [
                    const _SectionHeader(title: '키워드'),
                    const SizedBox(height: 10),
                    _KeywordInput(controller: controller),
                    const SizedBox(height: 12),
                    _SelectedDraftsWrap(
                      drafts: controller.drafts.values
                          .where(
                            (draft) =>
                                draft.type ==
                                    NotificationSubscriptionType.eventKeyword ||
                                draft.type ==
                                    NotificationSubscriptionType.jobKeyword,
                          )
                          .toList(),
                      onRemove: controller.removeDraft,
                    ),
                    if (controller.isEventMode) ...[
                      const SizedBox(height: 28),
                      const _SectionHeader(title: '행사 유형'),
                      const SizedBox(height: 10),
                      _EventTypeChips(controller: controller),
                      const SizedBox(height: 28),
                      const _SectionHeader(title: '주최'),
                      const SizedBox(height: 10),
                      _HostSelectionField(controller: controller),
                      const SizedBox(height: 12),
                      _SelectedDraftsWrap(
                        drafts: controller.drafts.values
                            .where(
                              (draft) =>
                                  draft.type ==
                                  NotificationSubscriptionType.eventHost,
                            )
                            .toList(),
                        emptyText: '선택한 주최가 없어요.',
                        onRemove: controller.removeDraft,
                      ),
                    ] else ...[
                      const SizedBox(height: 28),
                      const _SectionHeader(title: '회사'),
                      const SizedBox(height: 10),
                      _TargetSearchField(
                        controller: controller.targetSearchController,
                        hintText: '북마크한 회사를 검색해 보세요.',
                      ),
                      const SizedBox(height: 14),
                      _CompanyList(controller: controller),
                    ],
                  ],
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Obx(
                () => AppNormalButton(
                  text: controller.isSaving.value ? '저장 중' : '필터 적용',
                  onTap: controller.apply,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.black,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        height: 1.20,
      ),
    );
  }
}

class _KeywordInput extends StatelessWidget {
  final NotificationFilterController controller;

  const _KeywordInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.g02,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.keywordController,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => controller.addKeyword(),
              onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: controller.mode.keywordHint,
                hintStyle: const TextStyle(
                  color: AppColors.g05,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                isDense: true,
                isCollapsed: true,
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: controller.addKeyword,
            child: const Icon(Icons.add, color: AppColors.black, size: 24),
          ),
        ],
      ),
    );
  }
}

class _TargetSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const _TargetSearchField({required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.g02,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
        style: const TextStyle(
          color: AppColors.black,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.g05, fontSize: 15),
          isDense: true,
          isCollapsed: true,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _HostSelectionField extends StatelessWidget {
  final NotificationFilterController controller;

  const _HostSelectionField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: controller.showHostSelectionBottomModal,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.g02,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Expanded(
              child: Text(
                '찾으시는 주최기관을 검색해 보세요.',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.g05,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.20,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.g05, size: 24),
          ],
        ),
      ),
    );
  }
}

class _SelectedDraftsWrap extends StatelessWidget {
  final List<NotificationSubscriptionDraft> drafts;
  final String emptyText;
  final void Function(String key) onRemove;

  const _SelectedDraftsWrap({
    required this.drafts,
    this.emptyText = '추가된 키워드가 없어요.',
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (drafts.isEmpty) {
      return Text(
        emptyText,
        style: const TextStyle(
          color: AppColors.g05,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.60,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: drafts
          .map(
            (draft) => _FilterChip(
              label: draft.label,
              selected: true,
              onTap: () => onRemove(draft.key),
            ),
          )
          .toList(),
    );
  }
}

class _EventTypeChips extends StatelessWidget {
  final NotificationFilterController controller;

  const _EventTypeChips({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: controller.eventTypes
            .map(
              (eventType) => _FilterChip(
                label: eventType.displayName,
                selected: controller.isEventTypeSelected(eventType),
                onTap: () => controller.toggleEventType(eventType),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _CompanyList extends StatelessWidget {
  final NotificationFilterController controller;

  const _CompanyList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final companies = controller.filteredCompanies;
      if (controller.companies.isEmpty) {
        return const _EmptyText('북마크한 회사가 아직 없어요.');
      }
      if (companies.isEmpty) {
        return const _EmptyText('검색 결과가 없어요.');
      }

      return Column(
        children: companies
            .map(
              (company) =>
                  _CompanyOption(controller: controller, company: company),
            )
            .toList(),
      );
    });
  }
}

class _CompanyOption extends StatelessWidget {
  final NotificationFilterController controller;
  final NotificationCompany company;

  const _CompanyOption({required this.controller, required this.company});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _CheckRow(
        title: company.name,
        selected: controller.isCompanySelected(company),
        onTap: () => controller.toggleCompany(company),
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _CheckRow({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? AppColors.main : AppColors.black,
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  height: 1.60,
                ),
              ),
            ),
            Icon(
              Icons.check,
              color: selected ? AppColors.main : AppColors.transparent,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: ShapeDecoration(
          color: selected ? AppColors.sub : AppColors.g02,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.main : AppColors.g07,
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            height: 1.20,
          ),
        ),
      ),
    );
  }
}

class _EmptyText extends StatelessWidget {
  final String text;

  const _EmptyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.g05,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.60,
          ),
        ),
      ),
    );
  }
}
