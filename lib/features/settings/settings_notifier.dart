import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziesta/core/preferences_provider.dart';
import 'package:ziesta/features/timer/timer_notifier.dart';

const maxMinutes = 180;
const maxExtendMinutes = 60;

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    final name = ref.read(sharedPreferencesProvider).getString(_key);
    return name == ThemeMode.light.name ? ThemeMode.light : ThemeMode.dark;
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref.read(sharedPreferencesProvider).setString(_key, mode.name);
  }
}

final defaultMinutesProvider = NotifierProvider<DefaultMinutesNotifier, int>(
  DefaultMinutesNotifier.new,
);

class DefaultMinutesNotifier extends Notifier<int> {
  static const _key = 'default_minutes';

  @override
  int build() {
    final saved = ref.read(sharedPreferencesProvider).getInt(_key);
    return (saved ?? 30).clamp(1, maxMinutes).toInt();
  }

  Future<void> set(int minutes) async {
    state = minutes;
    await ref.read(sharedPreferencesProvider).setInt(_key, minutes);
  }
}

/// Extend amount read from the native side before the app starts.
final initialExtendMinutesProvider = Provider<int>((ref) => 15);

final extendMinutesProvider = NotifierProvider<ExtendMinutesNotifier, int>(
  ExtendMinutesNotifier.new,
);

class ExtendMinutesNotifier extends Notifier<int> {
  @override
  int build() => ref.read(initialExtendMinutesProvider);

  Future<void> set(int minutes) async {
    state = minutes;
    await ref.read(audioChannelProvider).setExtendMinutes(minutes);
  }
}

/// Volume-extend switch read from the native side before the app starts.
final initialVolumeExtendProvider = Provider<bool>((ref) => true);

final volumeExtendProvider = NotifierProvider<VolumeExtendNotifier, bool>(
  VolumeExtendNotifier.new,
);

class VolumeExtendNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(initialVolumeExtendProvider);

  Future<void> set(bool enabled) async {
    state = enabled;
    await ref.read(audioChannelProvider).setVolumeExtend(enabled);
  }
}
