import 'package:duty_it/app/modules/login/models/social_login_result.dart';

abstract class SocialLoginStrategy {
  Future<SocialLoginResult> login();
  Future<void> logout();
}