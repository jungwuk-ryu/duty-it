import 'package:cached_network_image/cached_network_image.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/models/host.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:flutter/material.dart';

class EventHostCard extends StatelessWidget {
  final Host host;
  final VoidCallback? onTap;

  const EventHostCard({super.key, required this.host, this.onTap});

  @override
  Widget build(BuildContext context) {
    final thumbnail = host.thumbnail.trim();
    const fallback = Icon(Icons.business_outlined, color: AppColors.g06);

    return Semantics(
      button: onTap != null,
      label: '${host.name}의 행사 목록 보기',
      onTap: onTap,
      excludeSemantics: true,
      child: Material(
        color: AppColors.canvas,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: AppUtils.isHttpUrl(thumbnail)
                      ? CachedNetworkImage(
                          imageUrl: thumbnail,
                          fit: BoxFit.contain,
                          placeholder: (_, __) => fallback,
                          errorWidget: (_, __, ___) => fallback,
                        )
                      : fallback,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        host.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (onTap != null) ...[
                        const SizedBox(height: 4),
                        const Text(
                          '주최의 행사 목록 보기',
                          style: TextStyle(fontSize: 12, color: AppColors.g05),
                        ),
                      ],
                    ],
                  ),
                ),
                if (onTap != null) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.g05),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
