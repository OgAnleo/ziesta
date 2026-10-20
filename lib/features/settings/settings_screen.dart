import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziesta/features/settings/settings_notifier.dart';
import 'package:ziesta/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final themeMode = ref.watch(themeModeProvider);
    final defaultMinutes = ref.watch(defaultMinutesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.theme, style: textTheme.titleMedium),
          const SizedBox(height: 12),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.light,
                label: Text(l10n.themeLight),
              ),
              ButtonSegment(value: ThemeMode.dark, label: Text(l10n.themeDark)),
            ],
            selected: {themeMode},
            onSelectionChanged: (selection) =>
                ref.read(themeModeProvider.notifier).set(selection.first),
          ),
          const SizedBox(height: 32),
          Text(l10n.defaultDuration, style: textTheme.titleMedium),
          Slider(
            min: 1,
            max: maxMinutes.toDouble(),
            divisions: maxMinutes - 1,
            value: defaultMinutes.toDouble(),
            label: l10n.minutesButton(defaultMinutes),
            onChanged: (value) =>
                ref.read(defaultMinutesProvider.notifier).set(value.round()),
          ),
        ],
      ),
    );
  }
}
