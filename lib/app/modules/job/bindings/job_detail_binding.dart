import 'package:duty_it/app/modules/job/controllers/job_detail_view_controller.dart';
import 'package:get/get.dart';

class JobDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<JobDetailViewController>(JobDetailViewController());
  }
}
