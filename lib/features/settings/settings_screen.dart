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
    final volumeExtend = ref.watch(volumeExtendProvider);

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
          const SizedBox(height: 32),
          Text(l10n.extendAmount, style: textTheme.titleMedium),
          const _ExtendSlider(),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.volumeExtend),
            subtitle: Text(l10n.volumeExtendHint),
            value: volumeExtend,
            onChanged: (value) =>
                ref.read(volumeExtendProvider.notifier).set(value),
          ),
        ],
      ),
    );
  }
}

class _ExtendSlider extends ConsumerStatefulWidget {
  const _ExtendSlider();

  @override
  ConsumerState<_ExtendSlider> createState() => _ExtendSliderState();
}

class _ExtendSliderState extends ConsumerState<_ExtendSlider> {
  // Value shown while the finger is down; null when the slider is at rest.
  double? _dragging;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final saved = ref.watch(extendMinutesProvider);
    final value = _dragging ?? saved.toDouble();

    return Column(
      children: [
        Text(
          l10n.minutesButton(value.round()),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(trackHeight: 2),
          child: Slider(
            min: 1,
            max: maxExtendMinutes.toDouble(),
            divisions: maxExtendMinutes - 1,
            value: value,
            onChanged: (v) => setState(() => _dragging = v),
            onChangeEnd: (v) {
              ref.read(extendMinutesProvider.notifier).set(v.round());
              setState(() => _dragging = null);
            },
          ),
        ),
      ],
    );
  }
}
