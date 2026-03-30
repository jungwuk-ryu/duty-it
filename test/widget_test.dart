import 'package:duty_it/app/modules/calendar/widgets/custom_calendar_header_section.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

void main() {
  testWidgets('calendar header renders all weekday labels', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: CustomCalendarHeaderSection(),
      ),
    );

    for (final label in const ['일', '월', '화', '수', '목', '금', '토']) {
      expect(find.text(label), findsOneWidget);
    }
  });
}
