import 'package:duty_it/app/core/utils/events/app_event.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';

typedef L = void Function(AppEvent);

class AppEventService extends GetxService {
  final Map<Type, List<L>> _mapping = {};

  void fire(AppEvent e) {
    List<L> listeners = _mapping[e.runtimeType] ?? [];
    
    for (L fn in listeners) {
      try {
        fn(e);
      } catch (e, s){
        FirebaseCrashlytics.instance.recordError(e, s, fatal: false);
      }
    }
  }

  void addListener (Type type, L listener) {
    List<L> listeners = _mapping[type] ?? [];
    if (!listeners.contains(listener)) listeners.add(listener);

    _mapping[type] = listeners;
  }
}