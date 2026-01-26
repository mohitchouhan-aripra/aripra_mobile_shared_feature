import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'socket_types.dart';

class SocketEventsHandler {
  final IO.Socket socket;
  final Map<String, EventCallback> events;

  bool _registered = false;

  SocketEventsHandler({
    required this.socket,
    required this.events,
  });

  void register() {
    if (_registered) return;

    events.forEach((event, callback) {
      socket.off(event);
      socket.on(event, callback);
      print('[SocketEventsHandler] Registered → $event');
    });

    _registered = true;
  }

  void unregister() {
    if (!_registered) return;

    for (final event in events.keys) {
      socket.off(event);
    }

    _registered = false;
    print('[SocketEventsHandler] Unregistered all');
  }
}
