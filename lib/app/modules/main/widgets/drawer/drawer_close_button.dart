import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/main/controllers/main_controller.dart';
import 'package:myapp/gen/assets.gen.dart';

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
    Get.find<MainController>().closeEndDrawer();
  }
}
