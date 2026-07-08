import 'dart:async';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/modules/bookmark/controllers/bookmark_view_controller.dart';
import 'package:duty_it/app/modules/bookmark/views/bookmark_view.dart';
import 'package:duty_it/app/modules/calendar/views/calendar_view.dart';
import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/app/modules/home/views/home_view.dart';
import 'package:duty_it/app/modules/job/controllers/job_view_controller.dart';
import 'package:duty_it/app/modules/job/views/job_view.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainViewController extends GetxController {
  RxInt pageIndex = 0.obs;
  late final List<Widget> pages;
  final pageNames = ['/home', '/job', '/bookmark', '/calendar'];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  get scaffoldKey => _scaffoldKey;
  StreamSubscription? _authListener;

  MainViewController() {
    pages = [
      HomeView(key: ValueKey('home')),
      JobView(key: ValueKey('job')),
      BookmarkView(key: ValueKey('bookmark')),
      CalendarView(key: ValueKey('calendar')),
    ];
  }

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
    if (index == 2 && !Get.find<AuthService>().isLoggined()) {
      Get.toNamed(Routes.LOGIN);
      return;
    }

    if (pageIndex.value == index) {
      var resetToPrimaryTab = false;
      if (index == 0 && Get.isRegistered<HomeViewController>()) {
        // Home
        var homeController = Get.find<HomeViewController>();
        if (homeController.selectedTab == HomeTab.bookmark) {
          homeController.selectedTab = HomeTab.event;
          resetToPrimaryTab = true;
        }
        homeController.scrollUpEventList();
      }
      if (index == 1 && Get.isRegistered<JobViewController>()) {
        final jobController = Get.find<JobViewController>();
        if (jobController.selectedTab == JobTab.bookmark) {
          jobController.selectedTab = JobTab.job;
          resetToPrimaryTab = true;
        }
        jobController.scrollUpJobList();
      }
      if (index == 2 && Get.isRegistered<BookmarkViewController>()) {
        Get.find<BookmarkViewController>().scrollUpBookmarkList();
      }
      if (resetToPrimaryTab) {
        FirebaseAnalytics.instance.logScreenView(screenName: pageNames[index]);
      }
      return;
    }

    if (index == 0 && Get.isRegistered<HomeViewController>()) {
      Get.find<HomeViewController>().selectedTab = HomeTab.event;
    }
    if (index == 1 && Get.isRegistered<JobViewController>()) {
      Get.find<JobViewController>().selectedTab = JobTab.job;
    }
    if (index == 2 && Get.isRegistered<BookmarkViewController>()) {
      Get.find<BookmarkViewController>().refreshCurrent();
    }

    pageIndex.value = index;

    FirebaseAnalytics.instance.logScreenView(screenName: pageNames[index]);
  }

  void onAccountSettingButtonClicked() {
    if (!Get.find<AuthService>().isLoggined()) {
      Get.toNamed(Routes.LOGIN);
    } else {
      Get.toNamed(Routes.ACCOUNT);
    }
    Get.find<MainViewController>().closeEndDrawer();
  }

  String getUserName() {
    String? username = Get.find<AuthService>().appUser?.nickname;
    if (!Get.find<AuthService>().isLoggined()) {
      return '로그인 해주세요';
    }
    return username ?? '';
  }
}
