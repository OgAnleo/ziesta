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

  Future<DateTime?> getEnd() async {
    try {
      final millis = await _channel.invokeMethod<int>('getEnd');
      return millis == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(millis);
    } on Exception {
      return null;
    }
  }

  Future<bool> requestNotificationPermission() async {
    final granted = await _channel.invokeMethod<bool>(
      'requestNotificationPermission',
    );
    return granted ?? false;
  }

  Future<void> shareText(String text) =>
      _channel.invokeMethod<void>('shareText', {'text': text});
}
