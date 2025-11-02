import 'dart:async';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/modules/calendar/views/calendar_view.dart';
import 'package:duty_it/app/modules/home/views/home_view.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:duty_it/app/routes/app_pages.dart';

class MainViewController extends GetxController {
  RxInt pageIndex = 0.obs;
  final pages = [HomeView(), CalendarView()];
  final pageNames = ['/home', '/calendar'];
  
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  get scaffoldKey => _scaffoldKey;
  StreamSubscription? _authListener;

  @override
  void onInit() {
    super.onInit();

    var api = Get.find<ApiClient>();

    var authService = Get.find<AuthService>();
    if (authService.isLoggined()) {
      api.registerDevice().catchError((e, st) {
        FirebaseCrashlytics.instance.recordError(e, st, fatal: false);

        return RequestFail(null);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _authListener?.cancel();
  }

  void openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void closeEndDrawer() {
    _scaffoldKey.currentState!.closeEndDrawer();
  }

  void changeTab(int index) {
    pageIndex.value = index;

    FirebaseAnalytics.instance.logScreenView(screenName: pageNames[index]);
  }

  void onAccountSettingButtonClicked() {
    if (!Get.find<AuthService>().isLoggined()) {
      Get.toNamed(Routes.LOGIN);
    } else {
      Get.toNamed(Routes.ACCOUNT);
    }
  }

  String getUserName() {
    String? username = Get.find<AuthService>().appUser?.nickname;
    if (!Get.find<AuthService>().isLoggined()) {
      return '로그인 해주세요';
    }
    return username ?? '';
  }
}
