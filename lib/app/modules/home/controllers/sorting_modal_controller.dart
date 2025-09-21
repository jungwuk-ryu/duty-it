import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:get/get.dart';

class SortingModalController extends GetxController {
  final AppSettingsService _settingsService = Get.find<AppSettingsService>();
  
  final Rx<EventSortingType> _selectedType = Get.find<AppSettingsService>().eventSortingType.obs;
  EventSortingType get selectedType => _selectedType.value;
  set selectedType(EventSortingType t) => _selectedType(t);

  void applyAndClose() {
    _settingsService.eventSortingType = selectedType;
    Get.back();
  }
}