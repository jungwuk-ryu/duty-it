import 'package:flutter/widgets.dart';

class TapScale extends StatefulWidget {
  final Widget child;

  const TapScale({super.key, required this.child});
  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) {
        setState(() {
          _scale = 0.98;
        });
      },

      onPointerUp: (_) {
        setState(() {
          _scale = 1.0;
        });
      },

      onPointerCancel: (_) {
        setState(() {
          _scale = 1.0;
        });
      },
      child: AnimatedScale(
        scale: _scale,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}
