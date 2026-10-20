import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziesta/core/audio_channel.dart';
import 'package:ziesta/core/preferences_provider.dart';

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
  static const _key = 'timer_end';

  @override
  DateTime? build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final millis = prefs.getInt(_key);
    if (millis == null) return null;
    final end = DateTime.fromMillisecondsSinceEpoch(millis);
    if (end.isBefore(DateTime.now())) {
      prefs.remove(_key);
      return null;
    }
    return end;
  }

  Future<bool> start(Duration duration) async {
    final end = DateTime.now().add(duration);
    final ok = await ref.read(audioChannelProvider).scheduleTimer(end);
    if (ok) {
      await ref
          .read(sharedPreferencesProvider)
          .setInt(_key, end.millisecondsSinceEpoch);
      state = end;
    }
    return ok;
  }

  Future<void> cancel() async {
    await ref.read(audioChannelProvider).cancelTimer();
    await ref.read(sharedPreferencesProvider).remove(_key);
    state = null;
  }
}
