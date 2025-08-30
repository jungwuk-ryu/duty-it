import 'package:duty_it/app/services/auth/models/social_login_result.dart';
import 'package:duty_it/app/services/auth/strategies/kakao_login_strategy.dart';
import 'package:duty_it/app/services/auth/strategies/social_login_strategy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

enum SocialProvider { kakao }

class AuthService extends GetxService {
  final Map<SocialProvider, SocialLoginStrategy> _strategies = {};

  SocialLoginStrategy? _currentStrategy;

  @override
  void onInit() {
    super.onInit();
    _initStrategies();
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
    _currentStrategy = null;
  }

  bool isLoggined() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}