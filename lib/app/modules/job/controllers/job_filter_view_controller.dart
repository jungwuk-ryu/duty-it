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

  List<JobEmploymentType> get employmentTypes =>
      JobEmploymentType.values
          .where((element) => element != JobEmploymentType.unknown)
          .toList();

  List<WorkRegion> get workRegions =>
      WorkRegion.values.where((element) => element != WorkRegion.unknown).toList();

  bool isEmploymentTypeSelected(JobEmploymentType type) {
    return filter.employmentTypes.contains(type);
  }

  void clearSelectedEmploymentTypes() {
    _filterRx(filter.copyWith(employmentTypes: <JobEmploymentType>{}));
  }

  void toggleEmploymentTypeSelection(JobEmploymentType type) {
    final values = Set<JobEmploymentType>.from(filter.employmentTypes);

    _filterRx(
      filter.copyWith(
        employmentTypes: values.contains(type)
            ? (values..remove(type))
            : (values..add(type)),
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

    final selected =
        workRegions.where(filter.workRegions.contains).map((e) => e.displayName).toList();
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
