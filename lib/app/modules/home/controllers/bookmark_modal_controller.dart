import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:get/get.dart';

class BookmarkModalController extends GetxController {
  HomeViewController get hController => Get.find<HomeViewController>();

  final RxBool _dontShowAgain = RxBool(false);
  bool get dontShowAgain => _dontShowAgain.value;
  set dontShowAgain(bool v) => _dontShowAgain.value = v;

  final Rx<Event> eventRx;

  BookmarkModalController({required this.eventRx});

  void toggle() {
    dontShowAgain = !dontShowAgain;
  }

  Future<void> done(bool addToCal) async {
    var api = Get.find<ApiClient>();
    var user = Get.find<AuthService>().appUser!;

    if (user.autoAddBookmarkToCalendar != addToCal) {
      var result = await api.updateUserSettings(addToCal, user.alarmSettings);
      if (result is! RequestSuccess) {
        AppUtils.showSnackBar("설정을 업데이트하지 못했습니다.");
        return;
      }
    }

    var appSettings = Get.find<AppSettingsService>();
    appSettings.dontShowAutoAddModal.value = dontShowAgain;

    var event = eventRx.value;

    eventRx.value = event.copyWith(isBookmarked: !event.isBookmarked);
    eventRx.value = event.copyWith(
      isBookmarked: await hController.toggleBookmark(event),
    );

    Get.back();
  }
}
