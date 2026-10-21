import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ziesta/features/settings/settings_notifier.dart';
import 'package:ziesta/features/timer/timer_notifier.dart';

import 'helpers/fake_audio_channel.dart';

void main() {
  late FakeAudioChannel fake;

  ProviderContainer makeContainer({int? initial, bool? volumeExtend}) {
    final container = ProviderContainer(
      overrides: [
        audioChannelProvider.overrideWithValue(fake),
        if (initial != null)
          initialExtendMinutesProvider.overrideWithValue(initial),
        if (volumeExtend != null)
          initialVolumeExtendProvider.overrideWithValue(volumeExtend),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    fake = FakeAudioChannel();
  });

  test('extend amount defaults to 15 minutes', () {
    expect(makeContainer().read(extendMinutesProvider), 15);
  });

  test('extend amount starts from the value found by the native side', () {
    expect(makeContainer(initial: 30).read(extendMinutesProvider), 30);
  });

  test('set updates the state and the native side', () async {
    final container = makeContainer();

    await container.read(extendMinutesProvider.notifier).set(10);

    expect(container.read(extendMinutesProvider), 10);
    expect(fake.extendMinutes, 10);
  });

  test('volume extend is on by default', () {
    expect(makeContainer().read(volumeExtendProvider), isTrue);
  });

  test('volume extend set updates the state and the native side', () async {
    final container = makeContainer(volumeExtend: true);

    await container.read(volumeExtendProvider.notifier).set(false);

    expect(container.read(volumeExtendProvider), isFalse);
    expect(fake.volumeExtend, isFalse);
  });
}
