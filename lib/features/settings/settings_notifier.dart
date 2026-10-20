import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziesta/core/preferences_provider.dart';

const maxMinutes = 180;

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
