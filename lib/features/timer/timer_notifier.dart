import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziesta/core/audio_channel.dart';

final audioChannelProvider = Provider((ref) => AudioChannel());

final timerEndProvider = NotifierProvider<TimerEndNotifier, DateTime?>(
  TimerEndNotifier.new,
);

final remainingProvider = StreamProvider<Duration?>((ref) async* {
  final end = ref.watch(timerEndProvider);
  if (end == null) {
    yield null;
    return;
  }
  while (true) {
    final remaining = end.difference(DateTime.now());
    if (remaining <= Duration.zero) {
      yield null;
      await ref.read(timerEndProvider.notifier).cancel();
      return;
    }
    yield remaining;
    await Future.delayed(const Duration(seconds: 1));
  }
});

class TimerEndNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() => null;

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
}
