import 'package:flutter/cupertino.dart' show CupertinoPicker;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziesta/features/timer/timer_notifier.dart';
import 'package:ziesta/l10n/app_localizations.dart';

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  static const _maxMinutes = 180;
  int _minutes = 30;
  late final FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: _minutes - 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final remaining = ref.watch(remainingProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (remaining != null) ...[
              Text(_format(remaining), style: textTheme.displayMedium),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => ref.read(timerEndProvider.notifier).cancel(),
                child: Text(l10n.cancel),
              ),
            ],
            Offstage(
              offstage: remaining != null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 90,
                        height: 180,
                        child: CupertinoPicker(
                          scrollController: _controller,
                          itemExtent: 48,
                          onSelectedItemChanged: (index) =>
                              setState(() => _minutes = index + 1),
                          children: [
                            for (var m = 1; m <= _maxMinutes; m++)
                              Center(
                                child: Text(
                                  '$m',
                                  style: textTheme.headlineMedium,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text(l10n.minutesUnit, style: textTheme.titleLarge),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    children: [
                      for (final m in [10, 20, 30, 60])
                        OutlinedButton(
                          onPressed: () => _controller.animateToItem(
                            m - 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          ),
                          child: Text(l10n.minutesButton(m)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () async {
                      final ok = await ref
                          .read(timerEndProvider.notifier)
                          .start(Duration(minutes: _minutes));
                      if (!ok && mounted) _showPermissionDialog();
                    },
                    child: Text(l10n.startTimer),
                  ),
                ],
              ),
            ),
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
