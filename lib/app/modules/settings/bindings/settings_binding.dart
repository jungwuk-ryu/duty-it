import 'package:get/get.dart';

import '../controllers/settings_view_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsViewController>(() => SettingsViewController());
  }
}
