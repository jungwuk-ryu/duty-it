import 'package:flutter/material.dart';

/// All sheets keep their surface and contents clear of Duo's system rail.
Future<T?> showDuitBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  ShapeBorder? shape,
  bool useRootNavigator = false,
  bool? showDragHandle,
  Offset? anchorPoint,
}) {
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  final localizations = MaterialLocalizations.of(context);
  return navigator.push(
    _DuitBottomSheetRoute<T>(
      builder: builder,
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
      shape: shape,
      showDragHandle: showDragHandle,
      anchorPoint: anchorPoint,
      barrierLabel: localizations.scrimLabel,
      barrierOnTapHint: localizations.scrimOnTapHint(
        localizations.bottomSheetLabel,
      ),
      modalBarrierColor: Theme.of(context).bottomSheetTheme.modalBarrierColor,
    ),
  );
}

class _DuitBottomSheetRoute<T> extends ModalBottomSheetRoute<T> {
  _DuitBottomSheetRoute({
    required super.builder,
    required super.capturedThemes,
    super.shape,
    super.showDragHandle,
    super.anchorPoint,
    super.barrierLabel,
    super.barrierOnTapHint,
    super.modalBarrierColor,
  }) : super(isScrollControlled: true, useSafeArea: true);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // Select the pane before Material applies SafeArea. Otherwise its outer
    // SafeArea shrinks constraints while retaining full-screen MediaQuery.size,
    // subtracting a rail on the opposite pane from this sheet's width too.
    return DisplayFeatureSubScreen(
      anchorPoint: anchorPoint,
      child: Builder(
        builder: (paneContext) =>
            super.buildPage(paneContext, animation, secondaryAnimation),
      ),
    );
  }
}
