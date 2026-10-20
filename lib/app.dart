import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziesta/features/settings/settings_notifier.dart';
import 'package:ziesta/features/timer/timer_screen.dart';
import 'package:ziesta/l10n/app_localizations.dart';

const _seed = Color(0xFF1E3A8A);
const _nightSurface = Color(0xFF0B1020);

class ZiestaApp extends ConsumerWidget {
  const ZiestaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Ziesta',
      theme: ThemeData(colorSchemeSeed: _seed, useMaterial3: true),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
          surface: _nightSurface,
        ),
        useMaterial3: true,
      ),
      themeMode: themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const TimerScreen(),
    );
  }
}
