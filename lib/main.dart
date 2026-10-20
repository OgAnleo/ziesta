import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziesta/core/audio_channel.dart';

import 'app.dart';
import 'core/preferences_provider.dart';
import 'features/timer/timer_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final initialEnd = await AudioChannel().getEnd();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        initialTimerEndProvider.overrideWithValue(initialEnd),
      ],
      child: const ZiestaApp(),
    ),
  );
}
