import 'package:get/get.dart';

class AccountController extends GetxController {
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

  String getUserName() {
    return "수줍은 복숭아";
  }

  void onUserNameEditButtonClicked() {
    
  }

  Future<bool> setUserName(String newName) async {
    return true;
  }

  String getAccountId() {
    return "abcd1234@naver.com";
  }



}
