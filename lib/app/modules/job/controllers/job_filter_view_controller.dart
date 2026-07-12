import 'package:duty_it/app/core/enums/job_employment_type.dart';
import 'package:duty_it/app/core/enums/work_region.dart';
import 'package:duty_it/app/modules/job/widgets/filter/job_region_selection_bottom_modal.dart';
import 'package:duty_it/app/services/job_filter/job_filter_service.dart';
import 'package:duty_it/app/services/job_filter/models/job_filter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobFilterViewController extends GetxController {
  JobFilterService get service => Get.find<JobFilterService>();

  final Rx<JobFilter> _filterRx = const JobFilter().obs;
  JobFilter get filter => _filterRx.value;

  @override
  void onInit() {
    super.onInit();
    _filterRx.value = service.filter;
  }

  List<JobCareerFilter> get careerFilters => JobCareerFilter.values;

  List<JobEmploymentType> get employmentTypes =>
      supportedJobFilterEmploymentTypes;

  List<WorkRegion> get workRegions => supportedJobFilterWorkRegions;

  bool get showClosed => filter.showClosed;
  set showClosed(bool value) => _filterRx(filter.copyWith(showClosed: value));

  bool isCareerFilterSelected(JobCareerFilter? careerFilter) {
    if (careerFilter == null) {
      return filter.careerFilters.isEmpty;
    }
    return filter.careerFilters.contains(careerFilter);
  }

  void clearSelectedCareerFilters() {
    _filterRx(filter.copyWith(careerFilters: <JobCareerFilter>{}));
  }

  void toggleCareerFilterSelection(JobCareerFilter careerFilter) {
    final values = Set<JobCareerFilter>.from(filter.careerFilters);

    _filterRx(
      filter.copyWith(
        careerFilters: values.contains(careerFilter)
            ? (values..remove(careerFilter))
            : (values..add(careerFilter)),
      ),
    );
  }

  bool isEmploymentTypeSelected(JobEmploymentType? type) {
    if (type == null) {
      return filter.employmentTypes.isEmpty;
    }
    return filter.employmentTypes.contains(type);
  }

  void clearSelectedEmploymentTypes() {
    _filterRx(filter.copyWith(employmentTypes: <JobEmploymentType>{}));
  }

  void selectEmploymentType(JobEmploymentType? type) {
    _filterRx(
      filter.copyWith(
        employmentTypes: type == null ? <JobEmploymentType>{} : {type},
      ),
    );
  }

  bool isRegionSelected(WorkRegion? region) {
    if (region == null) {
      return filter.workRegions.isEmpty;
    }
    return filter.workRegions.contains(region);
  }

  void selectAllRegions() {
    _filterRx(filter.copyWith(workRegions: <WorkRegion>{}));
  }

  void toggleRegionSelection(WorkRegion region) {
    final values = Set<WorkRegion>.from(filter.workRegions);
    if (values.contains(region)) {
      values.remove(region);
    } else {
      values.add(region);
    }
    _filterRx(filter.copyWith(workRegions: values));
  }

  String get selectedRegionSummary {
    if (filter.workRegions.isEmpty) {
      return '전체';
    }

    final selected = workRegions
        .where(filter.workRegions.contains)
        .map((e) => e.displayName)
        .toList();
    if (selected.isEmpty) {
      return '전체';
    }

    if (selected.length == 1) {
      return selected.first;
    }

    return '${selected.first} 외 ${selected.length - 1}건';
  }

  bool get hasSelectedRegions => filter.workRegions.isNotEmpty;

  void onResetSettingsButtonClicked() {
    _filterRx(const JobFilter());
  }

  void onApplyButtonClicked() {
    service.updateFilter(filter);
    Get.back();
  }

  void showRegionSelectionBottomModal() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const JobRegionSelectionBottomModal(),
    );
  }
}
