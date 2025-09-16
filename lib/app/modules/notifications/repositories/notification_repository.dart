import 'package:get_storage/get_storage.dart';

class NotificationRepository {
  static const String _storageName = "notifications";
  late Future<GetStorage> _storage;

  NotificationRepository() {
    _storage = _initStorage();
  }

  Future<GetStorage> _initStorage() async {
    await GetStorage.init(_storageName);
    return GetStorage(_storageName);
  }

  Future<List> getNotificationList() async {
    var storage = await _storage;
  }
}
