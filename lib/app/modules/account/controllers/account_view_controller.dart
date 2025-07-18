import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:duty_it/app/modules/account/widgets/account_bottom_modal.dart';

class AccountViewController extends GetxController {
  String _userName = "수줍은 복숭아";

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
    return _userName;
  }

  void onUserNameEditButtonClicked() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => AccountBottomModal(),
    );
  }

  Future<bool> setUserName(String newName) async {
    _userName = newName;

    return true;
  }

  String getAccountId() {
    return "abcd1234@naver.com";
  }
}
