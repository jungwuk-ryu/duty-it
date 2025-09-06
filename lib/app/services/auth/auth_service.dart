import 'dart:developer';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/models/app_user.dart';
import 'package:duty_it/app/services/auth/models/social_login_result.dart';
import 'package:duty_it/app/services/auth/strategies/apple_login_strategy.dart';
import 'package:duty_it/app/services/auth/strategies/google_login_strategy.dart';
import 'package:duty_it/app/services/auth/strategies/kakao_login_strategy.dart';
import 'package:duty_it/app/services/auth/strategies/social_login_strategy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum SocialProvider { kakao, google, apple }

class AuthService extends GetxService {
  static const String storageBoxName = "authService";
  static const String _appUserKey = 'app_user';

  final Map<SocialProvider, SocialLoginStrategy> _strategies = {};
  final Rxn<AppUser> _appUser = Rxn();
  late final GetStorage _box;

  AppUser? get appUser => _appUser.value;
  set appUser(AppUser? user) {
    _appUser.value = user;

    if (user != null) {
      _box.write(_appUserKey, user.toJson());
    } else {
      _box.remove(_appUserKey);
    }
  }

  SocialLoginStrategy? _currentStrategy;

  @override
  void onInit() {
    super.onInit();
    _initStrategies();

    _box = GetStorage(storageBoxName);
    _loadCachedAppUser();
  }

  void _loadCachedAppUser() {
    Map<String, dynamic>? jsonObj = _box.read(_appUserKey);
    if (jsonObj == null) return;

    try {
      _appUser.value = AppUser.fromJson(jsonObj);
    } catch (e, st) {
      if (kDebugMode) {
        log('Failed to load app user!', error: e, stackTrace: st);
      }
    }
  }

  void _initStrategies() {
    _strategies[SocialProvider.kakao] = KakaoLoginStrategy();
    _strategies[SocialProvider.google] = GoogleLoginStrategy();
    _strategies[SocialProvider.apple] = AppleLoginStrategy();
  }

  Future<SocialLoginResult> socialLogin(SocialProvider provider) async {
    await logout();

    SocialLoginStrategy? strategy = _strategies[provider];
    if (strategy == null) {
      return SocialLoginFail(reason: "지원하지 않는 소셜 로그인입니다.");
    }

    var result = await strategy.login();
    if (result is SocialLoginSuccess) _currentStrategy = strategy;

    return result;
  }

  Future<void> logout() async {
    await _currentStrategy?.logout();
    await FirebaseAuth.instance.signOut();
    await FirebaseAuth.instance.authStateChanges().firstWhere((u) => u == null);
    appUser = null;
    _currentStrategy = null;
  }

  Future<bool> withdraw() async {
    if (appUser == null) {
      AppUtils.showSnackBar('회원탈퇴 중 알 수 없는 오류가 발생했어요.');
      return false;
    }

    var reqResult = await Get.find<ApiClient>().withdrawUser(appUser!.id);
    if (reqResult is RequestFail) {
      AppUtils.showSnackBar('회원탈퇴 중 오류가 발생했어요.');
      if (reqResult.serverFail != null) AppUtils.showSnackBar(reqResult.serverFail!.message);
      return false;
    }

    await logout();
    return true;
  }

  bool isLoggined() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}
