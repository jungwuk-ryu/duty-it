sealed class SocialLoginResult {}

class SocialLoginSuccess extends SocialLoginResult {}

class SocialLoginFail extends SocialLoginResult {
  final String reason;

  SocialLoginFail({required this.reason});
}