import 'dart:convert';

import 'package:duty_it/app/models/app_user.dart';
import 'package:duty_it/app/services/auth/models/social_login_result.dart';
import 'package:duty_it/app/services/auth/strategies/kakao_login_strategy.dart';
import 'package:duty_it/app/services/auth/strategies/social_login_strategy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum SocialProvider { kakao }

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
    String? jsonStr = _box.read(_appUserKey);
    if (jsonStr == null) return;

    try {
      _appUser.value = AppUser.fromJson(json.decode(jsonStr));
    } catch (_) {}
  }

  void _initStrategies() {
    _strategies[SocialProvider.kakao] = KakaoLoginStrategy();
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
    appUser = null;
    _currentStrategy = null;
  }

  bool isLoggined() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}
