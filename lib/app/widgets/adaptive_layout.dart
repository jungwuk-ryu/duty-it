import 'package:flutter/widgets.dart';

class AdaptiveLayout extends StatelessWidget {
  final Widget phone;
  final Widget tablet;

  const AdaptiveLayout({super.key, required this.phone, required this.tablet});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        double width = constraints.maxWidth;

        if (width < 600) return phone;
        return tablet;
      },
    );
  }
}
