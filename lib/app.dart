import 'package:flutter/material.dart';
import 'package:ziesta/features/timer/timer_screen.dart';
import 'package:ziesta/l10n/app_localizations.dart';

class ZiestaApp extends StatelessWidget {
  const ZiestaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Ziesta',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const TimerScreen(),
    );
  }
}
