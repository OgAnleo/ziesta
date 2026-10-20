import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziesta/core/audio_channel.dart';

final audioChannelProvider = Provider((ref) => AudioChannel());

/// End time read from the native side before the app starts.
final initialTimerEndProvider = Provider<DateTime?>((ref) => null);

final timerEndProvider = NotifierProvider<TimerEndNotifier, DateTime?>(
  TimerEndNotifier.new,
);

final remainingProvider = StreamProvider<Duration?>((ref) async* {
  final end = ref.watch(timerEndProvider);
  final notifier = ref.read(timerEndProvider.notifier);
  if (end == null) {
    yield null;
    return;
  }
  while (true) {
    final remaining = end.difference(DateTime.now());
    if (remaining <= Duration.zero) {
      await notifier.refresh();
      yield null;
      return;
    }
    yield remaining;
    await Future.delayed(const Duration(seconds: 1));
    await notifier.refresh();
  }
});

class TimerEndNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() => ref.read(initialTimerEndProvider);

  Future<bool> start(Duration duration) async {
    final end = DateTime.now().add(duration);
    final ok = await ref.read(audioChannelProvider).scheduleTimer(end);
    if (ok) state = end;
    return ok;
  }

  Future<void> cancel() async {
    await ref.read(audioChannelProvider).cancelTimer();
    state = null;
  }

  Future<void> refresh() async {
    final end = await ref.read(audioChannelProvider).getEnd();
    if (end?.millisecondsSinceEpoch != state?.millisecondsSinceEpoch) {
      state = end;
    }
  }
}
