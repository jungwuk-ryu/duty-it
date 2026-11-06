import 'package:duty_it/app/widgets/duit_glass.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

void main() {
  for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
    testWidgets('$platform opaque fallback preserves controls and semantics', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: platform),
          home: MediaQuery(
            data: const MediaQueryData(highContrast: true),
            child: DuoLayoutScope(
              data: const DuoLayoutData(reduceTransparency: true),
              child: Scaffold(
                body: DuitGlass(
                  child: TextButton(
                    onPressed: () => taps++,
                    child: const Text('메뉴'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(LiquidGlass), findsNothing);
      await tester.tap(find.text('메뉴'));
      expect(taps, 1);
      expect(tester.takeException(), isNull);
    });
  }
}
