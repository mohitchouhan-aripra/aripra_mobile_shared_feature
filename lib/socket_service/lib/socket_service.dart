import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'socket_events_handler.dart';
import 'socket_types.dart';

class SocketService {
  final String baseUrl;
  final Map<String, dynamic> Function()? header;
  final Map<String, dynamic> Function()? query;
  final Map<String, EventCallback> events;

  IO.Socket? _socket;
  late SocketEventsHandler _eventsHandler;

  bool _connecting = false;

  SocketService({
    required this.baseUrl,
    this.header,
    this.query,
    Map<String, EventCallback>? events,
  }) : events = events ?? {};


  Future<String> connect() async {
    if (_socket?.connected == true) return 'Already connected';
    if (_connecting) return 'Connection already in progress';

    _connecting = true;

    _socket?.dispose();

    final authData = header?.call() ?? {};
    final queryData = query?.call() ?? {};


    _socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth(authData)
          .setQuery(queryData)
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(3000)
          .build(),
    );

    if (events.isNotEmpty) {
      _eventsHandler = SocketEventsHandler(
        events: events,
        socket: _socket!,
      );
    }

    _socket!
      ..clearListeners()
      ..onConnect((_) {
        _connecting = false;
        _eventsHandler?.register();
        print('[Socket] Connected');
      })
      ..onDisconnect((reason) {
        _connecting = false;
        _eventsHandler?.unregister();
        print('[Socket] Disconnected → $reason');
      })
      ..onError((e) {
        _connecting = false;
        print('[Socket] Error → $e');
      });

    _socket!.connect();
    return 'Connecting...';
  }

  void disconnect() {
    if (_socket == null) return;

    _eventsHandler?.unregister();

    _socket!
      ..clearListeners()
      ..disconnect()
      ..dispose();

    _socket = null;
    _connecting = false;
    print('[Socket] Disconnected & destroyed');
  }

  void sendEvent(String event, dynamic data) {
    if (_socket?.connected == true) {
      _socket!.emit(event, data);
      print('[Socket] Emitted → $event : $data');
    } else {
      print('[Socket] Cannot emit, socket not connected');
    }
  }

  void addEvent(String event, EventCallback callback) {
    _eventsHandler.addEvent(event, callback);
    print('[Socket] Added new callback for event → $event');
  }

}
