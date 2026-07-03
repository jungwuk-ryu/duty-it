import 'package:get/get.dart';

import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/job/bindings/job_detail_binding.dart';
import '../modules/job/bindings/job_filter_binding.dart';
import '../modules/job/views/job_detail_view.dart';
import '../modules/job/views/job_filter_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/search_filter/bindings/search_filter_binding.dart';
import '../modules/search_filter/views/search_filter_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/bindings/notification_filter_binding.dart';
import '../modules/settings/bindings/notification_settings_binding.dart';
import '../modules/settings/views/notification_filter_view.dart';
import '../modules/settings/views/notification_settings_view.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => MainView(),
      binding: MainBinding(),
      children: [
        GetPage(
          name: _Paths.ACCOUNT,
          page: () => const AccountView(),
          binding: AccountBinding(),
        ),
        GetPage(
          name: _Paths.SEARCH_FILTER,
          page: () => const SearchFilterView(),
          binding: SearchFilterBinding(),
        ),
        GetPage(
          name: _Paths.JOB_FILTER,
          page: () => const JobFilterView(),
          binding: JobFilterBinding(),
        ),
        GetPage(
          name: _Paths.JOB_DETAIL,
          page: () => const JobDetailView(),
          binding: JobDetailBinding(),
        ),
        GetPage(
          name: _Paths.SETTINGS,
          page: () => const SettingsView(),
          binding: SettingsBinding(),
        ),
        GetPage(
          name: _Paths.NOTIFICATION_SETTINGS,
          page: () => const NotificationSettingsView(),
          binding: NotificationSettingsBinding(),
        ),
        GetPage(
          name: _Paths.NOTIFICATION_FILTER,
          page: () => const NotificationFilterView(),
          binding: NotificationFilterBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
  ];
}
