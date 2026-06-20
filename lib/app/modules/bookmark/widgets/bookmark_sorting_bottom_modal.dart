import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/enums/event_sorting_type.dart';
import 'package:duty_it/app/core/enums/job_sorting_type.dart';
import 'package:duty_it/app/modules/bookmark/controllers/bookmark_view_controller.dart';
import 'package:duty_it/app/widgets/app_bottom_sheet_handle.dart';
import 'package:duty_it/app/widgets/app_radio_buttom.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class BookmarkSortingBottomModal extends GetView<BookmarkViewController> {
  const BookmarkSortingBottomModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isEventTab) {
        return _SortingContent<EventSortingType>(
          selectedType: controller.eventSortingType,
          types: EventSortingType.values,
          displayNameOf: (type) => type.displayName,
          onSelect: (type) => controller.eventSortingType = type,
        );
      }

      return _SortingContent<JobSortingType>(
        selectedType: controller.jobSortingType,
        types: JobSortingType.values,
        displayNameOf: (type) => type.displayName,
        onSelect: (type) => controller.jobSortingType = type,
      );
    });
  }
}

class _SortingContent<T> extends StatelessWidget {
  final T selectedType;
  final List<T> types;
  final String Function(T type) displayNameOf;
  final ValueChanged<T> onSelect;

  const _SortingContent({
    required this.selectedType,
    required this.types,
    required this.displayNameOf,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppBottomSheetHandle(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '정렬',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...types.map(
            (type) => Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (_) {
                onSelect(type);
                HapticFeedback.selectionClick();
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Text(
                      displayNameOf(type),
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.20,
                      ),
                    ),
                    const Spacer(),
                    AppRadioButtom(checked: selectedType == type, onTap: () {}),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
