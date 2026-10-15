class AppLegal {
  AppLegal._();

  static const String termsUrl = 'https://www.dutyit.net/terms';
  static const String privacyPolicyUrl = 'https://www.dutyit.net/privacy';
  static const String reportUrl = 'https://www.dutyit.net/report';

  /// 로그인 시 서버에 기록되는 이용약관 버전. 웹/서버와 같은 값을 유지해야 한다.
  static const String termsVersion = '2026-10-15';

  /// 직업안정법 시행령 제28조 제5호에 따른 신고번호 표시 문구
  static const String jobInfoRegistration =
      '직업정보제공사업 신고번호: J1205020260001 (서울북부 제2026-1호)';

  static const String wageDefaulterListUrl =
      'https://www.moel.go.kr/info/defaulter/defaulterList.do';
}
