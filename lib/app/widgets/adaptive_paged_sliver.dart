import 'dart:math' as math;

import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Changes only the arrangement; cards, paging and the visible item survive.
class AdaptivePagedSliver<PageKey, Item> extends StatefulWidget {
  const AdaptivePagedSliver({
    super.key,
    required this.state,
    required this.fetchNextPage,
    required this.builderDelegate,
    this.eventTiles = false,
  });

  final bool eventTiles;
  final PagingState<PageKey, Item> state;
  final NextPageCallback fetchNextPage;
  final PagedChildBuilderDelegate<Item> builderDelegate;

  @override
  State<AdaptivePagedSliver<PageKey, Item>> createState() =>
      _AdaptivePagedSliverState<PageKey, Item>();
}

class _AdaptivePagedSliverState<PageKey, Item>
    extends State<AdaptivePagedSliver<PageKey, Item>>
    with SingleTickerProviderStateMixin {
  late final _motion = AnimationController(
    vsync: this,
    duration: DuoMotion.duration,
    value: 1,
  );
  DuoGridGeometry? _startGrid;
  DuoGridGeometry? _endGrid;
  VoidCallback? _restoreMotionAnchor;

  DuoGridGeometry get _animatedGrid {
    final t = DuoMotion.curve.transform(_motion.value);
    return DuoGridGeometry(
      _endGrid!.columns,
      _startGrid!.spacing + (_endGrid!.spacing - _startGrid!.spacing) * t,
      EdgeInsets.lerp(_startGrid!.padding, _endGrid!.padding, t)!,
    );
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  final _itemKeys = <int, GlobalKey>{};
  (double, int, double, EdgeInsets)? _geometry;
  int _restoreGeneration = 0;

  double _visibleTop(RenderBox fallback) {
    var top = fallback.localToGlobal(Offset.zero).dy;
    final render = context.findRenderObject();
    final viewport = RenderAbstractViewport.maybeOf(render);
    if (render != null &&
        viewport is RenderViewportBase &&
        viewport.axisDirection == AxisDirection.down) {
      RenderObject sliver = render;
      while (sliver.parent != null && sliver.parent != viewport) {
        sliver = sliver.parent!;
      }
      if (sliver is RenderSliver && sliver.parent == viewport) {
        // Include the painted floating app bar as well as the pinned filters.
        // Cards hidden behind either control are not reading anchors.
        for (
          var header = viewport.firstChild;
          header != null && header != sliver;
          header = viewport.childAfter(header)
        ) {
          if (header.geometry?.visible != true) continue;
          final bounds = MatrixUtils.transformRect(
            header.getTransformTo(viewport),
            header.paintBounds,
          );
          top = math.max(top, viewport.localToGlobal(bounds.bottomLeft).dy);
        }
      }
    }
    return top;
  }

  /// During a same-column fold tween, keep one visible card at its original
  /// reading position. Stop correcting as soon as the user starts scrolling.
  VoidCallback? _captureMotionAnchor() {
    final scrollable = Scrollable.of(context);
    final position = scrollable.position;
    if (position.isScrollingNotifier.value) return null;
    final viewport = scrollable.context.findRenderObject() as RenderBox?;
    if (viewport == null || !viewport.hasSize) return null;
    final top = _visibleTop(viewport);
    final visible = _itemKeys.entries.where((entry) {
      final box = entry.value.currentContext?.findRenderObject() as RenderBox?;
      return box != null &&
          box.attached &&
          box.hasSize &&
          box.localToGlobal(Offset.zero).dy + box.size.height > top;
    }).toList()..sort((a, b) => a.key.compareTo(b.key));
    if (visible.isEmpty) return null;
    final anchor = visible.first;
    final items = widget.state.items;
    if (items == null || anchor.key >= items.length) return null;
    final item = items[anchor.key];
    final box = anchor.value.currentContext!.findRenderObject() as RenderBox;
    final relativeTop = viewport
        .globalToLocal(box.localToGlobal(Offset.zero))
        .dy;
    final generation = ++_restoreGeneration;
    return () {
      if (!mounted || generation != _restoreGeneration) return;
      if (position.isScrollingNotifier.value ||
          anchor.key >= (widget.state.items?.length ?? 0) ||
          widget.state.items![anchor.key] != item) {
        _restoreMotionAnchor = null;
        return;
      }
      final box = anchor.value.currentContext?.findRenderObject() as RenderBox?;
      if (box == null ||
          !box.attached ||
          !box.hasSize ||
          !position.hasContentDimensions) {
        return;
      }
      // Measure in viewport coordinates so pane scaling cannot shift the anchor.
      final delta =
          viewport.globalToLocal(box.localToGlobal(Offset.zero)).dy -
          relativeTop;
      if (delta.abs() > 0.1) {
        position.jumpTo(
          (position.pixels + delta).clamp(0.0, position.maxScrollExtent),
        );
      }
    };
  }

  void _preserveVisibleItem(int oldColumns, int newColumns) {
    final scrollable = Scrollable.of(context);
    if (scrollable.position.isScrollingNotifier.value) return;
    final viewport = scrollable.context.findRenderObject() as RenderBox?;
    if (viewport == null || !viewport.hasSize) return;
    final top = _visibleTop(viewport);
    final visible = _itemKeys.entries.where((entry) {
      final box = entry.value.currentContext?.findRenderObject() as RenderBox?;
      return box != null &&
          box.attached &&
          box.hasSize &&
          box.localToGlobal(Offset.zero).dy + box.size.height > top;
    }).toList()..sort((a, b) => a.key.compareTo(b.key));
    if (visible.isEmpty) return;
    final anchor = visible.first;
    final items = widget.state.items;
    if (items == null || anchor.key >= items.length) return;
    final anchorItem = items[anchor.key];
    final oldBox = anchor.value.currentContext!.findRenderObject() as RenderBox;
    final relativeTop = viewport
        .globalToLocal(oldBox.localToGlobal(Offset.zero))
        .dy;
    final oldPixels = scrollable.position.pixels;
    final generation = ++_restoreGeneration;

    void restore(int attempts) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted ||
            generation != _restoreGeneration ||
            scrollable.position.isScrollingNotifier.value ||
            anchor.key >= (widget.state.items?.length ?? 0) ||
            widget.state.items![anchor.key] != anchorItem) {
          return;
        }
        final position = scrollable.position;
        if (!position.hasPixels || !position.hasContentDimensions) return;
        final box =
            anchor.value.currentContext?.findRenderObject() as RenderBox?;
        if (box != null && box.attached && box.hasSize) {
          final delta =
              viewport.globalToLocal(box.localToGlobal(Offset.zero)).dy -
              relativeTop;
          position.jumpTo(
            (position.pixels + delta).clamp(0.0, position.maxScrollExtent),
          );
        } else if (attempts < 8) {
          final entries = _itemKeys.entries.where((entry) {
            final render =
                entry.value.currentContext?.findRenderObject() as RenderBox?;
            return render != null && render.attached && render.hasSize;
          }).toList()..sort((a, b) => a.key.compareTo(b.key));
          if (entries.isEmpty) return;
          final first = entries.first;
          final last = entries.last;
          final firstBox =
              first.value.currentContext!.findRenderObject() as RenderBox;
          final lastBox =
              last.value.currentContext!.findRenderObject() as RenderBox;
          final firstY = viewport
              .globalToLocal(firstBox.localToGlobal(Offset.zero))
              .dy;
          final rowDistance = last.key ~/ newColumns - first.key ~/ newColumns;
          final rowHeight = rowDistance > 0
              ? (viewport.globalToLocal(lastBox.localToGlobal(Offset.zero)).dy -
                        firstY) /
                    rowDistance
              : firstBox.size.height;
          final delta =
              (anchor.key ~/ newColumns - first.key ~/ newColumns) * rowHeight +
              firstY -
              relativeTop;
          position.jumpTo(
            (position.pixels + delta).clamp(0.0, position.maxScrollExtent),
          );
          restore(attempts + 1);
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          generation != _restoreGeneration ||
          scrollable.position.isScrollingNotifier.value ||
          anchor.key >= (widget.state.items?.length ?? 0) ||
          widget.state.items![anchor.key] != anchorItem) {
        return;
      }
      final position = scrollable.position;
      position.jumpTo(
        (oldPixels * oldColumns / newColumns).clamp(
          0.0,
          position.maxScrollExtent,
        ),
      );
      restore(0);
    });
  }

  @override
  Widget build(BuildContext context) => SliverLayoutBuilder(
    builder: (context, constraints) {
      final grid = DuoGridGeometry.forWidth(
        context,
        constraints.crossAxisExtent,
        eventTiles: widget.eventTiles,
      );
      final geometry = (
        constraints.crossAxisExtent,
        grid.columns,
        grid.spacing,
        grid.padding,
      );
      final duration = DuoMotion.durationOf(context);
      if (_geometry == null) {
        _startGrid = _endGrid = grid;
      } else if (_geometry != geometry) {
        ++_restoreGeneration;
        final sameColumns = _geometry!.$2 == grid.columns;
        final sameWidth = _geometry!.$1 == constraints.crossAxisExtent;
        if (sameColumns && sameWidth && duration != Duration.zero) {
          _restoreMotionAnchor = _captureMotionAnchor();
          _startGrid = _animatedGrid;
          _endGrid = grid;
          _motion.forward(from: 0);
        } else {
          _restoreMotionAnchor = null;
          _preserveVisibleItem(_geometry!.$2, grid.columns);
          _startGrid = _endGrid = grid;
          _motion.value = 1;
        }
      }
      if (duration == Duration.zero) _motion.value = 1;
      _geometry = geometry;
      final delegate = widget.builderDelegate;
      final count = widget.state.items?.length ?? 0;
      _itemKeys.removeWhere((index, _) => index >= count);
      return AnimatedBuilder(
        animation: _motion,
        builder: (context, _) {
          final grid = _animatedGrid;
          final restore = _restoreMotionAnchor;
          if (restore != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              restore();
              if (_motion.isCompleted &&
                  identical(restore, _restoreMotionAnchor)) {
                _restoreMotionAnchor = null;
              }
            });
          }
          return SliverPadding(
            padding: grid.padding,
            sliver: PagedSliverAlignedGrid<PageKey, Item>.count(
              state: widget.state,
              fetchNextPage: widget.fetchNextPage,
              builderDelegate: PagedChildBuilderDelegate<Item>(
                itemBuilder: (context, item, index) => KeyedSubtree(
                  key: _itemKeys.putIfAbsent(index, GlobalKey.new),
                  child: delegate.itemBuilder(context, item, index),
                ),
                firstPageErrorIndicatorBuilder:
                    delegate.firstPageErrorIndicatorBuilder,
                newPageErrorIndicatorBuilder:
                    delegate.newPageErrorIndicatorBuilder,
                firstPageProgressIndicatorBuilder:
                    delegate.firstPageProgressIndicatorBuilder,
                newPageProgressIndicatorBuilder:
                    delegate.newPageProgressIndicatorBuilder,
                noItemsFoundIndicatorBuilder:
                    delegate.noItemsFoundIndicatorBuilder,
                noMoreItemsIndicatorBuilder:
                    delegate.noMoreItemsIndicatorBuilder,
                animateTransitions: delegate.animateTransitions,
                transitionDuration: delegate.transitionDuration,
                invisibleItemsThreshold: delegate.invisibleItemsThreshold,
              ),
              mainAxisSpacing: widget.eventTiles ? 24 : 0,
              crossAxisCount: grid.columns,
              crossAxisSpacing: math.max(0, grid.spacing),
              showNewPageProgressIndicatorAsGridChild: false,
              showNewPageErrorIndicatorAsGridChild: false,
              showNoMoreItemsIndicatorAsGridChild: false,
            ),
          );
        },
      );
    },
  );
}
