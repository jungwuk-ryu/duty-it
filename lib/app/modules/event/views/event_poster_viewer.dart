import 'dart:ui' show DisplayFeature, DisplayFeatureState, DisplayFeatureType;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/widgets/duit_glass.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EventPosterViewer extends StatefulWidget {
  const EventPosterViewer({
    super.key,
    required this.image,
    required this.title,
    required this.host,
  });

  final ImageProvider image;
  final String title;
  final String host;

  static Future<void> show(
    BuildContext source, {
    required ImageProvider image,
    required String title,
    required String host,
  }) {
    final box = source.findRenderObject()! as RenderBox;
    final anchor = box.localToGlobal(box.size.center(Offset.zero));
    return showDialog<void>(
      context: source,
      anchorPoint: anchor,
      useSafeArea: false,
      fullscreenDialog: true,
      routeSettings: const RouteSettings(name: '/event/poster'),
      animationStyle: DuoMotion.durationOf(source) == Duration.zero
          ? AnimationStyle.noAnimation
          : null,
      builder: (context) {
        final viewer = LayoutBuilder(
          builder: (_, constraints) => EventPosterViewer(
            // Refit the poster when rotation or folding changes its viewport.
            key: ValueKey(constraints.biggest),
            image: image,
            title: title,
            host: host,
          ),
        );
        // UIKit reports Duo folds through the native layout bridge.
        final layout = DuoLayoutData.of(context);
        if (!layout.isDuo || layout.divisions.isEmpty) return viewer;
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            displayFeatures: [
              for (final fold in layout.divisions)
                DisplayFeature(
                  bounds: fold,
                  type: DisplayFeatureType.hinge,
                  state: DisplayFeatureState.postureHalfOpened,
                ),
            ],
          ),
          child: DisplayFeatureSubScreen(anchorPoint: anchor, child: viewer),
        );
      },
    );
  }

  @override
  State<EventPosterViewer> createState() => _EventPosterViewerState();
}

class _EventPosterViewerState extends State<EventPosterViewer>
    with SingleTickerProviderStateMixin {
  final _transform = TransformationController();
  final _viewport = GlobalKey();
  final _poster = GlobalKey();
  late final AnimationController _animation;
  late Matrix4Tween _zoomTween;
  Offset _tap = Offset.zero;
  int _attempt = 0;
  bool _retrying = false;

  @override
  void initState() {
    super.initState();
    _animation =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 220),
        )..addListener(() {
          _transform.value = _zoomTween.transform(
            Curves.easeOutCubic.transform(_animation.value),
          );
        });
  }

  bool get _zoomed => _transform.value.getMaxScaleOnAxis() > 1.01;

  void _toggleZoom(Offset focalPoint) {
    const scale = 2.5;
    final target = Matrix4.identity();
    if (!_zoomed) {
      final viewport =
          _viewport.currentContext!.findRenderObject()! as RenderBox;
      final poster = _poster.currentContext!.findRenderObject()! as RenderBox;
      final bounds = MatrixUtils.transformRect(
        poster.getTransformTo(viewport),
        Offset.zero & poster.size,
      );
      final focus = Offset(
        focalPoint.dx.clamp(bounds.left, bounds.right),
        focalPoint.dy.clamp(bounds.top, bounds.bottom),
      );
      target
        ..translateByDouble(
          (1 - scale) * focus.dx,
          (1 - scale) * focus.dy,
          0,
          1,
        )
        ..scaleByDouble(scale, scale, 1, 1);
    }
    _animation.stop();
    if (DuoMotion.durationOf(context) == Duration.zero) {
      _transform.value = target;
    } else {
      _zoomTween = Matrix4Tween(begin: _transform.value.clone(), end: target);
      _animation.forward(from: 0);
    }
  }

  Future<void> _retry() async {
    if (_retrying) return;
    setState(() => _retrying = true);
    final image = widget.image;
    final configuration = createLocalImageConfiguration(context);
    try {
      if (image is CachedNetworkImageProvider) {
        final cache =
            image.cacheManager ??
            CachedNetworkImageProvider.defaultCacheManager;
        await cache.removeFile(image.cacheKey ?? image.url);
      }
      await image.evict(configuration: configuration);
    } on Exception {
      // A temporarily unavailable cache must still allow another load attempt.
    } finally {
      if (mounted) {
        setState(() {
          _retrying = false;
          _attempt++;
        });
      }
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    _transform.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Material(
        color: AppColors.g01,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF8F8F7), Color(0xFFEFEEEC), Color(0xFFFAFAF9)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 6, 16, 4),
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: DuitGlass(
                      radius: 24,
                      showShadow: false,
                      child: IconButton(
                        tooltip: '닫기',
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 22,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Image(
                    key: ValueKey(_attempt),
                    image: widget.image,
                    fit: BoxFit.contain,
                    semanticLabel: '${widget.title} 포스터',
                    frameBuilder: (context, image, frame, loaded) {
                      if (!loaded && frame == null) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(
                            semanticsLabel: '포스터 불러오는 중',
                          ),
                        );
                      }
                      return LayoutBuilder(
                        builder: (_, constraints) =>
                            _gallery(image, constraints.maxHeight),
                      );
                    },
                    errorBuilder: (_, _, _) => Center(
                      child: SingleChildScrollView(
                        primary: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('포스터를 불러오지 못했어요.'),
                            TextButton(
                              onPressed: _retrying ? null : _retry,
                              child: const Text('다시 시도'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _gallery(Widget image, double availableHeight) => Column(
    children: [
      Expanded(
        child: GestureDetector(
          key: _viewport,
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
          onDoubleTapDown: (details) => _tap = details.localPosition,
          onDoubleTap: () => _toggleZoom(_tap),
          child: InteractiveViewer(
            transformationController: _transform,
            maxScale: 8,
            onInteractionStart: (_) => _animation.stop(),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: DecoratedBox(
                  key: _poster,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x260F1215),
                        blurRadius: 14,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: image,
                ),
              ),
            ),
          ),
        ),
      ),
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: availableHeight * .4),
        child: _caption(),
      ),
    ],
  );

  Widget _caption() => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 16, 12),
    child: Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            primary: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.host.trim().isNotEmpty)
                  Text(
                    widget.host,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.g06,
                    ),
                  ),
                Text(
                  widget.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        DuitGlass(
          radius: 24,
          showShadow: false,
          child: ValueListenableBuilder<Matrix4>(
            valueListenable: _transform,
            builder: (context, _, _) => IconButton(
              tooltip: _zoomed ? '전체 맞춤' : '포스터 확대',
              onPressed: () {
                final size = _viewport.currentContext?.size;
                if (size != null) _toggleZoom(size.center(Offset.zero));
              },
              icon: Icon(
                _zoomed ? Icons.zoom_out_rounded : Icons.zoom_in_rounded,
                size: 24,
                color: AppColors.black,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
