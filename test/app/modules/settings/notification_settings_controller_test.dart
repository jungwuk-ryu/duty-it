import 'package:duty_it/app/modules/settings/controllers/notification_settings_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('marketing consent result notice includes sender, date and result', () {
    expect(
      NotificationSettingsController.marketingConsentResultMessage(
        true,
        DateTime(2026, 10, 15, 13, 30),
      ),
      '듀잇 광고성 정보 수신 동의가 2026년 10월 15일에 처리되었어요.',
    );
    expect(
      NotificationSettingsController.marketingConsentResultMessage(
        false,
        DateTime(2026, 3, 5),
      ),
      '듀잇 광고성 정보 수신 거부가 2026년 3월 5일에 처리되었어요.',
    );
  });
}
