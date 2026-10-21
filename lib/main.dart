import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziesta/core/audio_channel.dart';

import 'app.dart';
import 'core/preferences_provider.dart';
import 'features/settings/settings_notifier.dart';
import 'features/timer/timer_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final channel = AudioChannel();
  final initialEnd = await channel.getEnd();
  final extendMinutes = await channel.getExtendMinutes();
  final volumeExtend = await channel.getVolumeExtend();
  final lockOnEnd =
      await channel.getLockOnEnd() && await channel.isLockAdminActive();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        initialTimerEndProvider.overrideWithValue(initialEnd),
        initialExtendMinutesProvider.overrideWithValue(extendMinutes),
        initialVolumeExtendProvider.overrideWithValue(volumeExtend),
        initialLockOnEndProvider.overrideWithValue(lockOnEnd),
      ],
      child: const ZiestaApp(),
    ),
  );
}
