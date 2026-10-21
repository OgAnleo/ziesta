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

  Future<int> getExtendMinutes() async {
    try {
      final minutes = await _channel.invokeMethod<int>('getExtendMinutes');
      return minutes ?? 15;
    } on Exception {
      return 15;
    }
  }

  Future<void> setExtendMinutes(int minutes) =>
      _channel.invokeMethod<void>('setExtendMinutes', {'minutes': minutes});

  Future<bool> getVolumeExtend() async {
    try {
      return await _channel.invokeMethod<bool>('getVolumeExtend') ?? true;
    } on Exception {
      return true;
    }
  }

  Future<void> setVolumeExtend(bool enabled) =>
      _channel.invokeMethod<void>('setVolumeExtend', {'enabled': enabled});

  Future<bool> isLockAdminActive() async {
    try {
      return await _channel.invokeMethod<bool>('isLockAdminActive') ?? false;
    } on Exception {
      return false;
    }
  }

  /// Opens the system activation screen; true only if the user accepted.
  Future<bool> requestLockAdmin() async {
    final granted = await _channel.invokeMethod<bool>('requestLockAdmin');
    return granted ?? false;
  }

  Future<void> removeLockAdmin() =>
      _channel.invokeMethod<void>('removeLockAdmin');

  Future<bool> getLockOnEnd() async {
    try {
      return await _channel.invokeMethod<bool>('getLockOnEnd') ?? false;
    } on Exception {
      return false;
    }
  }

  Future<void> setLockOnEnd(bool enabled) =>
      _channel.invokeMethod<void>('setLockOnEnd', {'enabled': enabled});

  Future<void> shareText(String text) =>
      _channel.invokeMethod<void>('shareText', {'text': text});
}
