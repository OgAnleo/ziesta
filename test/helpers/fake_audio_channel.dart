import 'package:flutter_test/flutter_test.dart';
import 'package:ziesta/core/audio_channel.dart';

class FakeAudioChannel extends Fake implements AudioChannel {
  bool canSchedule = true;
  int scheduleCalls = 0;
  int cancelCalls = 0;
  int notificationRequests = 0;
  int settingsOpened = 0;
  DateTime? lastEnd;
  DateTime? nativeEnd;
  final sharedTexts = <String>[];
  int extendMinutes = 15;
  int setExtendCalls = 0;
  bool volumeExtend = true;

  @override
  Future<bool> scheduleTimer(DateTime end) async {
    scheduleCalls++;
    lastEnd = end;
    if (canSchedule) nativeEnd = end;
    return canSchedule;
  }

  @override
  Future<void> cancelTimer() async {
    cancelCalls++;
    nativeEnd = null;
  }

  @override
  Future<DateTime?> getEnd() async => nativeEnd;

  @override
  Future<bool> requestNotificationPermission() async {
    notificationRequests++;
    return true;
  }

  @override
  Future<void> openExactAlarmSettings() async {
    settingsOpened++;
  }

  @override
  Future<int> getExtendMinutes() async => extendMinutes;

  @override
  Future<void> setExtendMinutes(int minutes) async {
    setExtendCalls++;
    extendMinutes = minutes;
  }

  @override
  Future<bool> getVolumeExtend() async => volumeExtend;

  @override
  Future<void> setVolumeExtend(bool enabled) async {
    volumeExtend = enabled;
  }

  bool lockAdminActive = false;
  bool acceptLockAdmin = true;
  bool lockOnEnd = false;
  int lockRequests = 0;
  int removeLockCalls = 0;

  @override
  Future<bool> isLockAdminActive() async => lockAdminActive;

  @override
  Future<bool> requestLockAdmin() async {
    lockRequests++;
    lockAdminActive = acceptLockAdmin;
    return acceptLockAdmin;
  }

  @override
  Future<void> removeLockAdmin() async {
    removeLockCalls++;
    lockAdminActive = false;
    lockOnEnd = false;
  }

  @override
  Future<bool> getLockOnEnd() async => lockOnEnd;

  @override
  Future<void> setLockOnEnd(bool enabled) async {
    lockOnEnd = enabled;
  }

  @override
  Future<void> shareText(String text) async {
    sharedTexts.add(text);
  }
}
