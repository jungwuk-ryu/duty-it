import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:duty_it/app/modules/main/controllers/main_view_controller.dart';
import 'package:duty_it/gen/assets.gen.dart';

class DrawerCloseButton extends StatelessWidget {
  const DrawerCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onClick,
      child: Image.asset(Assets.icons.close.path, width: 40.r, height: 40.r),
    );
  }

  void _onClick() {
    Get.find<MainViewController>().closeEndDrawer();
  }
}
