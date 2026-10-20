import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziesta/core/audio_channel.dart';
import 'package:ziesta/core/preferences_provider.dart';
import 'package:ziesta/features/timer/timer_notifier.dart';

import 'helpers/fake_audio_channel.dart';

ProviderContainer makeContainer(SharedPreferences prefs, AudioChannel fake) {
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      audioChannelProvider.overrideWithValue(fake),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  late FakeAudioChannel fake;

  setUp(() {
    fake = FakeAudioChannel();
  });

  test('starts with no timer when nothing is saved', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = makeContainer(prefs, fake);

    expect(container.read(timerEndProvider), isNull);
  });

  test('start schedules the alarm and saves the end time', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = makeContainer(prefs, fake);

    final before = DateTime.now();
    final ok = await container
        .read(timerEndProvider.notifier)
        .start(const Duration(minutes: 30));
    final end = container.read(timerEndProvider);

    expect(ok, isTrue);
    expect(end, isNotNull);
    expect(end!.difference(before).inMinutes, 30);
    expect(fake.scheduleCalls, 1);
    expect(fake.lastEnd, end);
    expect(prefs.getInt('timer_end'), end.millisecondsSinceEpoch);
  });

  test('start does nothing when the alarm permission is missing', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = makeContainer(prefs, fake);
    fake.canSchedule = false;

    final ok = await container
        .read(timerEndProvider.notifier)
        .start(const Duration(minutes: 30));

    expect(ok, isFalse);
    expect(container.read(timerEndProvider), isNull);
    expect(prefs.getInt('timer_end'), isNull);
  });

  test('cancel clears the state and the saved time', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = makeContainer(prefs, fake);
    final notifier = container.read(timerEndProvider.notifier);

    await notifier.start(const Duration(minutes: 30));
    await notifier.cancel();

    expect(container.read(timerEndProvider), isNull);
    expect(fake.cancelCalls, 1);
    expect(prefs.getInt('timer_end'), isNull);
  });

  test('recovers a saved end time that is still in the future', () async {
    final future = DateTime.now().add(const Duration(minutes: 10));
    SharedPreferences.setMockInitialValues({
      'timer_end': future.millisecondsSinceEpoch,
    });
    final prefs = await SharedPreferences.getInstance();
    final container = makeContainer(prefs, fake);

    expect(
      container.read(timerEndProvider)?.millisecondsSinceEpoch,
      future.millisecondsSinceEpoch,
    );
  });

  test('discards a saved end time that already passed', () async {
    final past = DateTime.now().subtract(const Duration(minutes: 1));
    SharedPreferences.setMockInitialValues({
      'timer_end': past.millisecondsSinceEpoch,
    });
    final prefs = await SharedPreferences.getInstance();
    final container = makeContainer(prefs, fake);

    expect(container.read(timerEndProvider), isNull);
    expect(prefs.getInt('timer_end'), isNull);
  });
}
