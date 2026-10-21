import 'package:flutter/cupertino.dart' show CupertinoPicker;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziesta/features/settings/settings_notifier.dart';
import 'package:ziesta/features/settings/settings_screen.dart';
import 'package:ziesta/features/timer/timer_notifier.dart';
import 'package:ziesta/l10n/app_localizations.dart';
import 'package:ziesta/features/menu/app_menu.dart';

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

  String _clock(DateTime time) =>
      MaterialLocalizations.of(context).formatTimeOfDay(
        TimeOfDay.fromDateTime(time),
        alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
      );

  Widget _preset(AppLocalizations l10n, int minutes) {
    final scheme = Theme.of(context).colorScheme;
    final selected = _minutes == minutes;
    return OutlinedButton(
      style: selected
          ? OutlinedButton.styleFrom(
              side: BorderSide(color: scheme.primary),
              foregroundColor: scheme.primary,
            )
          : null,
      onPressed: () => _controller.animateToItem(
        minutes - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      ),
      child: Text(l10n.minutesButton(minutes)),
    );
  }

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

  Widget _runningView(AppLocalizations l10n, Duration remaining, DateTime end) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final muted = theme.colorScheme.onSurfaceVariant;

    return Center(
      key: const ValueKey('running'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_format(remaining), style: textTheme.displayLarge),
          const SizedBox(height: 12),
          Text(
            l10n.pausesAt(_clock(end)),
            style: textTheme.titleMedium?.copyWith(color: muted),
          ),
          const SizedBox(height: 48),
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
    final end = ref.watch(timerEndProvider);
    final running = end != null;
    final left =
        ref.watch(remainingProvider).value ??
        (end?.difference(DateTime.now()) ?? Duration.zero);

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
          const AppMenu(),
        ],
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            IgnorePointer(
              ignoring: running,
              child: ExcludeSemantics(
                excluding: running,
                child: AnimatedOpacity(
                  opacity: running ? 0 : 1,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: _idleView(l10n),
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.94, end: 1).animate(animation),
                  child: child,
                ),
              ),
              child: end == null
                  ? const SizedBox.shrink(key: ValueKey('none'))
                  : _runningView(l10n, left, end),
            ),
          ],
        ),
      ),
    );
  }
}

String _format(Duration value) {
  final d = value.isNegative ? Duration.zero : value;
  final h = d.inHours;
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return h > 0 ? '$h:$m:$s' : '$m:$s';
}
