import 'dart:async';
import 'dart:convert';
import 'dart:io'; 

Future<String> communicateWithRaspberryPi() async {
  try {
    Socket socket = await Socket.connect('127.0.0.1',
        5001); // Replace with your Raspberry Pi's IP address and port number

    Completer<String> completer = Completer<String>();

    socket.listen((List<int> data) {
      String message = utf8.decode(data);
      print('Received message: $message');
      completer.complete(message);
    });

    // Send a message to the Raspberry Pi
    String message = 'Hello from Flutter!';
    socket.write(utf8.encode(message));

    return completer.future;
  } catch (e) {
    print('Error: $e'); //see if you can configure this to select mode
    throw e;
  }
}
