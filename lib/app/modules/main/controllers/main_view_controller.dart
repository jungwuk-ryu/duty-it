import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:duty_it/app/routes/app_pages.dart';

class MainViewController extends GetxController {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  get scaffoldKey => _scaffoldKey;

  void openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void closeEndDrawer() {
    _scaffoldKey.currentState!.closeEndDrawer();
  }

  RxInt currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void onAccountSettingButtonClicked() {
    Get.toNamed(Routes.ACCOUNT);
  }

  String getUserName() {
    return Get.find<AuthService>().appUser?.nickname ?? '';
  }
}
