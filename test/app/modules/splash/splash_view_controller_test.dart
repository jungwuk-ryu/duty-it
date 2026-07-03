import 'package:duty_it/app/modules/splash/controllers/splash_view_controller.dart';
import 'package:duty_it/app/services/job_filter/job_filter_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'startup initializes job filter storage before main binding reads it',
    () {
      expect(
        SplashViewController.storageBoxNames,
        contains(JobFilterService.storageBoxName),
      );
    },
  );
}
