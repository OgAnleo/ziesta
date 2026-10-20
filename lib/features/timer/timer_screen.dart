import 'package:flutter/material.dart';
import 'package:ziesta/core/audio_channel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziesta/features/timer/timer_notifier.dart';
import 'package:ziesta/l10n/app_localizations.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final remaining = ref.watch(remainingProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              remaining == null ? 'Sin temporizador' : _format(remaining),
              style: Theme.of(context).textTheme.displayMedium,
            ),
            if (remaining != null)
              TextButton(
                onPressed: () => ref.read(timerEndProvider.notifier).cancel(),
                child: const Text('Cancelar'),
              ),
            ElevatedButton(
              onPressed: () => ref
                  .read(timerEndProvider.notifier)
                  .start(const Duration(minutes: 1)),
              child: Text(l10n.startTimer),
            ),
            ElevatedButton(
              onPressed: () => AudioChannel().pauseMedia(),
              child: const Text('Pausar ahora'),
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
