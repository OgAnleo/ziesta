import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziesta/app.dart';
import 'package:ziesta/core/preferences_provider.dart';
import 'package:ziesta/features/timer/timer_notifier.dart';

import 'helpers/fake_audio_channel.dart';

Future<void> pumpApp(
  WidgetTester tester,
  FakeAudioChannel fake, {
  Duration? remaining,
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        audioChannelProvider.overrideWithValue(fake),
        initialTimerEndProvider.overrideWithValue(
          remaining == null ? null : DateTime.now().add(remaining),
        ),
        remainingProvider.overrideWith((ref) => Stream.value(remaining)),
      ],
      child: const ZiestaApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  late FakeAudioChannel fake;

  setUp(() {
    fake = FakeAudioChannel();
  });

  testWidgets('shows the presets and the start button', (tester) async {
    await pumpApp(tester, fake);

    expect(find.text('Start'), findsOneWidget);
    for (final label in ['10 min', '20 min', '30 min', '60 min']) {
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('a preset moves the wheel and start uses its value', (
    tester,
  ) async {
    await pumpApp(tester, fake);

    await tester.tap(find.text('20 min'));
    await tester.pumpAndSettle();

    final before = DateTime.now();
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect(fake.scheduleCalls, 1);
    expect(fake.lastEnd!.difference(before).inMinutes, 20);
    expect(fake.notificationRequests, 1);
  });

  testWidgets('shows the permission dialog when alarms are not allowed', (
    tester,
  ) async {
    fake.canSchedule = false;
    await pumpApp(tester, fake);

    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect(find.text('Permission required'), findsOneWidget);

    await tester.tap(find.text('Open settings'));
    await tester.pumpAndSettle();

    expect(find.text('Permission required'), findsNothing);
    expect(fake.settingsOpened, 1);
  });

  testWidgets('shows the countdown and lets the user cancel', (tester) async {
    await pumpApp(
      tester,
      fake,
      remaining: const Duration(minutes: 5, seconds: 7),
    );

    expect(find.text('05:07'), findsOneWidget);
    expect(find.text('Start').hitTestable(), findsNothing);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(fake.cancelCalls, 1);
  });
}
