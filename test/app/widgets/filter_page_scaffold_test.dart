import 'dart:ui' show DisplayFeature, DisplayFeatureType, DisplayFeatureState;

import 'package:duty_it/app/widgets/app_normal_button.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:duty_it/app/widgets/filter_page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final direction in TextDirection.values) {
    testWidgets('filter uses the selected asymmetric fold pane in $direction', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      const hinge = Rect.fromLTWH(350, 0, 24, 600);
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQueryData(
              size: const Size(1200, 600),
              displayFeatures: const [
                DisplayFeature(
                  bounds: hinge,
                  type: DisplayFeatureType.hinge,
                  state: DisplayFeatureState.postureHalfOpened,
                ),
              ],
            ),
            child: Directionality(
              textDirection: direction,
              child: const DuoLayoutScope(
                data: DuoLayoutData(isDuo: true, divisions: [hinge]),
                child: _Form(),
              ),
            ),
          ),
          home: const SizedBox(),
        ),
      );
      await tester.pumpAndSettle();
      final apply = tester.getRect(find.byType(AppNormalButton));
      if (direction == TextDirection.rtl) {
        expect(apply.left, greaterThanOrEqualTo(hinge.right));
        expect(apply.width, 688); // 720dp reading width minus the form margins.
      } else {
        expect(apply.right, lessThanOrEqualTo(hinge.left));
        expect(apply.width, 318);
      }
      expect(tester.takeException(), isNull);
    });
  }
}

class _Form extends StatelessWidget {
  const _Form();
  @override
  Widget build(BuildContext context) => FilterPageScaffold(
    header: const SizedBox(height: 64),
    sections: const [Text('카테고리'), Text('주최')],
    onApply: () {},
  );
}
