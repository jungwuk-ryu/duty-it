import 'package:duty_it/app/services/job_filter/models/job_filter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class JobFilterService extends GetxService {
  static const String storageBoxName = 'jobFilter';

  final Rx<JobFilter> filterRx = const JobFilter().obs;
  JobFilter get filter => filterRx.value;

  @override
  void onInit() {
    super.onInit();
    final box = GetStorage(storageBoxName);
    final json = box.read('filter');

    if (json != null) {
      try {
        if (json is Map) {
          filterRx.value = JobFilter.fromJson(Map<String, dynamic>.from(json));
        } else {
          box.remove('filter');
        }
      } catch (_) {
        box.remove('filter');
      }
    }

    debounce(filterRx, (_) {
      box.write('filter', filter.toJson());
    }, time: const Duration(milliseconds: 300));
  }

  void updateFilter(JobFilter filter) {
    filterRx.value = filter;
  }

  bool hasFilterChanges() {
    return filter.workRegions.isNotEmpty || filter.employmentTypes.isNotEmpty;
  }

  void resetFilter() {
    updateFilter(const JobFilter());
  }
}
