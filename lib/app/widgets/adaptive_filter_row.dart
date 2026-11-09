import 'package:flutter/material.dart';
import 'package:duty_it/app/widgets/adaptive_layout.dart';

/// Keep the same search and filters together when the content pane is wide.
class AdaptiveSearchHeader extends StatelessWidget {
  const AdaptiveSearchHeader({
    super.key,
    required this.search,
    required this.filters,
  });

  final Widget search;
  final Widget filters;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) =>
        AdaptiveLayout.isWide(context, constraints.maxWidth)
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(flex: 3, child: search),
                const SizedBox(width: 24),
                Expanded(flex: 2, child: filters),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              search,
              const SizedBox(height: 18),
              filters,
              const SizedBox(height: 16),
            ],
          ),
  );
}

/// Reflows the existing filter controls when text scaling or a fold narrows them.
class AdaptiveFilterRow extends StatelessWidget {
  const AdaptiveFilterRow({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => OverflowBar(
    alignment: MainAxisAlignment.spaceBetween,
    overflowAlignment: OverflowBarAlignment.start,
    overflowSpacing: 8,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: children.sublist(0, children.length - 1),
      ),
      IntrinsicWidth(child: children.last),
    ],
  );
}
