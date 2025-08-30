import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/models/host.dart';
import 'package:duty_it/app/modules/search_filter/controllers/host_selection_controller.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HostSelectionBottomModal extends StatefulWidget {
  const HostSelectionBottomModal({super.key});

  @override
  State<HostSelectionBottomModal> createState() =>
      _SearchFilterHostSelectionBottomModal();
}

class _SearchFilterHostSelectionBottomModal
    extends State<HostSelectionBottomModal> {
  HostSelectionController controller = Get.put(HostSelectionController());
  late final TextEditingController editingController;

  @override
  void initState() {
    super.initState();

    editingController = TextEditingController();
    editingController.addListener(() => _onTextChanged());
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420.h,
      child: AnimatedPadding(
        padding: EdgeInsets.only(top: 16.w, bottom: 16.w + MediaQuery.of(context).viewInsets.bottom),
        duration: Duration(milliseconds: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.h),
            Text(
              "주최 선택",
              style: TextStyle(
                height: 1.60,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: 328.w,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.g02,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.icons.iconamoonSearch.path,
                    width: 12.r,
                    height: 12.r,
                  ),

                  SizedBox(width: 8.w),

                  Expanded(
                    child: Center(
                      child: TextField(
                        controller: editingController,
                        autofocus: true,
                        onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
                        textInputAction: TextInputAction.done,
                        textAlignVertical: TextAlignVertical.top,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: '찾으시는 주최기관을 검색해 보세요.',
                          hintStyle: const TextStyle(
                            color: AppColors.g05,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          isCollapsed: true,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),

                  if (editingController.text.isNotEmpty)
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          editingController.clear();
                        });
                      },
                      child: Image.asset(
                        Assets.icons.iconTextdelete16.path,
                        width: 16.r,
                        height: 16.r,
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 24.h),
            Text(
              '검색 결과',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.20,
              ),
            ),

            SizedBox(height: 24.h),
            Expanded(
              child: Obx(() {
                List<Host> hosts = controller.filteredHosts;

                if (hosts.isEmpty) {
                  return Center(
                    child: Text(
                      '검색 결과가 존재하지 않습니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.g06,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.60,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: hosts.length,
                  itemBuilder: (_, i) => _HostItem(host: hosts[i]),
                );
              }),
            ),
          ],
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
  HostSelectionController get controller => Get.find<HostSelectionController>();
  final Host host;

  const _HostItem({required this.host});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h, left: 1, top: 1),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => controller.onHostSelect(host),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: ShapeDecoration(
              color: const Color(0xFFF5F5F5),
              shape: OvalBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: const Color(0xFFD0D0D0),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            host.name,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.20,
            ),
          ),
        ],
      ),
      ),
    );
  }
}
