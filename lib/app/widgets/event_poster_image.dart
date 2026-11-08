import 'package:cached_network_image/cached_network_image.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';

/// The same poster crop and cached image on a card, in flight, and in detail.
class EventPosterImage extends StatelessWidget {
  const EventPosterImage({super.key, required this.imageUrl, this.heroTag});

  final String imageUrl;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final hasImage = AppUtils.isHttpUrl(imageUrl);
    final placeholder = ColoredBox(
      color: context.colors.mutedSurface,
      child: Center(
        child: Image.asset(Assets.icons.nurseCap.path, width: 42, height: 42),
      ),
    );
    final poster = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: hasImage
          ? Image(
              image: CachedNetworkImageProvider(imageUrl),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              frameBuilder: (_, image, frame, _) =>
                  frame == null ? placeholder : image,
              errorBuilder: (_, _, _) => placeholder,
            )
          : placeholder,
    );
    if (!hasImage ||
        heroTag == null ||
        DuoMotion.durationOf(context) == Duration.zero) {
      return poster;
    }
    return Hero(
      tag: heroTag!,
      curve: Curves.easeOutCubic,
      transitionOnUserGestures: true,
      createRectTween: (begin, end) => RectTween(begin: begin, end: end),
      child: poster,
    );
  }
}
