import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/main/controllers/main_view_controller.dart';
import 'package:myapp/gen/assets.gen.dart';

class DrawerAccountButton extends StatelessWidget {
  const DrawerAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onClick,
      child: Image.asset(
        Assets.icons.backFilled.path,
        width: 40.r,
        height: 40.r,
      ),
    );
  }

  void _onClick() {
    Get.find<MainViewController>().onAccountSettingButtonClicked();
  }
}
