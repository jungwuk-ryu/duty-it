import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:duty_it/app/modules/main/controllers/main_view_controller.dart';
import 'package:duty_it/gen/assets.gen.dart';

class DrawerAccountButton extends StatelessWidget {
  const DrawerAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onClick,
      child: Image.asset(Assets.icons.backRight.path, width: 40, height: 40),
    );
  }

  void _onClick() {
    Get.find<MainViewController>().onAccountSettingButtonClicked();
  }
}
