import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/widgets/adaptive_layout.dart';
import 'package:duty_it/app/widgets/app_normal_button.dart';
import 'package:flutter/material.dart';

/// Shared scrolling form and apply action, constrained to one usable pane.
class FilterPageScaffold extends StatelessWidget {
  const FilterPageScaffold({
    super.key,
    required this.header,
    required this.sections,
    required this.onApply,
  });

  final Widget header;
  final List<Widget> sections;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.colors.canvas,
    body: DisplayFeatureSubScreen(
      child: SafeArea(
        child: AdaptiveContent(
          maxWidth: 720,
          avoidFold:
              false, // DisplayFeatureSubScreen has already selected a pane.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              header,
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: sections.length,
                  itemBuilder: (_, index) => sections[index],
                  separatorBuilder: (_, _) => const SizedBox(height: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: AppNormalButton(text: '필터 적용', onTap: onApply),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
