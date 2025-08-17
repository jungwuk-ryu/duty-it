import 'package:duty_it/app/core/events/app_event.dart';
import 'package:get/get.dart';

typedef L = void Function(AppEvent);

class AppEventService extends GetxService {
  final Map<Type, List<L>> _mapping = {};

  void fire(AppEvent e) {
    List<L> listeners = _mapping[e.runtimeType] ?? [];
    
    for (L fn in listeners) {
      try {
        fn(e);
      } catch (_){
        // TODO : 로깅
      }
    }
  }

  void addListener (Type type, L listener) {
    List<L> listeners = _mapping[type] ?? [];
    if (!listeners.contains(listener)) listeners.add(listener);

    _mapping[type] = listeners;
  }
}