import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/widgets/app_normal_button.dart';
import 'package:duty_it/app/widgets/app_radio_buttom.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppSortingBottomModalContent<T> extends StatefulWidget {
  final T selectedType;
  final List<T> types;
  final String Function(T type) displayNameOf;
  final ValueChanged<T> onApply;

  const AppSortingBottomModalContent({
    super.key,
    required this.selectedType,
    required this.types,
    required this.displayNameOf,
    required this.onApply,
  });

  @override
  State<AppSortingBottomModalContent<T>> createState() =>
      _AppSortingBottomModalContentState<T>();
}

class _AppSortingBottomModalContentState<T>
    extends State<AppSortingBottomModalContent<T>> {
  late T _selectedType = widget.selectedType;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      minimum: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SortingHeader(onClose: () => Get.back()),
          ...widget.types.map(_buildOption),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 48,
              child: AppNormalButton(
                text: '정렬 적용',
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  widget.onApply(_selectedType);
                  Get.back();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(T type) {
    final isSelected = _selectedType == type;
    void select() {
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() => _selectedType = type);
      HapticFeedback.selectionClick();
    }

    return Semantics(
      label: widget.displayNameOf(type),
      checked: isSelected,
      inMutuallyExclusiveGroup: true,
      child: InkWell(
        onTap: select,
        child: ExcludeSemantics(
          child: SizedBox(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 7),
              child: Row(
                children: [
                  Text(
                    widget.displayNameOf(type),
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.20,
                    ),
                  ),
                  const Spacer(),
                  AppRadioButtom(
                    checked: isSelected,
                    tapSize: 40,
                    visualSize: 22,
                    selectedSize: 12,
                    onTap: select,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SortingHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _SortingHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        children: [
          const Positioned(
            top: 16,
            left: 0,
            right: 0,
            height: 40,
            child: Center(
              child: Text(
                '정렬',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.60,
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 8,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onClose,
              child: SizedBox(
                width: 40,
                height: 40,
                child: Image.asset(
                  Assets.icons.close.path,
                  color: AppColors.g05,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
