
import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/models/login_result.dart';
import 'package:duty_it/app/modules/login/services/auth_service.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class LoginViewController extends GetxController {
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
    try {
      var service = Get.find<AuthService>();
      var result = await service.login(SocialProvider.kakao);
      if (!result.success) {
        AppUtils.showSnackBar(result.reason);
      } else {
        var apiClient = Get.find<ApiClient>();
        RequestResult<LoginResult> rp = await apiClient.loginAndRefreshToken();
        if (rp is RequestSuccess) {
          Get.offAndToNamed(Routes.MAIN);
        } else {
          var fail = rp as RequestFail;
          AppUtils.showSnackBar(
            fail.serverFail?.message ?? "null",
          );
        }
      }
    } catch (e) {
      AppUtils.showSnackBar("로그인 중 오류가 발생하였습니다.");
      if (kDebugMode) AppUtils.showSnackBar("$e");
      rethrow;
    } finally {
      isLogining = false;
    }
  }
}
