import 'package:flutter/material.dart';

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
