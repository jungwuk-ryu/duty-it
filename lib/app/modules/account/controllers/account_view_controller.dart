import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:duty_it/app/modules/account/widgets/account_bottom_modal.dart';

class AccountViewController extends GetxController {
  AuthService get _authService => Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();

    Get.find<ApiClient>().getCurrentUser();
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
    return _authService.appUser?.nickname ?? '불러오지 못했어요 :(';
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
    //_userName = newName;

    return true;
  }

  String getAccountId() {
    return _authService.appUser?.email ?? '불러오지 못했어요 :(';
  }
}
