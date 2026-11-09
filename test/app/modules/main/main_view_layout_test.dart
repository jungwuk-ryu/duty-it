import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/app/modules/job/controllers/job_view_controller.dart';
import 'package:duty_it/app/modules/main/controllers/main_view_controller.dart';
import 'package:duty_it/app/modules/main/views/main_view.dart';
import 'package:duty_it/app/modules/main/widgets/main_tab_bar.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

abstract class _ControllerStub extends GetxController {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

class _Main extends _ControllerStub implements MainViewController {
  @override
  final pageIndex = 0.obs;
  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  final pages = List<Widget>.generate(
    4,
    (i) => SizedBox.expand(key: ValueKey('page-$i')),
  );
  @override
  void changeTab(int index) => pageIndex.value = index;
  @override
  void openEndDrawer() => scaffoldKey.currentState!.openEndDrawer();
}

class _Home extends _ControllerStub implements HomeViewController {
  final _notification = false.obs;
  @override
  bool get hasNewNotification => _notification.value;
}

class _Job extends _ControllerStub implements JobViewController {
  final _notification = false.obs;
  @override
  bool get hasNewNotification => _notification.value;
}

class _Auth extends GetxService implements AuthService {
  @override
  bool isLoggined() => false;
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

bool scaffoldHasBottomBar(WidgetTester tester) =>
    tester.widget<Scaffold>(find.byType(Scaffold)).bottomNavigationBar != null;

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put<AuthService>(_Auth());
    Get.put<HomeViewController>(_Home());
    Get.put<JobViewController>(_Job());
  });
  tearDown(Get.reset);

  testWidgets(
    'resizing switches navigation without resetting the selected page',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1000, 700);
      addTearDown(tester.view.reset);
      final controller = Get.put<MainViewController>(_Main());
      await tester.pumpWidget(const MaterialApp(home: MainView()));
      controller.changeTab(1);
      await tester.pumpAndSettle();
      expect(
        tester.widget<MainTabBar>(find.byType(MainTabBar)).axis,
        Axis.vertical,
      );
      tester.view.physicalSize = const Size(392, 800);
      await tester.pumpAndSettle();
      expect(
        tester.widget<MainTabBar>(find.byType(MainTabBar)).axis,
        Axis.horizontal,
      );
      expect(controller.pageIndex.value, 1);
      expect(find.byKey(const ValueKey('page-1')), findsOneWidget);
      tester.view.physicalSize = const Size(1000, 700);
      await tester.pumpAndSettle();
      expect(
        tester.widget<MainTabBar>(find.byType(MainTabBar)).axis,
        Axis.vertical,
      );
      expect(controller.pageIndex.value, 1);
      expect(tester.takeException(), isNull);
    },
  );

  for (final (edge, width) in <(String?, double)>[
    ('left', 1000),
    ('right', 1000),
    (null, 1000),
    (null, 392),
  ]) {
    for (final keyboard in [false, true]) {
      testWidgets(
        'feeds reach the viewport edge with rail $edge, width $width and keyboard $keyboard',
        (tester) async {
          tester.view.physicalSize = Size(width, 700);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final controller = Get.put<MainViewController>(_Main());
          final effectiveEdge = edge ?? (width >= 600 ? 'left' : null);
          final railWidth = edge == null ? 80.0 : 72.0;
          final safe = EdgeInsets.fromLTRB(
            edge == 'left' ? 72 : 0,
            24,
            edge == 'right' ? 72 : 0,
            34,
          );
          await tester.pumpWidget(
            MaterialApp(
              home: MediaQuery(
                data: MediaQueryData(
                  size: Size(width, 700),
                  padding: keyboard ? safe.copyWith(bottom: 0) : safe,
                  viewPadding: safe,
                  viewInsets: EdgeInsets.only(bottom: keyboard ? 280 : 0),
                ),
                child: DuoLayoutScope(
                  data: DuoLayoutData(
                    isDuo: edge != null,
                    verticalBarEdge: edge,
                  ),
                  child: const MainView(),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final bottom = keyboard ? 420.0 : 700.0;
          for (final index in [0, 1]) {
            controller.pageIndex.value = index;
            await tester.pumpAndSettle();
            final feed = tester.getRect(find.byKey(ValueKey('page-$index')));
            expect(feed.bottom, bottom);
            expect(feed.top, 24);
            expect(feed.left, effectiveEdge == 'left' ? railWidth : 0);
            expect(
              feed.right,
              effectiveEdge == 'right' ? width - railWidth : width,
            );
            expect(
              tester.widget<MainTabBar>(find.byType(MainTabBar)).axis,
              effectiveEdge == null ? Axis.horizontal : Axis.vertical,
            );
            expect(scaffoldHasBottomBar(tester), effectiveEdge == null);
          }
          controller.pageIndex.value = 3;
          await tester.pumpAndSettle();
          final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
          // A phone calendar also avoids the full floating bottom bar. During
          // keyboard display only the body resizes; the bottom bar stays put.
          final calendarBottom = effectiveEdge == null && !keyboard
              ? tester
                    .getTopLeft(find.byWidget(scaffold.bottomNavigationBar!))
                    .dy
              : bottom - (keyboard ? 0 : 34);
          expect(
            tester.getBottomLeft(find.byKey(const ValueKey('page-3'))).dy,
            calendarBottom,
          );
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox());
        },
      );
    }
  }
}
