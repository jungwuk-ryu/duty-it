import 'package:duty_it/app/core/enums/job_sorting_type.dart';
import 'package:duty_it/app/modules/job/controllers/job_view_controller.dart';
import 'package:get/get.dart';

class JobSortingModalController extends GetxController {
  JobViewController get _jobController => Get.find<JobViewController>();

  JobSortingType get selectedType => _jobController.sortingType;

  void selectType(JobSortingType type) {
    _jobController.sortingType = type;
  }

  void selectTypeAndClose(JobSortingType type) {
    selectType(type);
    Get.back();
  }
}
