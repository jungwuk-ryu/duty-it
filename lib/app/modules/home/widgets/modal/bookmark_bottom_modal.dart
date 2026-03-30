import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/modules/home/controllers/bookmark_modal_controller.dart';
import 'package:duty_it/app/widgets/app_bottom_sheet_handle.dart';
import 'package:duty_it/app/widgets/app_normal_button.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookmarkBottomModal extends StatefulWidget {
  final Rx<Event> eventRx;

  const BookmarkBottomModal({super.key, required this.eventRx});

  @override
  State<BookmarkBottomModal> createState() => _BookmarkBottomModalState();
}

class _BookmarkBottomModalState extends State<BookmarkBottomModal> {
  BookmarkModalController get controller => Get.find<BookmarkModalController>();

  @override
  void initState() {
    Get.put<BookmarkModalController>(
      BookmarkModalController(eventRx: widget.eventRx),
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<BookmarkModalController>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppBottomSheetHandle(),
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  '캘린더 연동',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.60,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Get.back(),
                  child: Image.asset(
                    Assets.icons.close.path,
                    width: 14,
                    height: 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 47),
          Text(
            '이 행사를 캘린더에도 추가할까요?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.20,
            ),
          ),
          SizedBox(height: 28),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => controller.toggle(),
            child: Obx(() {
              bool dontShow = controller.dontShowAgain;
              Color color = dontShow ? AppColors.main : AppColors.g03;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.icons.check.path,
                    width: 20,
                    height: 20,
                    color: color,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '설정 기억하기',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.20,
                    ),
                  ),
                ],
              );
            }),
          ),

          SizedBox(height: 55),
          Row(
            children: [
              Flexible(
                child: AppNormalButton(
                  text: "아니요",
                  color: AppColors.g04,
                  onTap: () => controller.done(false),
                ),
              ),
              SizedBox(width: 16),
              Flexible(
                child: AppNormalButton(
                  text: "네, 추가할게요",
                  onTap: () => controller.done(true),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
