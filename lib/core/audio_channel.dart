import 'package:flutter/services.dart';

class AudioChannel {
  static const _channel = MethodChannel('ziesta/audio');

  Future<bool> scheduleTimer(DateTime end) async {
    final ok = await _channel.invokeMethod<bool>('scheduleTimer', {
      'endMillis': end.millisecondsSinceEpoch,
    });
    return ok ?? false;
  }

  Future<void> cancelTimer() => _channel.invokeMethod<void>('cancelTimer');

  Future<void> openExactAlarmSettings() =>
      _channel.invokeMethod<void>('openExactAlarmSettings');

  Future<void> requestNotificationPermission() =>
      _channel.invokeMethod<void>('requestNotificationPermission');
}
