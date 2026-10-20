import 'package:flutter/cupertino.dart' show CupertinoPicker;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziesta/features/settings/settings_notifier.dart';
import 'package:ziesta/features/settings/settings_screen.dart';
import 'package:ziesta/features/timer/timer_notifier.dart';
import 'package:ziesta/l10n/app_localizations.dart';

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  late int _minutes;
  late final FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _minutes = ref.read(defaultMinutesProvider);
    _controller = FixedExtentScrollController(initialItem: _minutes - 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    await ref.read(audioChannelProvider).requestNotificationPermission();
    if (!mounted) return;
    final ok = await ref
        .read(timerEndProvider.notifier)
        .start(Duration(minutes: _minutes));
    if (!mounted) return;
    if (!ok) _showPermissionDialog();
  }

  Future<void> _showPermissionDialog() {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.permissionTitle),
        content: Text(l10n.permissionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ref.read(audioChannelProvider).openExactAlarmSettings();
            },
            child: Text(l10n.openSettings),
          ),
        ],
      ),
    );
  }

  Widget _preset(AppLocalizations l10n, int minutes) => OutlinedButton(
    onPressed: () => _controller.animateToItem(
      minutes - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    ),
    child: Text(l10n.minutesButton(minutes)),
  );

  Widget _wheel(AppLocalizations l10n) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final scheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 140,
          height: 264,
          child: CupertinoPicker(
            scrollController: _controller,
            itemExtent: 72,
            diameterRatio: 1.6,
            selectionOverlay: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(color: scheme.outline),
                ),
              ),
            ),
            onSelectedItemChanged: (index) =>
                setState(() => _minutes = index + 1),
            children: [
              for (var m = 1; m <= maxMinutes; m++)
                Center(
                  child: Text(
                    '$m',
                    style: m == _minutes
                        ? textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w300,
                          )
                        : textTheme.headlineMedium?.copyWith(
                            color: scheme.onSurfaceVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                  ),
                ),
            ],
          ),
        ),
        Text(
          l10n.minutesUnit,
          style: textTheme.titleLarge?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _idleView(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        children: [
          Expanded(child: Center(child: _wheel(l10n))),
          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 12,
                children: [
                  for (final m in [10, 20, 30]) _preset(l10n, m),
                ],
              ),
              _preset(l10n, 60),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 280,
            child: FilledButton(
              onPressed: _start,
              child: Text(l10n.startTimer),
            ),
          ),
        ],
      ),
    );
  }

  Widget _runningView(AppLocalizations l10n, Duration remaining) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 32,
        children: [
          Text(_format(remaining), style: textTheme.displayLarge),
          TextButton(
            onPressed: () => ref.read(timerEndProvider.notifier).cancel(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final remaining = ref.watch(remainingProvider).value;

    ref.listen(defaultMinutesProvider, (_, minutes) {
      _controller.jumpToItem(minutes - 1);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle.toUpperCase()),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settings,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Offstage(offstage: remaining != null, child: _idleView(l10n)),
            if (remaining != null) _runningView(l10n, remaining),
          ],
        ),
      ),
    );
  }
}

String _format(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return h > 0 ? '$h:$m:$s' : '$m:$s';
}
