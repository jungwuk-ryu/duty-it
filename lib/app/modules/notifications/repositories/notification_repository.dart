import 'dart:convert';

import 'package:duty_it/app/modules/notifications/models/fcm_notification.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

class NotificationRepository {
  static const String _prefix = "notifications:";
  static const String _itemKeyPrefix = "${_prefix}noti:";
  static const String _idListKey = "${_prefix}id_list";
  static const int itemCountLimit = 100;

  late final SharedPreferencesAsync sp;
  final Lock _workLock = Lock();

  NotificationRepository() {
    sp = SharedPreferencesAsync();
  }

  Future<List<String>> getIdList() async {
    List<String>? list = await sp.getStringList(_idListKey);
    if (list == null) return [];

    return list;
  }

  Future<void> addNotification(RemoteMessage rm) async {
    await _workLock.synchronized(() async {
      List<String> idList = await getIdList();
      FcmNotification noti = FcmNotification.fromRemoteMessage(rm);

      await sp.setString(
        _getItemKey(noti.id),
        json.encode(Map<String, dynamic>.from(noti.toJson())),
      );

      idList.insert(0, noti.id);
      await _saveIdList(idList);
    });

    List<String> idList = await getIdList();
    if (idList.length > itemCountLimit) {
      await removeNotification(idList.last);
    }
  }

  Future<void> removeNotification(String id) async {
    await _workLock.synchronized(() async {
      List<String> idList = await getIdList();
      idList.remove(id);

      await Future.wait([sp.remove(_getItemKey(id)), _saveIdList(idList)]);
    });
  }

  Future<void> readNotification(String id) async {
    await _workLock.synchronized(() async {
      String key = _getItemKey(id);
      if (!await sp.containsKey(key)) return;

      FcmNotification noti = FcmNotification.fromJson(
        Map<String, dynamic>.from(
          json.decode((await sp.getString(key)) as String),
        ),
      );
      noti = noti.copyWith(read: true);

      await sp.setString(key, json.encode(noti.toJson()));
    });
  }

  Future<List<FcmNotification>> getNotificationList() async {
    List<String> idList = await getIdList();
    List<FcmNotification> notiList = [];

    for (var id in idList) {
      FcmNotification? noti = await getNotificationById(id);
      if (noti != null) notiList.add(noti);
    }

    return notiList;
  }

  Future<FcmNotification?> getNotificationById(String id) async {
    String key = _getItemKey(id);

    String? jsonNoti = await sp.getString(key);

    if (jsonNoti != null) {
      try {
        FcmNotification noti = FcmNotification.fromJson(json.decode(jsonNoti));
        return noti;
      } catch (e, st) {
        FirebaseCrashlytics.instance.recordError(e, st, fatal: false);
      }
    }

    return null;
  }

  Future<void> clearList() async {
    await _workLock.synchronized(() async {
      var idList = await getIdList();
      await Future.wait(
        idList.map((e) => sp.remove(_getItemKey(e))).toList()
          ..add(_saveIdList([])),
      );
    });
  }

  String _getItemKey(String id) {
    return "$_itemKeyPrefix$id";
  }

  Future<void> _saveIdList(List<String> idList) async {
    await sp.setStringList(_idListKey, idList);
  }
}
