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
  Future<void> shareText(String text) async {
    sharedTexts.add(text);
  }
}
