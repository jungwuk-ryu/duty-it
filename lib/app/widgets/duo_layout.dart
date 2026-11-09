import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:duty_it/app/core/utils/app_orientation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Geometry supplied by UIKit, rather than assumptions about device dimensions.
class DuoLayoutData {
  const DuoLayoutData({
    this.isDuo = false,
    this.verticalBarEdge,
    this.divisions = const [],
    this.obstructions = const [],
    this.reduceTransparency = false,
    this.contentBounds = Rect.zero,
    this.layoutMargins = EdgeInsets.zero,
  });

  final bool isDuo;
  final String? verticalBarEdge;
  final List<Rect> divisions;
  final List<Rect> obstructions;
  final bool reduceTransparency;
  final Rect contentBounds;
  final EdgeInsets layoutMargins;

  DuoLayoutData withContentBounds(Rect bounds) => DuoLayoutData(
    isDuo: isDuo,
    verticalBarEdge: verticalBarEdge,
    divisions: divisions,
    obstructions: obstructions,
    reduceTransparency: reduceTransparency,
    contentBounds: bounds,
    layoutMargins: layoutMargins,
  );

  /// UIKit margins include safe areas and can differ on either side of Duo.
  /// Existing pages already inset content by 16pt and top controls by 8pt;
  /// reserve only the remainder so margins are never added twice.
  EdgeInsets foregroundPadding(MediaQueryData media) {
    if (!isDuo) return media.padding;
    final freeEdgeMargin = math.max(
      16.0,
      verticalBarEdge == 'left'
          ? layoutMargins.right - media.viewPadding.right
          : layoutMargins.left - media.viewPadding.left,
    );
    return media.padding.copyWith(
      left: math.max(
        math.max(media.padding.left, layoutMargins.left - 16),
        verticalBarEdge == 'left' ? sideBarWidth(media) : 0,
      ),
      right: math.max(
        math.max(media.padding.right, layoutMargins.right - 16),
        verticalBarEdge == 'right' ? sideBarWidth(media) : 0,
      ),
      // Match our top controls to the system margin on the unobstructed edge.
      top: math.max(
        media.padding.top,
        math.max(layoutMargins.top, freeEdgeMargin - 8),
      ),
    );
  }

  /// Material routes already avoid display features. Supply UIKit's active
  /// divisions too, so sheets and dialogs use the same panes as page content.
  List<ui.DisplayFeature> displayFeatures(MediaQueryData media) {
    if (!isDuo || divisions.isEmpty) return media.displayFeatures;
    return [
      ...media.displayFeatures,
      for (final division in divisions)
        if (!media.displayFeatures.any((feature) => feature.bounds == division))
          ui.DisplayFeature(
            bounds: division,
            type: ui.DisplayFeatureType.hinge,
            state: ui.DisplayFeatureState.postureHalfOpened,
          ),
    ];
  }

  double sideBarWidth(MediaQueryData media) => verticalBarEdge == null
      ? 0
      : math.max(
          72.0,
          verticalBarEdge == 'left'
              ? media.viewPadding.left
              : media.viewPadding.right,
        );

  /// Global y-coordinate below hardware and status UI along the side controls.
  double sideControlsTop(MediaQueryData media) {
    final width = sideBarWidth(media);
    final rail = Rect.fromLTWH(
      verticalBarEdge == 'left' ? 0 : media.size.width - width,
      0,
      width,
      media.size.height,
    );
    return obstructions
        .where((region) => region.overlaps(rail))
        .fold(
          media.padding.top,
          (double top, region) => math.max(top, region.bottom),
        );
  }

  Rect? get verticalFold {
    for (final region in divisions) {
      if (region.height > region.width &&
          region.left > contentBounds.left &&
          region.right < contentBounds.right) {
        return region;
      }
    }
    return null;
  }

  static DuoLayoutData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DuoLayoutScope>()?.data ??
      const DuoLayoutData();
}

class DuoLayoutScope extends InheritedWidget {
  const DuoLayoutScope({super.key, required this.data, required super.child});
  final DuoLayoutData data;

  @override
  bool updateShouldNotify(DuoLayoutScope oldWidget) => data != oldWidget.data;
}

/// Flutter does not currently expose iOS reserved regions in displayFeatures.
class DuoLayout extends StatefulWidget {
  const DuoLayout({super.key, required this.child});
  final Widget child;

  @override
  State<DuoLayout> createState() => _DuoLayoutState();
}

class _DuoLayoutState extends State<DuoLayout> with WidgetsBindingObserver {
  StreamSubscription<dynamic>? _subscription;
  DuoLayoutData _data = const DuoLayoutData();
  bool _allowsRotation = false;
  ui.FlutterView? _view;
  bool _androidHasFold = false;
  bool? _androidAllowsRotation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      _subscription = const EventChannel('com.dutyit.app/layout')
          .receiveBroadcastStream()
          .listen(
            (dynamic event) {
              if (!mounted || event is! Map) return;
              if (event['isDuo'] == true && !_allowsRotation) {
                _allowsRotation = true;
                SystemChrome.setPreferredOrientations(DeviceOrientation.values);
              }
              List<Rect> regions(String key) =>
                  (event[key] as List? ?? const [])
                      .cast<Map>()
                      .map(
                        (r) => Rect.fromLTWH(
                          (r['x'] as num).toDouble(),
                          (r['y'] as num).toDouble(),
                          (r['width'] as num).toDouble(),
                          (r['height'] as num).toDouble(),
                        ),
                      )
                      .toList(growable: false);
              final margins = event['layoutMargins'] as Map?;
              double margin(String edge) =>
                  (margins?[edge] as num?)?.toDouble() ?? 0;
              setState(() {
                _data = DuoLayoutData(
                  isDuo: event['isDuo'] == true,
                  verticalBarEdge: event['verticalBarEdge'] as String?,
                  divisions: regions('divisions'),
                  obstructions: regions('obstructions'),
                  reduceTransparency: event['reduceTransparency'] == true,
                  layoutMargins: EdgeInsets.fromLTRB(
                    margin('left'),
                    margin('top'),
                    margin('right'),
                    margin('bottom'),
                  ),
                );
              });
            },
            onError: (Object error) {
              // Older hosts and widget tests use the normal responsive layout.
            },
          );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _view = View.maybeOf(context);
    _androidHasFold = MediaQuery.displayFeaturesOf(context).any(
      (feature) =>
          feature.type == ui.DisplayFeatureType.fold ||
          feature.type == ui.DisplayFeatureType.hinge,
    );
    _updateAndroidOrientation();
  }

  @override
  void didChangeMetrics() => _updateAndroidOrientation();

  void _updateAndroidOrientation() {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    final view = _view;
    if (view == null) return;
    final allowsRotation = AppOrientation.allowsAndroidRotation(
      view,
      hasFold: _androidHasFold,
    );
    if (allowsRotation == _androidAllowsRotation) return;
    _androidAllowsRotation = allowsRotation;
    unawaited(
      SystemChrome.setPreferredOrientations(
        allowsRotation ? const [] : AppOrientation.portrait,
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final androidFolds = media.displayFeatures.where(
      (feature) =>
          feature.type == ui.DisplayFeatureType.hinge ||
          (feature.type == ui.DisplayFeatureType.fold &&
              feature.state == ui.DisplayFeatureState.postureHalfOpened),
    );
    final data = androidFolds.isEmpty
        ? _data
        : DuoLayoutData(
            divisions: androidFolds
                .map((f) => f.bounds)
                .toList(growable: false),
          );
    return MediaQuery(
      // Keep hardware viewPadding and the full-bleed canvas unchanged. Only
      // foreground SafeArea consumers receive the additional layout spacing.
      data: media.copyWith(
        padding: data.foregroundPadding(media),
        displayFeatures: data.displayFeatures(media),
      ),
      child: DuoLayoutScope(data: data, child: widget.child),
    );
  }
}

/// Keep the existing search/filter header within one usable side of a fold.
class FoldSafeHeader extends StatelessWidget {
  const FoldSafeHeader({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final layout = DuoLayoutData.of(context);
    final fold = layout.verticalFold;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = fold == null
            ? constraints.maxWidth
            : math.max(0.0, fold.left - layout.contentBounds.left - 32);
        return Align(
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            width: math.min(width, constraints.maxWidth),
            duration: DuoMotion.durationOf(context),
            curve: DuoMotion.curve,
            child: child,
          ),
        );
      },
    );
  }
}

/// Equal grid cells on each side of the physical fold, including asymmetric bars.
class DuoGridGeometry {
  const DuoGridGeometry(this.columns, this.spacing, this.padding);
  final int columns;
  final double spacing;
  final EdgeInsets padding;

  factory DuoGridGeometry.forWidth(
    BuildContext context,
    double width, {
    bool eventTiles = false,
  }) {
    final layout = DuoLayoutData.of(context);
    final fold = layout.verticalFold;
    // Respect text scaling instead of squeezing the existing cards.
    final scale = math.max(
      1.0,
      MediaQuery.textScalerOf(context).scale(14) / 14,
    );
    final minimumWidth = (eventTiles ? 140 : 280) * scale;
    int eventColumns(double available, double gap) {
      final preferred = (available / (220 * scale + gap)).ceil();
      final fitting = ((available + gap) / (minimumWidth + gap)).floor();
      return math.max(1, math.min(preferred, fitting));
    }

    if (fold == null) {
      return DuoGridGeometry(
        eventTiles
            ? eventColumns(width, 16)
            : (width >= minimumWidth * 2 + 16 ? 2 : 1),
        16,
        EdgeInsets.zero,
      );
    }
    final left = fold.left - layout.contentBounds.left - 16;
    final right = layout.contentBounds.right - 16 - fold.right;
    final cellWidth = math.min(left, right);
    if (cellWidth < minimumWidth) {
      // A narrow split window stays a readable single column on one side.
      final useLeft = left >= right;
      return DuoGridGeometry(
        1,
        16,
        EdgeInsets.only(
          left: useLeft ? 0 : fold.right - layout.contentBounds.left - 16,
          right: useLeft ? layout.contentBounds.right - fold.left - 16 : 0,
        ),
      );
    }
    final gap = eventTiles ? math.max(16.0, fold.width) : fold.width;
    // The central gutter straddles the hinge even when the status rail is asymmetric.
    final paneWidth = cellWidth - (gap - fold.width) / 2;
    final perPane = eventTiles ? eventColumns(paneWidth, gap) : 1;
    return DuoGridGeometry(
      2 * perPane,
      gap,
      EdgeInsets.only(left: left - cellWidth, right: right - cellWidth),
    );
  }
}

abstract final class DuoMotion {
  static const duration = Duration(milliseconds: 320);
  static const curve = Curves.easeInOutCubic;

  static Duration durationOf(BuildContext context) {
    final media = MediaQuery.of(context);
    return media.disableAnimations || media.accessibleNavigation
        ? Duration.zero
        : duration;
  }
}

/// One live subtree keeps focus, controllers and semantics through a fold.
/// A subtle settling motion also makes horizontal folds perceptible, where
/// the existing grid does not need to change its column geometry.
class DuoPostureTransition extends StatefulWidget {
  const DuoPostureTransition({super.key, required this.child});
  final Widget child;

  @override
  State<DuoPostureTransition> createState() => _DuoPostureTransitionState();
}

class _DuoPostureTransitionState extends State<DuoPostureTransition>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: DuoMotion.duration,
    value: 1,
  );
  late final _phase = _controller.drive(CurveTween(curve: Curves.easeOutCubic));
  int? _posture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final divisions = DuoLayoutData.of(context).divisions;
    final posture = divisions.isEmpty
        ? 0
        : divisions.first.height > divisions.first.width
        ? 1
        : 2;
    if (DuoMotion.durationOf(context) == Duration.zero) {
      _controller.value = 1;
    } else if (_posture != null && posture != _posture) {
      _controller.forward(
        from: _controller.isAnimating ? _controller.value : 0,
      );
    }
    _posture = posture;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _phase.drive(Tween(begin: 0.92, end: 1.0)),
    child: ScaleTransition(
      scale: _phase.drive(Tween(begin: 0.985, end: 1.0)),
      child: widget.child,
    ),
  );
}
