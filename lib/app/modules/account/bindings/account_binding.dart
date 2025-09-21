import 'package:get/get.dart';

import '../controllers/account_view_controller.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountViewController>(() => AccountViewController());
  }
}
