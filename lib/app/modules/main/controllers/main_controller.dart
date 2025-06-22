import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

class MainController extends GetxController {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  get scaffoldKey => _scaffoldKey;

  void openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void closeEndDrawer() {
    _scaffoldKey.currentState!.closeEndDrawer();
  }

  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void onAccountSettingButtonClicked() {
    Get.toNamed(Routes.ACCOUNT);
  }
}
