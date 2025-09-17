import 'package:duty_it/app/modules/notifications/models/fcm_notification.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:synchronized/synchronized.dart';

class NotificationRepository {
  static const String _storageName = "notifications";
  static const String _idListKey = "id_list";
  static const String _itemKeyPrefix = "noti_";
  static const int itemCountLimit = 100;

  late final Future<GetStorage> _storage;
  late final Future<List<String>> _idList;

  final Lock _storageLock = Lock();

  NotificationRepository() {
    _storage = _initStorage();
    _idList = _intiIdList();
  }

  Future<GetStorage> _initStorage() async {
    await GetStorage.init(_storageName);
    return GetStorage(_storageName);
  }

  Future<List<String>> _intiIdList() async {
    var storage = await _storage;
    if (!storage.hasData(_idListKey)) return [];

    return List<String>.from(storage.read(_idListKey));
  }

  Future<void> addNotification(RemoteMessage rm) async {
    List<String> idList = await _idList;
    FcmNotification noti = FcmNotification.fromRemoteMessage(rm);

    var storage = await _storage;
    await storage.write(_getItemKey(noti.id), Map<String, dynamic>.from(noti.toJson()));

    idList.insert(0, noti.id);
    await _saveIdList();

    if (idList.length > itemCountLimit) {
      await removeNotification(idList.last);
    }
  }

  Future<void> removeNotification(String id) async {
    List<String> idList = await _idList;

    var storage = await _storage;
    await storage.remove(_getItemKey(id));

    idList.remove(id);
    await _saveIdList();
  }

  Future<void> readNotification(String id) async {
    var storage = await _storage;
    String key = _getItemKey(id);
    if (!storage.hasData(key)) return;

    FcmNotification noti = FcmNotification.fromJson(Map<String, dynamic>.from(storage.read(key)));
    noti = noti.copyWith(read: true);

    await storage.write(key, Map<String, dynamic>.from(noti.toJson()));
  }

  Future<void> _saveIdList() async {
    await _storageLock.synchronized(() async {
      var storage = await _storage;
      await storage.write(_idListKey, await _idList);
    });
  }

  Future<List<FcmNotification>> getNotificationList() async {
      var idList = await _idList;
      var storage = await _storage;
      
      List<FcmNotification> notiList = [];

      for (var id in idList) {
        String key = _getItemKey(id);
        if (storage.hasData(key)) {
          try {
            FcmNotification noti = FcmNotification.fromJson(Map<String, dynamic>.from(storage.read(key)!));
            notiList.add(noti);
          } catch (e, st) {
            FirebaseCrashlytics.instance.recordError(e, st, fatal: false);
          }
        }
      }

      return notiList;
  }

  
  String _getItemKey(String id) {
    return "$_itemKeyPrefix$id";
  }
}
