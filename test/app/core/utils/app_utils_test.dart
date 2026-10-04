import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('event countdown changes at midnight in Korea', () {
    final eventDate = DateTime(2026, 9, 27);

    expect(
      AppUtils.daysUntilKstDate(
        eventDate,
        now: DateTime.utc(2026, 9, 26, 14, 59),
      ),
      1,
    );
    expect(
      AppUtils.daysUntilKstDate(eventDate, now: DateTime.utc(2026, 9, 26, 15)),
      0,
    );
  });

  test('image URLs require an HTTP host', () {
    expect(AppUtils.isHttpUrl(''), isFalse);
    expect(AppUtils.isHttpUrl('/uploads/poster.png'), isFalse);
    expect(
      AppUtils.isHttpUrl('https://api.dutyit.net/uploads/poster.png'),
      isTrue,
    );
  });
}
