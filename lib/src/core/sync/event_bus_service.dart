import 'dart:async';

class EventBusService {
  static final EventBusService _instance = EventBusService._internal();
  factory EventBusService() => _instance;
  EventBusService._internal();

  final Map<Type, StreamController> _controllers = {};
  final Map<Type, List<StreamSubscription>> _subscriptions = {};

  void fire<T>(T event) {
    final controller = _getController<T>();
    controller.add(event);
  }

  StreamSubscription<T> on<T>(void Function(T event) callback) {
    final controller = _getController<T>();
    final subscription = controller.stream.cast<T>().listen(callback);

    _subscriptions.putIfAbsent(T, () => []).add(subscription);

    return subscription;
  }

  StreamController<T> _getController<T>() {
    if (!_controllers.containsKey(T)) {
      _controllers[T] = StreamController<T>.broadcast();
    }
    return _controllers[T] as StreamController<T>;
  }

  void cancelSubscriptions<T>() {
    final subscriptions = _subscriptions[T];
    if (subscriptions != null) {
      for (final subscription in subscriptions) {
        subscription.cancel();
      }
      subscriptions.clear();
    }
  }

  void dispose() {
    for (final subscriptionList in _subscriptions.values) {
      for (final subscription in subscriptionList) {
        subscription.cancel();
      }
    }
    _subscriptions.clear();

    for (final controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
  }
}
