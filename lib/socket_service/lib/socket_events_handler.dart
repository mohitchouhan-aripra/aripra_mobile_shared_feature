import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'socket_types.dart';

class SocketEventsHandler {
  final IO.Socket socket;

  final Map<String, List<EventCallback>> _events = {};

  bool _registered = false;

  SocketEventsHandler({required Map<String, EventCallback> events, required this.socket}) {
    events.forEach((key, callback) {
      addEvent(key, callback);
    });
  }

  void register() {
    if (_registered) return;

    _events.forEach((event, callbacks) {
      socket.off(event);
      for (var callback in callbacks) {
        socket.on(event, callback);
      }
    });

    _registered = true;
  }

  void unregister() {
    if (!_registered) return;

    _events.keys.forEach(socket.off);
    _registered = false;
  }

  void addEvent(String event, EventCallback callback) {
    if (!_events.containsKey(event)) {
      _events[event] = [];
    }

    if (!_events[event]!.contains(callback)) {
      _events[event]!.add(callback);

      if (socket.connected) {
        socket.on(event, callback);
        print('[SocketEventsHandler] Listening → $event');
      }
    } else {
      print('[SocketEventsHandler] Callback already exists for → $event');
    }
  }
}
