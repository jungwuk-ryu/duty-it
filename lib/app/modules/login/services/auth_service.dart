import 'package:duty_it/app/modules/login/models/social_login_result.dart';
import 'package:duty_it/app/modules/login/strategies/kakao_login_strategy.dart';
import 'package:duty_it/app/modules/login/strategies/social_login_strategy.dart';
import 'package:get/get.dart';

enum SocialProvider { kakao }

class AuthService extends GetxService {
  final Map<SocialProvider, SocialLoginStrategy> _strategies = {};
  SocialLoginStrategy? _currentStrategy;

  @override
  void onInit() {
    super.onInit();
    _strategies[SocialProvider.kakao] = KakaoLoginStrategy();
  }

  Future<SocialLoginResult> login(SocialProvider provider) async {
    await logout();

    SocialLoginStrategy? strategy = _strategies[provider];
    if (strategy == null) {
      return SocialLoginResult(success: false, reason: "지원하지 않는 소셜 로그인입니다.");
    }

    var result = await strategy.login();
    if (result.success) _currentStrategy = strategy;

    return result;
  }

  Future<void> logout() async {
    await _currentStrategy?.logout();
    _currentStrategy = null;
  }
}