import 'package:flutter/services.dart';

class AudioChannel {
  static const _channel = MethodChannel('ziesta/audio');

  Future<String?> ping() => _channel.invokeMethod<String>('ping');
}
