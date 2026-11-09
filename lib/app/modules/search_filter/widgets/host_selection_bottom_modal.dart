import 'package:duty_it/app/modules/home/widgets/search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/enums/sort_direction.dart';
import 'package:duty_it/app/core/models/host.dart';
import 'package:duty_it/app/modules/search_filter/controllers/host_selection_controller.dart';
import 'package:duty_it/app/widgets/app_bottom_sheet_handle.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HostSelectionBottomModal extends StatefulWidget {
  final void Function(Host host)? onHostSelected;
  final bool Function(Host host)? isSelected;
  final SortDirection? sortDirection;
  final String? field;

  const HostSelectionBottomModal({
    super.key,
    this.onHostSelected,
    this.isSelected,
    this.sortDirection,
    this.field,
  });

  @override
  State<HostSelectionBottomModal> createState() =>
      _SearchFilterHostSelectionBottomModal();
}

class _SearchFilterHostSelectionBottomModal
    extends State<HostSelectionBottomModal> {
  late final HostSelectionController controller;
  late final TextEditingController editingController;
  late final String controllerTag;

  @override
  void initState() {
    super.initState();

    controllerTag = 'host-selection-${identityHashCode(this)}';
    controller = Get.put(
      HostSelectionController(
        onHostSelected: widget.onHostSelected,
        sortDirection: widget.sortDirection,
        field: widget.field,
      ),
      tag: controllerTag,
    );
    editingController = TextEditingController();
    editingController.addListener(() => _onTextChanged());
  }

  @override
  void dispose() {
    editingController.dispose();
    if (Get.isRegistered<HostSelectionController>(tag: controllerTag)) {
      Get.delete<HostSelectionController>(tag: controllerTag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      duration: Duration(milliseconds: 100),
      child: SizedBox(
        height: 625,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppBottomSheetHandle(),
              Text(
                "주최 선택",
                style: TextStyle(
                  height: 1.60,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: context.colors.text,
                ),
              ),
              SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: HomeSearchBar(
                  controller: editingController,
                  filled: true,
                  hintText: '찾으시는 주최기관을 검색해 보세요.',
                ),
              ),

              SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '검색 결과',
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.20,
                  ),
                ),
              ),

              SizedBox(height: 24),
              Expanded(
                child: Obx(() {
                  List<Host> hosts = controller.filteredHosts;

                  if (hosts.isEmpty) {
                    return Center(
                      child: Text(
                        '검색 결과가 존재하지 않습니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.colors.icon,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.60,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: hosts.length,
                    itemBuilder: (_, i) => _HostItem(
                      controller: controller,
                      host: hosts[i],
                      selected: widget.isSelected?.call(hosts[i]) ?? false,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTextChanged() {
    String txt = editingController.text;
    controller.query = txt;
  }
}

class _HostItem extends StatelessWidget {
  final HostSelectionController controller;
  final Host host;
  final bool selected;

  const _HostItem({
    required this.controller,
    required this.host,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final thumbnail = host.thumbnail.trim();

    return Padding(
      padding: EdgeInsets.only(bottom: 15, left: 1, top: 1),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => controller.onHostSelect(host),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: ShapeDecoration(
                color: context.colors.mutedSurface,
                shape: OvalBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: context.colors.border,
                  ),
                ),
              ),
              child: ClipOval(
                child: thumbnail.isEmpty
                    ? const _HostThumbnailFallback()
                    : CachedNetworkImage(
                        imageUrl: thumbnail,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        progressIndicatorBuilder: (_, __, ___) =>
                            const _HostThumbnailFallback(),
                        errorWidget: (_, __, ___) =>
                            const _HostThumbnailFallback(),
                      ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                host.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: context.colors.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.20,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check, color: context.colors.accent, size: 22),
          ],
        ),
      ),
    );
  }
}

class _HostThumbnailFallback extends StatelessWidget {
  const _HostThumbnailFallback();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.mutedSurface,
      child: Center(
        child: Image.asset(
          Assets.icons.logo.path,
          width: 20,
          height: 20,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
