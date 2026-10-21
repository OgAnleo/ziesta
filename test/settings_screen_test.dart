import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziesta/core/preferences_provider.dart';
import 'package:ziesta/features/settings/settings_screen.dart';
import 'package:ziesta/features/timer/timer_notifier.dart';
import 'package:ziesta/l10n/app_localizations.dart';

import 'helpers/fake_audio_channel.dart';

void main() {
  testWidgets('releasing the extend slider saves the value once', (
    tester,
  ) async {
    final fake = FakeAudioChannel();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          audioChannelProvider.overrideWithValue(fake),
        ],
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SettingsScreen(),
        ),
      ),
    );

    expect(find.text('15 min'), findsOneWidget);

    final slider = find.byType(Slider).last;
    final gesture = await tester.startGesture(tester.getCenter(slider));
    await gesture.moveBy(const Offset(100, 0));
    await tester.pump();
    expect(fake.setExtendCalls, 0);

    await gesture.up();
    await tester.pumpAndSettle();

    expect(fake.setExtendCalls, 1);
    expect(fake.extendMinutes, greaterThan(15));
  });

  testWidgets('the volume switch is on and saves when toggled', (tester) async {
    final fake = FakeAudioChannel();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          audioChannelProvider.overrideWithValue(fake),
        ],
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SettingsScreen(),
        ),
      ),
    );

    expect(tester.widget<Switch>(find.byType(Switch).first).value, isTrue);

    await tester.tap(find.text('Extend with volume button'));
    await tester.pumpAndSettle();

    expect(tester.widget<Switch>(find.byType(Switch).first).value, isFalse);
    expect(fake.volumeExtend, isFalse);
  });

  testWidgets('the lock switch is off and turns on when accepted', (
    tester,
  ) async {
    final fake = FakeAudioChannel();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          audioChannelProvider.overrideWithValue(fake),
        ],
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final lockSwitch = find.byType(Switch).last;
    expect(tester.widget<Switch>(lockSwitch).value, isFalse);

    await tester.tap(find.text('Lock screen when it ends'));
    await tester.pumpAndSettle();

    expect(tester.widget<Switch>(lockSwitch).value, isTrue);
    expect(fake.lockOnEnd, isTrue);
  });
}
