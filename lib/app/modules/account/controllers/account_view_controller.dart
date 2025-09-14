import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/modules/account/widgets/account_bottom_modal.dart';
import 'package:duty_it/app/modules/account/widgets/account_dialog.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AccountViewController extends GetxController {
  AuthService get _authService => Get.find<AuthService>();
  String get providerName => _authService.getLastUsedProvider().displayName;

  @override
  void onInit() {
    super.onInit();

    fetchUser();
  }

  Future<void> fetchUser() async {
    await Get.find<ApiClient>().getCurrentUser();
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
    var result = await Get.find<ApiClient>().updateCurrentUserNickname(
      newName.trim(),
    );
    return result is RequestSuccess;
  }

  Future<bool> isNicknameAvailable(String nickname) async {
    return await Get.find<ApiClient>().isNicknameAvailable(nickname)
        is RequestSuccess;
  }

  String getAccountId() {
    return _authService.appUser?.email ?? '불러오지 못했어요 :(';
  }

  Future<void> logout() async {
    Get.dialog(
      AccountDialog(
        title: '로그아웃',
        content: '로그아웃 하시겠습니까?',
        actionText: '로그아웃',
        action: () async {
          Get.back();
          await _authService.logout();
          Get.offAndToNamed(Routes.LOGIN);
        },
      ),
    );
  }

  Future<void> withdraw() async {
    Get.dialog(
      AccountDialog(
        title: '회원 탈퇴',
        content: '탈퇴 하시겠습니까?\n이 작업은 복구할 수 없습니다.',
        actionText: '탈퇴',
        action: () async {
          if (await _authService.withdraw()) {
            Get.offAndToNamed(Routes.LOGIN);
          }
        },
      ),
    );
  }
}
