import 'package:duty_it/app/modules/job/controllers/job_filter_view_controller.dart';
import 'package:get/get.dart';

class JobFilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<JobFilterViewController>(JobFilterViewController());
  }
}
