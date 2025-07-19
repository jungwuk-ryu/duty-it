import 'package:get/get.dart';

class AuthViewController extends GetxController {
  final RxBool _isLogining = RxBool(false);
  bool get isLogining => _isLogining.value;
  set isLogining(v) => _isLogining.value = v;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onLoginButtonTap() async {
    isLogining = true;
  }
}
