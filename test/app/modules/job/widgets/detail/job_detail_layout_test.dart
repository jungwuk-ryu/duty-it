import 'package:cached_network_image/cached_network_image.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/enums/job_source_type.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/modules/job/widgets/detail/job_detail_footer.dart';
import 'package:duty_it/app/modules/job/widgets/detail/job_detail_media.dart';
import 'package:duty_it/app/modules/job/widgets/detail/job_detail_summary_card.dart';
import 'package:duty_it/app/modules/job/widgets/detail/job_detail_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('tab header uses the Figma visual height', () {
    final delegate = JobDetailTabHeaderDelegate(
      selectedIndex: 0,
      onTap: (_) {},
    );

    expect(delegate.minExtent, 40);
    expect(delegate.maxExtent, 40);
  });

  testWidgets('media image fills the detail page width on a 392px viewport', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 392,
            child: JobDetailMedia(imageUrl: 'https://example.com/poster.png'),
          ),
        ),
      ),
    );

    final mediaImage = find.byType(CachedNetworkImage);

    expect(tester.getSize(mediaImage).width, 392);
    expect(tester.getSize(mediaImage).height, closeTo(483, 0.01));
  });

  testWidgets('media image preserves the Figma aspect ratio on other widths', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 360,
            child: JobDetailMedia(imageUrl: 'https://example.com/poster.png'),
          ),
        ),
      ),
    );

    final mediaImage = find.byType(CachedNetworkImage);

    expect(tester.getSize(mediaImage).width, 360);
    expect(tester.getSize(mediaImage).height, closeTo(443.57, 0.01));
  });

  testWidgets('tab bar fills the detail page width', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 392,
            child: JobDetailTabBar(selectedIndex: 0, onTap: (_) {}),
          ),
        ),
      ),
    );

    final borderBox = find
        .descendant(
          of: find.byType(JobDetailTabBar),
          matching: find.byType(DecoratedBox),
        )
        .first;

    expect(tester.getSize(borderBox).width, 392);
  });

  testWidgets('footer background fills the detail page width', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 392,
            child: JobDetailFooter(sourceType: JobSourceType.work24),
          ),
        ),
      ),
    );

    final footerBackground = find.byWidgetPredicate(
      (widget) => widget is Container && widget.color == AppColors.g01,
    );

    expect(tester.getSize(footerBackground).width, 392);
  });

  testWidgets(
    'summary card keeps short label spacing without long label wrap',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 328,
              child: JobDetailSummaryCard(
                job: JobPosting(
                  id: 1,
                  careerDescription: '신입',
                  educationName: '학력무관',
                  salaryDescription: '월급 230만원',
                  location: '서울특별시 강남구',
                  employmentName: '기간의 정함이 없는 근로계약',
                ),
              ),
            ),
          ),
        ),
      );

      final shortLabelLeft = tester.getTopLeft(find.text('경력')).dx;
      final shortValueLeft = tester.getTopLeft(find.text('신입')).dx;
      expect(shortValueLeft - shortLabelLeft, 42);

      final employmentLabels = find.text('고용형태');
      expect(employmentLabels, findsNWidgets(2));
      expect(
        tester.getSize(employmentLabels.last).height,
        lessThanOrEqualTo(23),
      );
    },
  );
}
