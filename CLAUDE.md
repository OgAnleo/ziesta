# Ziesta

Android sleep timer built with Flutter. When the time runs out it pauses the audio of other
apps (YouTube, Twitch...), after a gradual volume fade during the last minute.
Android only (`--platforms=android`, minSdk 26), package `com.oscaranleo.ziesta`.

## Working style

- Reply to the user in Spanish. Git commit messages in English, imperative ("Add ...").
- The user is learning Dart/Flutter and Kotlin: briefly explain any new syntax or concept
  and why it is done that way. Do not assume Dart knowledge.
- Go step by step and keep changes small: only touch what is needed, no unrequested features,
  dependencies or refactors. Prefer simple, maintainable solutions over clever ones.
- If the user makes a mistake, say so directly and fix it.
- Never ask for, print or commit passwords, `key.properties` or `.jks` files.

## Commands

```
flutter pub get
flutter gen-l10n          # after editing .arb files; then run dart format .
flutter run               # debug on the connected phone
flutter run --release     # release behaviour (R8, no DEBUG banner)
dart format .
flutter analyze           # must report: No issues found!
flutter test              # 20 tests: 7 notifier + 6 screen + 5 settings notifier + 2 settings screen
flutter build apk --release
```

Before every commit: `dart format .`, `flutter analyze`, `flutter test`. CI
(`.github/workflows/ci.yml`) runs the same checks plus a format check.

Kotlin / manifest / resource changes need a full restart (`q`, then `flutter run`);
Dart-only changes work with hot reload (`r`) or hot restart (`R`).

## Architecture

Two layers talking through one `MethodChannel` named `ziesta/audio`.

**Dart (`lib/`)**
- `main.dart`: initializes `SharedPreferences` and reads the native end time before `runApp`
  (overrides `sharedPreferencesProvider` and `initialTimerEndProvider`).
- `app.dart`: `MaterialApp`, themes, localization.
- `core/audio_channel.dart`: Dart side of the channel (`scheduleTimer`, `cancelTimer`,
  `getEnd`, `getExtendMinutes`, `setExtendMinutes`, `getVolumeExtend`, `setVolumeExtend`,
  `openExactAlarmSettings`,
  `requestNotificationPermission`, `shareText`).
- `core/preferences_provider.dart`, `core/app_theme.dart` (minimalist dark theme).
- `features/timer/`: `timer_notifier.dart` (Riverpod: `timerEndProvider`,
  `remainingProvider`), `timer_screen.dart` (wheel 1-180 min, quick buttons 10/20/30/60,
  countdown view with transitions).
- `features/settings/`: theme mode (light/dark only, dark by default), default duration
  (stored in `shared_preferences`: `theme_mode`, `default_minutes`) and extend amount
  (slider 1-60 min, default 15, saved on release) and the "extend with volume button" switch (default on). Both are
  native-owned and read in `main()` via `initialExtendMinutesProvider` / `initialVolumeExtendProvider`.
- `l10n/`: `app_es.arb` is the template, `app_en.arb` the English copy. `l10n.yaml` is in the
  project root. Every key must exist in both files.

**Kotlin (`android/app/src/main/kotlin/com/oscaranleo/ziesta/`)**
- `MainActivity`: channel handler; awaits the notification permission result.
- `TimerScheduler`: exact alarms (`setExactAndAllowWhileIdle`): end alarm -> `TimerReceiver`
  (request code 0), fade alarm at end - 60 s -> `FadeService` (request code 1).
  The extend amount comes from `TimerStore`, not a constant.
- `TimerStore`: owns the end time, `extend_minutes` and `volume_extend` (native `SharedPreferences` `ziesta_timer`).
- `TimerReceiver`: pauses audio (`MediaPauser`: audio focus + `KEYCODE_MEDIA_PAUSE`), clears
  the store, hides the notification, restores the volume 1.5 s later (`goAsync`).
- `FadeService`: `shortService` foreground service that lowers the music volume every second;
  `VolumeFader` saves/restores the original volume. If `volume_extend` is on, it also listens
  for `VOLUME_CHANGED_ACTION`: a STREAM_MUSIC increase (value > previous) is the user and extends
  the timer; `VolumeFader.restore` sets `ignoreIncreasesUntil` (1.5 s) so our own restore is ignored.
- `TimerNotification`: ongoing, silent notification (low-importance channel `ziesta_timer`)
  with a system-drawn countdown and two actions: `ExtendReceiver` (+N min, label from the stored extend amount) and
  `CancelReceiver`.

**Key decision**: the native side is the single source of truth for the end time, so the
notification buttons work with the app closed. Dart only asks for it (`getEnd`) at startup and
every second while a countdown is visible (`TimerEndNotifier.refresh`). The Dart countdown
never cancels native alarms when it reaches zero.

## Tests

`test/helpers/fake_audio_channel.dart` replaces the native channel. Tests override
`audioChannelProvider`, `initialTimerEndProvider`, `sharedPreferencesProvider` and, in screen
tests, `remainingProvider` (avoids pending timers). Tests run in English.

## Release

- Signed with `android/key.properties` + a keystore stored outside the repo (both ignored by
  Git). If `key.properties` is missing, Gradle silently falls back to the debug key.
- R8 (`isMinifyEnabled`, `isShrinkResources`) is disabled for release: with it on, the
  `shared_preferences` plugin crashed at startup with `NoSuchMethodError`.
- Debug and release APKs have different signatures: uninstall before switching.
- APK is published through GitHub Releases (`ziesta-1.0.0.apk`, tag `v1.0.0`).
- Check the signer with `apksigner verify --print-certs` (needs `JAVA_HOME` pointing to
  Android Studio's `jbr`).

## Gotchas

- Windows + Gradle: the project path must be ASCII only (no accents).
- Git on Windows ignores case-only renames: use `git mv a tmp && git mv tmp a`. README
  screenshots live in `docs/screenshots/` with lowercase names (GitHub is case sensitive).
- `flutter gen-l10n` rewrites `lib/l10n/app_localizations*.dart`: always run `dart format .`
  afterwards or the CI format check fails.
- When the user pastes code, make sure each snippet goes into the file with the matching name.

## Known limitations

- Rebooting the phone cancels the pending alarm (accepted, not planned).
- Tested with the YouTube and Twitch apps only.
- The fade changes the system media volume and restores it afterwards.

## Not done yet

- Google Play: needs a privacy policy, an app bundle (`flutter build appbundle`), the exact
  alarm permission declaration, and for a new personal account a closed test (12 testers,
  14 days). Check Google's current requirements first.
