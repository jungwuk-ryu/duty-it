import 'package:duty_it/app/services/auth/models/social_login_result.dart';

abstract class SocialLoginStrategy {
  Future<SocialLoginResult> login();
  Future<void> logout();
}