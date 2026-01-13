# socket_service

A lightweight Flutter Socket.IO service with **safe connection handling** and **multi-event listener support**. Designed to be simple, reusable, and easy to integrate in any Flutter app.

---

## Installation

Add the package to your app's `pubspec.yaml`:

```yaml

dependencies:
  socket_service:
    git:
      url: https://github.com/mohitchouhan-aripra/aripra_mobile_shared_feature.git
      path: socket_service   # path inside the repo where your socket code is


// 1️⃣ Define socket events that you want to listen to
final socketEvents = <String, EventCallback>{
  'driver_list': (data) {
    print('Driver list received: $data');
  },
};

// 2️⃣ Create an instance of SocketService with base URL, auth headers, and initial events
final socketService = SocketService(
  baseUrl: 'https://your-socket-url.com', // replace with your server URL
  header: () => {
    'token': 'USER_TOKEN', // replace with your auth token or header values
  },
  events: socketEvents,
);

// 3️⃣ Connect to the socket server
await socketService.connect(); // automatically registers initial events

// 4️⃣ Add new events dynamically after connection
socketService.addEvent('ride_status', (data) {
  print('Ride status update: $data');
});

// 5️⃣ Send / emit events to the server
socketService.sendEvent('update_location', {
  'lat': 28.61,
  'lng': 77.23,
});

// 6️⃣ Disconnect safely when done or on logout
socketService.disconnect(); // unregisters all listeners and disposes the socket
