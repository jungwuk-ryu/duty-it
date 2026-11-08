import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/core/theme/app_theme.dart';
import 'package:duty_it/app/modules/job/controllers/job_detail_view_controller.dart';
import 'package:duty_it/app/modules/job/views/job_detail_view.dart';
import 'package:duty_it/app/modules/job/widgets/detail/job_actions_menu.dart';
import 'package:duty_it/app/widgets/duit_glass.dart';
import 'package:duty_it/app/widgets/duit_top_app_bar.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _DetailController extends JobDetailViewController {
  _DetailController(JobPosting job) {
    jobRx = job.obs;
  }

  @override
  // The fixture supplies jobRx without production navigation or Firebase.
  // ignore: must_call_super
  void onInit() {}
}

void main() {
  setUp(() {
    Get.reset();
    Get.testMode = true;
  });
  tearDown(Get.reset);

  const job = JobPosting(
    id: 7,
    title: '서울대학교병원 간호직 공개 채용 공고 및 지원 자격 안내',
    companyName: '서울대학교병원',
    postingUrl: 'https://example.com/jobs/7',
  );

  for (final edge in [null, 'left', 'right']) {
    for (final dark in [false, true]) {
      testWidgets('job detail glass header (edge $edge, dark $dark)', (
        tester,
      ) async {
        final duo = edge != null;
        tester.view.physicalSize = duo
            ? const Size(1000, 700)
            : const Size(402, 874);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final controller = Get.put<JobDetailViewController>(
          _DetailController(job),
        );
        final layout = DuoLayoutData(
          isDuo: duo,
          verticalBarEdge: edge,
          layoutMargins: duo
              ? const EdgeInsets.fromLTRB(20, 0, 20, 34)
              : EdgeInsets.zero,
          divisions: duo ? const [Rect.fromLTWH(480, 0, 24, 700)] : const [],
          obstructions: duo
              ? [Rect.fromLTWH(edge == 'left' ? 0 : 928, 0, 72, 152)]
              : const [],
        );
        await tester.pumpWidget(
          GetMaterialApp(
            theme: dark ? AppTheme.dark : AppTheme.light,
            builder: (context, child) {
              final media = MediaQuery.of(context).copyWith(
                padding: EdgeInsets.fromLTRB(
                  edge == 'left' ? 72 : 0,
                  duo ? 0 : 62,
                  edge == 'right' ? 72 : 0,
                  34,
                ),
                viewPadding: EdgeInsets.fromLTRB(
                  edge == 'left' ? 72 : 0,
                  duo ? 0 : 62,
                  edge == 'right' ? 72 : 0,
                  34,
                ),
              );
              return MediaQuery(
                data: media.copyWith(padding: layout.foregroundPadding(media)),
                child: DuoLayoutScope(data: layout, child: child!),
              );
            },
            home: const JobDetailView(),
          ),
        );
        await tester.pumpAndSettle();

        final title = find.descendant(
          of: find.byType(AppBar),
          matching: find.text(job.title),
        );
        expect(title, findsOneWidget);
        expect(tester.getSize(title).height, lessThan(30));
        expect(tester.widget<AppBar>(find.byType(AppBar)).centerTitle, isTrue);
        final trigger = find.byTooltip('채용 더보기');
        final chrome = find.ancestor(
          of: trigger,
          matching: find.byType(DuitAppBarActions),
        );
        expect(tester.getSize(chrome), const Size.square(48));
        expect(find.byTooltip('뒤로 가기'), findsOneWidget);
        if (duo) {
          expect(tester.getRect(trigger).top, greaterThanOrEqualTo(152));
          expect(
            tester.getRect(find.byType(CustomScrollView)).right,
            lessThanOrEqualTo(edge == 'right' ? 928 : 1000),
          );
        }

        await tester.tap(trigger);
        await tester.pumpAndSettle();
        final panel = tester.getRect(
          find
              .ancestor(
                of: find.widgetWithText(MenuItemButton, '공유'),
                matching: find.byType(DuitGlass),
              )
              .first,
        );
        final button = tester.getRect(trigger);
        if (duo) {
          expect(panel.top, closeTo(button.top, 1));
          expect(panel.left, greaterThanOrEqualTo(edge == 'left' ? 88 : 520));
          expect(panel.right, lessThanOrEqualTo(edge == 'left' ? 464 : 912));
        } else {
          expect(panel.top, greaterThanOrEqualTo(button.bottom));
        }
        expect(find.text('링크 복사').hitTestable(), findsOneWidget);
        expect(find.text('공유').hitTestable(), findsOneWidget);
        expect(find.text('북마크').hitTestable(), findsOneWidget);
        // Refreshing details updates both the body and the centered title.
        controller.jobRx.value = job.copyWith(title: '변경된 채용 제목');
        await tester.pumpAndSettle();
        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text('변경된 채용 제목'),
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('job menu copies the posting link and delegates bookmarking', (
    tester,
  ) async {
    String? copied;
    var bookmarks = 0;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            actions: [
              JobActionsMenu(job: job, onBookmarkTap: () async => bookmarks++),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.byTooltip('채용 더보기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('링크 복사'));
    await tester.pumpAndSettle();
    expect(copied, job.postingUrl);
    await tester.tap(find.byTooltip('채용 더보기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('북마크'));
    await tester.pumpAndSettle();
    expect(bookmarks, 1);
  });

  testWidgets('job menu disables copying and sharing invalid posting URLs', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            actions: [
              JobActionsMenu(
                job: job.copyWith(postingUrl: 'javascript:alert(1)'),
                onBookmarkTap: () async {},
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.byTooltip('채용 더보기'));
    await tester.pumpAndSettle();
    for (final label in ['링크 복사', '공유']) {
      expect(
        tester
            .widget<MenuItemButton>(find.widgetWithText(MenuItemButton, label))
            .onPressed,
        isNull,
      );
    }
  });

  for (final label in ['링크 복사', '공유', '북마크']) {
    testWidgets('queued $label action is ignored after leaving details', (
      tester,
    ) async {
      var bookmarks = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              actions: [
                JobActionsMenu(
                  job: job,
                  onBookmarkTap: () async => bookmarks++,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.byTooltip('채용 더보기'));
      await tester.pumpAndSettle();
      // MenuItemButton dispatches selection after closing the overlay.
      await tester.tap(find.widgetWithText(MenuItemButton, label));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      expect(bookmarks, 0);
      expect(tester.takeException(), isNull);
    });
  }
}
