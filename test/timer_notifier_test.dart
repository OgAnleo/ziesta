import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ziesta/features/timer/timer_notifier.dart';

import 'helpers/fake_audio_channel.dart';

ProviderContainer makeContainer(FakeAudioChannel fake, {DateTime? initialEnd}) {
  final container = ProviderContainer(
    overrides: [
      audioChannelProvider.overrideWithValue(fake),
      initialTimerEndProvider.overrideWithValue(initialEnd),
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

  test('starts with no timer', () {
    final container = makeContainer(fake);

    expect(container.read(timerEndProvider), isNull);
  });

  test('start schedules the alarm and updates the state', () async {
    final container = makeContainer(fake);

    final before = DateTime.now();
    final ok = await container
        .read(timerEndProvider.notifier)
        .start(const Duration(minutes: 30));
    final end = container.read(timerEndProvider);

    expect(ok, isTrue);
    expect(end, isNotNull);
    expect(end!.difference(before).inMinutes, 30);
    expect(fake.scheduleCalls, 1);
    expect(fake.nativeEnd, end);
  });

  test('start does nothing when the alarm permission is missing', () async {
    final container = makeContainer(fake);
    fake.canSchedule = false;

    final ok = await container
        .read(timerEndProvider.notifier)
        .start(const Duration(minutes: 30));

    expect(ok, isFalse);
    expect(container.read(timerEndProvider), isNull);
    expect(fake.nativeEnd, isNull);
  });

  test('cancel clears the state and the native alarm', () async {
    final container = makeContainer(fake);
    final notifier = container.read(timerEndProvider.notifier);

    await notifier.start(const Duration(minutes: 30));
    await notifier.cancel();

    expect(container.read(timerEndProvider), isNull);
    expect(fake.cancelCalls, 1);
    expect(fake.nativeEnd, isNull);
  });

  test('starts from the end time found by the native side', () {
    final end = DateTime.now().add(const Duration(minutes: 10));
    final container = makeContainer(fake, initialEnd: end);

    expect(container.read(timerEndProvider), end);
  });

  test('refresh picks up an extension made from the notification', () async {
    final container = makeContainer(fake);
    final notifier = container.read(timerEndProvider.notifier);
    await notifier.start(const Duration(minutes: 30));

    final extended = fake.nativeEnd!.add(const Duration(minutes: 15));
    fake.nativeEnd = extended;
    await notifier.refresh();

    expect(
      container.read(timerEndProvider)?.millisecondsSinceEpoch,
      extended.millisecondsSinceEpoch,
    );
  });

  test('refresh clears the state when the timer is gone natively', () async {
    final container = makeContainer(fake);
    final notifier = container.read(timerEndProvider.notifier);
    await notifier.start(const Duration(minutes: 30));

    fake.nativeEnd = null;
    await notifier.refresh();

    expect(container.read(timerEndProvider), isNull);
  });
}
