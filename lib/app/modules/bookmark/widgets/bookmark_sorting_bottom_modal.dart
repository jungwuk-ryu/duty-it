import 'package:duty_it/app/core/enums/event_sorting_type.dart';
import 'package:duty_it/app/core/enums/job_sorting_type.dart';
import 'package:duty_it/app/modules/bookmark/controllers/bookmark_view_controller.dart';
import 'package:duty_it/app/widgets/app_sorting_bottom_modal_content.dart';
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
    return AppSortingBottomModalContent<T>(
      selectedType: selectedType,
      types: types,
      displayNameOf: displayNameOf,
      onApply: onSelect,
    );
  }
}
