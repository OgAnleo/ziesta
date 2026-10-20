import 'package:flutter_test/flutter_test.dart';
import 'package:ziesta/core/audio_channel.dart';

class FakeAudioChannel extends Fake implements AudioChannel {
  bool canSchedule = true;
  int scheduleCalls = 0;
  int cancelCalls = 0;
  int notificationRequests = 0;
  int settingsOpened = 0;
  DateTime? lastEnd;

  @override
  Future<bool> scheduleTimer(DateTime end) async {
    scheduleCalls++;
    lastEnd = end;
    return canSchedule;
  }

  @override
  Future<void> cancelTimer() async {
    cancelCalls++;
  }

  @override
  Future<void> requestNotificationPermission() async {
    notificationRequests++;
  }

  @override
  Future<void> openExactAlarmSettings() async {
    settingsOpened++;
  }
}
