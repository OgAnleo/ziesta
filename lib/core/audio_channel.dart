import 'package:flutter/services.dart';

class AudioChannel {
  static const _channel = MethodChannel('ziesta/audio');

  Future<String?> ping() => _channel.invokeMethod<String>('ping');
  Future<bool> pauseMedia() async {
    final ok = await _channel.invokeMethod<bool>('pauseMedia');
    return ok ?? false;
  }

  Future<bool> scheduleTimer(DateTime end) async {
    final ok = await _channel.invokeMethod<bool>('scheduleTimer', {
      'endMillis': end.millisecondsSinceEpoch,
    });
    return ok ?? false;
  }

  Future<void> cancelTimer() => _channel.invokeMethod<void>('cancelTimer');

  Future<bool> canScheduleExact() async =>
      await _channel.invokeMethod<bool>('canScheduleExact') ?? false;

  Future<void> openExactAlarmSettings() =>
      _channel.invokeMethod<void>('openExactAlarmSettings');
}
