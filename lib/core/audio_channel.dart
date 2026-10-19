import 'package:flutter/services.dart';

class AudioChannel {
  static const _channel = MethodChannel('ziesta/audio');

  Future<String?> ping() => _channel.invokeMethod<String>('ping');
  Future<bool> pauseMedia() async {
    final ok = await _channel.invokeMethod<bool>('pauseMedia');
    return ok ?? false;
  }
}
