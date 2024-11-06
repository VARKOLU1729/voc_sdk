import 'package:flutter/services.dart';

class NativeEventNotifier {
  static const MethodChannel _channel = MethodChannel('VOICECALL');

  void startListening(Function(dynamic) onEventReceived) {
    _channel.setMethodCallHandler((call) async {
      Map<dynamic, dynamic> data = {};
      data[call.method] = call.arguments;
      onEventReceived(data);
    });
  }
}
