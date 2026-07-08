import 'package:cached_network_image/cached_network_image.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class JobDetailMedia extends StatelessWidget {
  final String? imageUrl;

  const JobDetailMedia({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url == null || !_looksLikeImageUrl(url)) {
      return const SizedBox.shrink();
    }

    return CachedNetworkImage(
      imageUrl: url,
      width: double.infinity,
      height: 300,
      fit: BoxFit.cover,
      placeholder: (_, _) => const _JobDetailMediaPlaceholder(),
      errorWidget: (_, _, _) => const _JobDetailMediaPlaceholder(),
    );
  }

  bool _looksLikeImageUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return false;
    final path = uri.path.toLowerCase();
    return path.endsWith('.png') ||
        path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.webp') ||
        path.endsWith('.gif');
  }
}

class _JobDetailMediaPlaceholder extends StatelessWidget {
  const _JobDetailMediaPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      color: AppColors.g03,
      alignment: Alignment.center,
      child: const Text(
        'IMG',
        style: TextStyle(
          color: AppColors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.20,
        ),
      ),
    );
  }
}
